open Definition

  let not_rec = function 
    | Int | Char | Typenull -> true
    | _ -> false

  let equiv t1 t2 = match t1,t2 with  
    | _,_ when (not_rec t1)&& (not_rec t2) -> true
    | Typenull, (Pointer _) | (Pointer _), Typenull -> true 
    | (Pointer Void),(Pointer _) | (Pointer _),(Pointer Void) -> true
    |  _,_  -> t1 = t2


  let rec num = function 
    | Int | Char | Pointer _ | Typenull -> true
    | _ -> false


  let rec lvalue = function 
    | Variable _ -> true
    | Pointer_access _ -> true
    | Access_field (e,_) -> lvalue e.exp
    | _ -> false


module SMap = Map.Make(String) 

(*type des éléments de l'environnement, il doit contenir les variables, les fonctions, 
et les structures et unions de types*)
type mapelt = 
	| Var of ttype
	| Fun of ttype * (ttype list) (*type de retour, plus type des arguments*)
	| Str of (ttype * string) list
	| Uni of (ttype * string) list
(* on conserve dans l'environnement le type de toutes les variables et les fonctions. 
Le champ arg permet de savoir si l'indent donné correspond à une variable, ou une fonction
et donne les types des arguments de la fonction*)

exception Type_error of position * string
exception Argtype_error of position * string * (ttype list)
(*== erreur à la position pos, la fonction (l'opérateur string) a eu les types de la liste en argument *)

	
(*dit si un opérateur binaire est un opérateur de comparaison ou non*)
let compop = function 
	| Eq | Neq | Lt | Gt | Leq | Geq -> true
	| BPlus | BMinus | Mul | Div | Mod | Or | And -> false
	
let ispointer = function 
	| Typenull | Pointer _ -> true
	| Int | Char | Struct _ | Union _ | Void -> false
	
(*pour ne pas avoir de conflit entre une variable et une structure qui auraient le même nom, 
dans la map de l'environnement, on rajoute les préfixes "var_" "str_" "uni_" "fun_" devant 
le nom de l'identificateur (on ne peut pas lier plusieurs fois un id dans une map)*)
let rec bien_forme env = function
	| Void | Int | Char | Typenull -> true
	| Pointer t -> bien_forme env t 
	| Struct s -> begin try 
		match SMap.find ("str_"^s) env with 
		| Var _ | Fun _ | Uni _ -> false
		| Str l -> List.fold_left (fun b -> fun t -> b&&(bien_forme env (fst t))) true l
		with Not_found -> false
		end
	| Union s -> begin try 
		match SMap.find ("uni_"^s) env with 
		| Var _ | Fun _ | Str _ -> false
		| Uni l -> List.fold_left (fun b -> fun t -> b&&(bien_forme env (fst t))) true l
		with Not_found -> false
		end

		
let rec getType env n =  match n.exp with
  | Entier 0 -> n.data <- Typenull
  | Entier _ -> n.data <- Int
  | Chaine _ -> n.data <- Pointer(Char)
  | Variable s -> begin try
	let envt = SMap.find ("var_"^s) env in
	match envt with
	| Var t -> n.data <- t
	| _ -> assert false
	with Not_found -> raise (Type_error (n.pos,(s ^ " : undeclared")))
  end
  | Sizeof t -> 
	if bien_forme env t then
	  if not (equiv t Void) then n.data <- Int 
	  else raise (Type_error (n.pos,("trying to get sizeof void")))
	else raise (Type_error (n.pos,(string_of_type t ^ " est mal formé") ))
	  
  | Unop (Adr_get, e) -> 
    getType env e ;
    if lvalue e.exp 
    then n.data <- e.data
    else raise (Type_error (n.pos,"trying to get adress of expression with no left value"))
      
  | Pointer_access(e) -> begin
    getType env e ;
    match e.data with
    | Pointer t -> n.data <- t
    | _ -> raise (Type_error (n.pos,"pointer access of a non pointer expression"))
  end
    
  | Access_field (e,x) ->
    begin
      getType env e ;
      match e.data with
      | Union s ->
	let et = SMap.find ("uni_"^s) env in
	begin
	  match et with
	  | Uni l -> begin try
			     n.data <- fst (List.find (fun (t,y) -> y = x) l);
	    with Not_found -> raise (Type_error (n.pos,"l'identificateur " ^x^ "n'apparait pas dans " ^ "uni " ^ s ))
	  end
	  | _ -> assert false
	end
      | Struct s -> begin
	let et = SMap.find ("str_"^s) env in
	match et with
	| Str l -> begin try
			   n.data <- fst (List.find (fun (t,y) -> y = x) l) ;
	  with Not_found -> raise (Type_error (n.pos,"l'identificateur " ^x^ "n'apparait pas dans " ^ "str " ^ s ))
	end
	| _ -> assert false
      end
      | _ -> raise (Type_error (n.pos,("request for member '" ^x^ "' in something not a structure or union")))
    end
      
  | Assignement (e1,e2) ->
    if lvalue e1.exp then
      begin getType env e1 ; getType env e2 ;
	let t1 = e1.data and t2 = e2.data in
	if equiv t1 t2 then n.data <- t1
	else
	  raise (Type_error (n.pos,"incompatible types when assigning to type " ^ (string_of_type t1) ^" from type " ^ (string_of_type t2)))
      end
    else raise (Type_error (n.pos,"lvalue required as left operand of assignment" ))
      
      
  | Unop(op,e) when (op= PPleft)||(op =PPright)||(op = MMleft)||(op = MMright) ->
    if lvalue e.exp then
      begin
	getType env e ;
	let t = e.data in
	if num t then n.data <- t
	else raise (Argtype_error (n.pos,(string_of_unop op),[t]))
      end
    else raise (Type_error (n.pos,"lvalue required as left operand of assignment" ))
      
  | Unop(op,e) when (op = UPlus)||(op = UMinus) -> 
    getType env e ;
    let t = e.data in
    if equiv t Int
    then n.data <- Int
    else raise (Argtype_error (n.pos,(string_of_unop op),[t])) 
      
  | Unop(Not,e) -> getType env e ; let t = e.data in if num t then n.data <- Int else raise (Argtype_error (n.pos,(string_of_unop Not),[t]))
  | Unop (_,_) -> assert false (*tous les autres cas ont été traités avant, c'est pour éviter un warning*)
    
  | Binop(op,e1,e2) when compop op -> getType env e1 ; getType env e2 ; 
    let t1 = e1.data and t2 = e2.data in
    if (equiv t1 t2)&&(num t1) then n.data <- Int
    else raise (Argtype_error (n.pos,(string_of_binop op),[t1;t2]))
      
  | Binop(op,e1,e2) -> getType env e1 ; getType env e2 ;
    let t1 = e1.data and t2 = e2.data in
    if (equiv t1 t2)&&(num t1) then n.data <-Int
else
      if (ispointer t1)&&(equiv t2 Int)&&((op = BPlus)||(op = BMinus))
      then n.data <- t1
      else
	if (ispointer t2)&&(equiv t1 Int)&&(op = BPlus)
	then n.data <- t2
	else
	  if (ispointer t1)&&(equiv t1 t2)&&(op = BMinus)
	  then n.data <- Int
	  else raise (Argtype_error (n.pos,(string_of_binop op),[t1;t2])) (*risque d'erreur important*)
	    
  | Call(f,l) -> begin try
			 match SMap.find ("fun_"^f) env with
| Fun (t,lt) -> List.iter (getType env) l ;
  let lt'= List.map (fun e -> e.data) l in
  let b = List.fold_left2 (fun b -> fun t1 -> fun t2 -> b&&(equiv t1 t2)) true lt lt' in
  if b then n.data <- t else raise (Argtype_error (n.pos,("function '" ^f^"'"),lt'))
| _ -> assert false
  
    with Not_found -> raise (Type_error (n.pos,"unbound function '"^f^"'"))
    | Invalid_argument _ -> raise (Type_error (n.pos, "wrong number of argument for function '"^f^"'"))
  end
    
