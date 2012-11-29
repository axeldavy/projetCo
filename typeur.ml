open Ast
open Ast_Type
open Definition



exception Type_error of position * string
exception Argtype_error of position * string * (mtype list)
(*== erreur à la position pos, la fonction (l'opérateur) string a eu les 
types de la liste en argument *)

(* on conserve dans l'environnement le type de toutes les variables et 
les fonctions, ainsi que les structures et unions
Le champ arg permet de savoir si l'indent donné correspond à une variable, 
ou une fonction et donne les types des arguments de la fonction*)
module SMap = Map.Make(String) 

let not_rec = function 
  | TInt | TChar  | TTypenull -> true
  | _ -> false
        
let equiv t1 t2 = match t1,t2 with  
  | _,_ when (not_rec t1)&& (not_rec t2) -> true
  | TTypenull, (TPointer _) | (TPointer _), TTypenull -> true 
  | (TPointer TVoid),(TPointer _) | (TPointer _),(TPointer TVoid) -> true
  |  _,_  -> t1 = t2
      

let rec num = function 
  | TInt | TChar | TPointer _ | TTypenull -> true
  | _ -> false
      

let rec lvalue = function 
  | TVariable _ -> true
  | TPointer_access _ -> true
  | TAccess_field (e,_) -> lvalue e.texp
  | _ -> false
      
      
let rec mtype_of_ttype env pos= function 
  | Int -> TInt 
  | Char -> TChar
  | Void -> TVoid
  | Typenull -> TTypenull
  | Struct id -> begin try match SMap.find ("str_"^id) env with 
      | MStr s -> TStruct s
      | _ -> assert false
    with Not_found -> raise (Type_error (pos,"structure '"^id^"' is undefined"))
    end
  | Union id -> begin try match SMap.find ("uni_"^id) env with 
      | MUni u -> TUnion u 
      | _ -> assert false
    with Not_found -> raise (Type_error (pos,"structure '"^id^"' is undefined"))
    end
  | Pointer t -> TPointer (mtype_of_ttype env pos t)	
      
let rec ttype_of_mtype = function 
  | TInt -> Int 
  | TChar -> Char
  | TVoid -> Void
  | TTypenull -> Typenull
  | TStruct s ->  Struct s.s_name
  | TUnion u ->  Union u.u_name 
  | TPointer t -> Pointer (ttype_of_mtype t)	
      
let string_of_mtype t= string_of_type (ttype_of_mtype t)
  
  
(*dit si un opérateur binaire est un opérateur de comparaison ou non*)
let compop = function 
  | Eq | Neq | Lt | Gt | Leq | Geq -> true
  | BPlus | BMinus | Mul | Div | Mod | Or | And -> false
      
let ispointer = function 
  | TTypenull | TPointer _ -> true
  | TInt | TChar | TStruct _ | TUnion _ | TVoid -> false
      

(*pour ne pas avoir de conflit entre une variable et une structure qui 
auraient le même nom, dans la map de l'environnement, on rajoute les préfixes 
"var_" "str_" "uni_" "fun_" devant le nom de l'identificateur 
(on ne peut pas lier plusieurs fois un id dans une map)*)

(*on suppose que les types dans l'environnement sont bien formés*)
let rec bien_forme env t = try match t with
  | TVoid | TInt | TChar | TTypenull -> true
  | TPointer t -> bien_forme env t      
  | TStruct s -> let _ =  SMap.find ("str_"^s.s_name) env in true
  | TUnion u ->let _ =  SMap.find ("uni_"^u.u_name) env in true
with Not_found -> false
  
  
let var_decType local env dv =
  (*local est un booléen qui détermine si les variables que l'on déclares sont 
globales ou locales*) 
  let t,id = dv.decvar in 
	let t' = mtype_of_ttype env dv.decvar_pos t in 
	let v = if local then TLvar {lv_name = id ; lv_loc = 0 ; lv_type = t'} 
	else TGvar {gv_name = id ; gv_type = t'} 
	in 
        (*vérification de non redéclaration*)
	begin try match SMap.find ("var_"^id) env with 
	  | MVar (TGvar _) when local -> ()
	  | MVar (TGvar _) -> raise (Type_error 
              (dv.decvar_pos, "trying to redefine variable '"^id^"'"))
	  | MVar (TLvar _) -> raise (Type_error 
              (dv.decvar_pos, "trying to redefine variable '"^id^"'"))
	  | _ -> assert false
	with Not_found -> () ;
	end ;
        if (SMap.mem ("fun_"^id) env)&&(not local) 
        then raise (Type_error
          (dv.decvar_pos, "trying to redefine variable '"^id^"'")) ;
	let env' = SMap.add ("var_"^id) (MVar v) env
	in 
	if not (equiv t' TVoid) then 
	  env' , {tdecvar = v ; tdecvar_pos = dv.decvar_pos}
	else raise (Type_error 
          (dv.decvar_pos, "variable '"^(id)^"' declared void" ))
	  


(*fonction pour typer les expressions*)
let rec exprType env n =  match n.exp with
  | Entier i when i =Int32.zero -> 
      {texp = TEntier Int32.zero ;texp_pos = n.exp_pos ; texp_type = TTypenull}
      
  | Entier i -> {texp = TEntier i ; texp_pos = n.exp_pos ; texp_type = TInt}
      
  | Chaine s -> 
      {texp = TChaine s; texp_pos = n.exp_pos ; texp_type = TPointer(TChar)}
      
  | Character c -> 
      {texp = TCharacter c; texp_pos = n.exp_pos ; texp_type = TChar}
      
  | Variable id -> begin try
      let v = SMap.find ("var_"^id) env in
      match v with
	| MVar (TGvar(x)) -> 
            {texp = TVariable(TGvar(x)) ; 
            texp_pos = n.exp_pos ; texp_type = x.gv_type}
	| MVar (TLvar(x)) -> 
            {texp = TVariable(TLvar(x)) ; 
            texp_pos = n.exp_pos ; texp_type = x.lv_type}
	| _ -> assert false
    with Not_found -> raise (Type_error (n.exp_pos,(id ^ " : undeclared")))
    end
      
  | Sizeof t' -> 
      let t = mtype_of_ttype env n.exp_pos t' in 
      if bien_forme env t then  
      if not (equiv t TVoid) 
      then {texp = TSizeof t ; texp_pos = n.exp_pos ; texp_type = TInt}
      else raise (Type_error (n.exp_pos,("trying to get sizeof void")))  
      else raise (Type_error (n.exp_pos,(string_of_mtype t) ^" est mal formé"))
	
  | Unop (Adr_get, e) -> 
      let e' = exprType env e in 
      if lvalue e'.texp 
      then {texp = TUnop(Adr_get, e') ; 
      texp_pos = n.exp_pos ; texp_type = TPointer (e'.texp_type) }
      else raise (Type_error 
        (n.exp_pos,"trying to get adress of expression with no left value"))
        
  | Pointer_access(e) -> begin
      let e' = exprType env e in 
      match e'.texp_type with
        | TPointer t -> 
            {texp = TPointer_access(e'); texp_pos = n.exp_pos ; texp_type = t}
        | _ -> raise (Type_error 
            (n.exp_pos,"pointer access of a non pointer expression"))
    end
      
  | Access_field (e,x) ->
      begin
        let e' = exprType env e in 
        match e'.texp_type with
          | TUnion u ->
	      if SMap.mem ("uni_"^u.u_name) env then 
		try
	          { texp = TAccess_field(e',x); 
                  texp_pos = n.exp_pos ; 
                  texp_type = snd (List.find (fun (y,t) -> y = x) u.u_content)};
		with Not_found -> raise (Type_error 
                  (n.exp_pos,"l'identificateur " ^x^ "n'apparait pas dans " ^ 
                    "uni " ^ u.u_name ))
	      else
		raise (Type_error 
                  (n.exp_pos,"undefined type : union '" ^u.u_name^"'" ))
          | TStruct s -> begin
	      if SMap.mem ("str_"^s.s_name) env then 
		try
		  { texp = TAccess_field(e',x); 
                  texp_pos = n.exp_pos ; 
                  texp_type = snd (List.find (fun (y,t) -> y = x) s.s_content)};
		with Not_found -> raise (Type_error 
                  (n.exp_pos,"l'identificateur " ^x^ "n'apparait pas dans " ^ 
                    "str " ^ s.s_name ))
	      else 
		raise (Type_error 
                  (n.exp_pos,"undefined type : structure '" ^s.s_name^"'" ))
            end
          | _ -> raise (Type_error 
              (n.exp_pos,("request for member '" ^x^ 
                "' in something not a structure or union")))
      end
        
  | Assignement (e1,e2) ->
      let e1' = exprType env e1 and e2' = exprType env e2 in 
      if lvalue e1'.texp then
        let t1 = e1'.texp_type and t2 = e2'.texp_type in
	if equiv t1 t2 then 
          {texp = TAssignement (e1',e2'); texp_pos =n.exp_pos ; texp_type = t1}
	else
	  raise (Type_error 
            (n.exp_pos,"incompatible types when assigning to type " ^ 
              (string_of_mtype t1) ^" from type " ^ (string_of_mtype t2)))
      else raise (Type_error 
        (n.exp_pos,"lvalue required as left operand of assignment" ))
        
  | Unop(op,e) when (op=PPleft)||(op=PPright)||(op=MMleft)||(op = MMright) ->
      let e' = exprType env e in 
      if lvalue e'.texp then
	let t = e'.texp_type in
	if num t then 
          {texp = TUnop(op, e'); texp_pos = n.exp_pos ; texp_type = t}
	else raise (Argtype_error (n.exp_pos,(string_of_unop op),[t]))
      else raise (Type_error 
        (n.exp_pos,"lvalue required as left operand of assignment" ))
        
  | Unop(op,e) when (op = UPlus)||(op = UMinus) -> 
      let e' = exprType env e in
      let t = e'.texp_type in
      if equiv t TInt
      then {texp = TUnop(op,e') ; texp_pos = n.exp_pos ; texp_type = TInt}
      else raise (Argtype_error (n.exp_pos,(string_of_unop op),[t])) 
        
  | Unop(Not,e) -> let e' = exprType env e in 
    let t = e'.texp_type in 
    if num t then 
      {texp = TUnop (Not,e') ; texp_pos = n.exp_pos ; texp_type = TInt} 
    else raise (Argtype_error (n.exp_pos,(string_of_unop Not),[t]))
      
  | Unop (_,_) -> assert false 
      (*tous les autres cas ont été traités avant, 
        c'est pour éviter un warning*)
      
  | Binop(op,e1,e2) when compop op -> 
      let e1' = exprType env e1 and e2'= exprType env e2 in 
      let t1 = e1'.texp_type and t2 = e2'.texp_type in
      if (equiv t1 t2)&&(num t1) 
      then 
        {texp = TBinop(op,e1',e2') ; texp_pos = n.exp_pos ; texp_type = TInt}
      else 
        raise (Argtype_error (n.exp_pos,(string_of_binop op),[t1;t2]))
        
  | Binop(op,e1,e2) -> let e1' = exprType env e1 and e2' = exprType env e2 in
    let t1 = e1'.texp_type and t2 = e2'.texp_type in
    let t =
      if (ispointer t1)&&(equiv t2 TInt)&&((op = BPlus)||(op = BMinus))
      then t1
      else
	if (ispointer t2)&&(equiv t1 TInt)&&(op = BPlus)
	then t2
	else
	  if (ispointer t1)&&(equiv t1 t2)&&(op = BMinus)
	  then TInt
          else
            if (equiv t1 t2)&&(num t1) 
            then TInt
	    else raise (Argtype_error (n.exp_pos,(string_of_binop op),[t1;t2]))
    in 
    {texp = TBinop(op,e1',e2') ; texp_pos = n.exp_pos; texp_type = t}
	
  | Call(id,l) -> begin try
      match SMap.find ("fun_"^id) env with
	| MFun f -> let l = List.map (exprType env) l in
	  let lt'= List.map (fun e -> e.texp_type) l in
	  let b = List.fold_left2 
            (fun b (t1,_) t2 -> b&&(equiv t1 t2)) true f.f_arg lt' in
	  if b then 
            {texp = TCall(f,l); texp_pos = n.exp_pos ; texp_type = f.f_type }
	  else raise (Argtype_error 
            (n.exp_pos,("function '" ^f.f_name^"'"),lt'))
	| _ -> assert false
            
    with Not_found -> raise (Type_error (n.exp_pos,"unbound function '"^id^"'"))
      | Invalid_argument _ -> raise (Type_error 
          (n.exp_pos, "wrong number of argument for function '"^id^"'"))
    end


      
let rec instrType env t0 i = match i.instr with 
  | Empty -> {tinstr = TEmpty ; tinstr_pos = i.instr_pos}

  | Expression e -> 
      {tinstr = TExpression (exprType env e) ; tinstr_pos = i.instr_pos}

  | Return None -> 
      if t0 = TVoid 
      then {tinstr = TReturn None ; tinstr_pos = i.instr_pos}
      else raise (Type_error 
        (i.instr_pos,"le type de retour est "^
          (string_of_mtype t0)^" au lieu de void "))

  | Return (Some e) -> let e' = exprType env e in 
    if equiv t0 e'.texp_type 
    then {tinstr = TReturn (Some e') ; tinstr_pos = i.instr_pos}
    else raise (Type_error 
      (i.instr_pos,"le type de retour est "^(string_of_mtype t0)
        ^" au lieu de "^(string_of_mtype e'.texp_type)))

  | If(e,i1,i2) -> let e' = exprType env e in 
    if num e'.texp_type then 
      let i1' = instrType env t0 i1 in 
      let i2' = match i2 with 
	| None -> None
	| Some i -> Some (instrType env t0 i)
      in 
      {tinstr = TIf(e',i1',i2'); tinstr_pos = i.instr_pos}
    else raise (Type_error 
      (i.instr_pos, "used type " ^(string_of_mtype e'.texp_type)^
        " value where scalar is required"))

  | While(e,i1) -> let e' = exprType env e 
		   and i1' = instrType env t0 i1 in 
    if num e'.texp_type then 
      {tinstr = TWhile(e',i1') ; tinstr_pos = i.instr_pos}
    else raise (Type_error 
      (i.instr_pos, "used type " ^(string_of_mtype e'.texp_type)^
        " value where scalar is required"))

  | For(l1,e,l2,i1) -> 
      let aux e = 
        {tinstr = TExpression (exprType env e) ; tinstr_pos = e.exp_pos} in
      let l1' = List.map aux l1
      and l2' = List.map aux l2 in
      let e' = match e with 
	| None -> 
            {texp = TEntier Int32.one ; 
            texp_pos = i1.instr_pos ; texp_type = TInt}
	| Some e -> exprType env e 
      in		
      let i1' = instrType env t0 i1 in 
      if num e'.texp_type then 
	let ti = 
          {tinstr = TBloc {tbloc = [],(l2'@[i1']) ; 
          tbloc_pos = i1'.tinstr_pos}; tinstr_pos =i1'.tinstr_pos} 
        in
	let ti = {tinstr= TWhile (e',ti) ; tinstr_pos = i1'.tinstr_pos } in 
	let ti = {tinstr = TBloc {tbloc = [], l1'@[ti] ; 
        tbloc_pos = i.instr_pos} ; tinstr_pos = i.instr_pos} 
        in
	ti
	  (*on remplace l'instruction for, par une autre équivalente avec 
            while, vérifier que c'est bien à ça que ça correspond*)
      else raise (Type_error 
        (i.instr_pos, "used type " ^(string_of_mtype e'.texp_type)^
          " value where scalar is required"))

  | Bloc b -> let l1,l2 = b.bloc in 
    let aux = fun (e,l) dv -> let e',dv' = var_decType true e dv 
                               in e', (dv'::l) 
    in 
    let env',l1' = List.fold_left aux (env,[]) l1 in 
    let l2' = List.map (instrType env' t0) l2 in 
    {tinstr = TBloc{tbloc = l1',l2' ; tbloc_pos = b.bloc_pos} ; 
    tinstr_pos = i.instr_pos}
    

  
let rec fileType env l = 
  if l = [] then (env,[]) 
  else 
    match List.hd l with 
      | Dvar dv -> 
          if not (bien_forme env 
            (mtype_of_ttype env dv.decvar_pos (fst (dv.decvar)))) 
          then raise (Type_error 
            (dv.decvar_pos,"storage size of '"^(snd dv.decvar)^"' is unknown"))
          else 
	  let env',dv' = var_decType false env dv in 
	  let env2,l2 = fileType env' (List.tl l) in 
	  env2, (TDvar dv')::l2

      | Dt dt -> begin
	  match dt.dectype with 
	    | Dstruct (id,lvar) ->
		let _ = List.fold_left (fun li dv -> 
		  let x = snd dv.decvar in 
		  if List.mem x li
		  then raise (Type_error 
                    (dt.dectype_pos, "argument '"^x^"' is defined twice"))
		  else x::li) [] lvar 
		in
                let envtemp = SMap.add ("str_"^id) 
                  (MStr {s_name = id ;s_content = [] ; s_size = 0 }) env in 
		let new_stru = 
		  let l = List.map (fun dv ->
		    let t = mtype_of_ttype envtemp dv.decvar_pos (fst dv.decvar)
                    in 
		    if equiv t TVoid 
                    then raise (Type_error 
                      (dv.decvar_pos, "variable '"^(snd dv.decvar)^
                        "' is declared void")) ;
		    (snd dv.decvar,t)
		  ) lvar 
		  in
		  {s_name = id ; s_content = l ; s_size = 0}
		in
                if(SMap.mem ("str_"^id) env) || (SMap.mem ("uni_"^id) env)
                then raise (Type_error 
                  (dt.dectype_pos,"already defined structure '"^id^"'")); 
		let env' = (SMap.add ("str_"^id) (MStr new_stru) env)
		and dv' = TDt {tdectype = TDstruct new_stru ; 
                tdectype_pos = dt.dectype_pos} 
                in
		List.iter 
                  (fun (id,t) -> if (not (bien_forme env' t)) 
                    || (equiv t (TStruct new_stru)) then
		      raise (Type_error 
                        (dt.dectype_pos,"storage size of '"^id^
                          "' is unknown")) )
		  new_stru.s_content ;
		let env2,l2 = fileType env' (List.tl l) in 
		env2,(dv'::l2)

	    | Dunion (id,lvar) -> 
		let _ = List.fold_left (fun li dv -> 
		  let x = snd dv.decvar in 
		  if List.mem x li
		  then raise (Type_error 
                    (dt.dectype_pos, "argument '"^x^"' is defined twice"))
		  else x::li) [] lvar 
		in
                let envtemp = SMap.add ("uni_"^id) 
                  (MUni {u_name = id ;u_content = [] ; u_size = 0 }) env in
		let new_uni = 
		  let l = List.map (fun dv ->
		    let t = mtype_of_ttype envtemp dv.decvar_pos (fst dv.decvar)
                    in 
		    if equiv t TVoid 
                    then raise (Type_error 
                      (dv.decvar_pos, "variable '"^(snd dv.decvar)^
                        "' is declared void")) ;
		    (snd dv.decvar,t)
		  ) lvar in
		  {u_name = id ; u_content = l ; u_size = 0}
		in
               if(SMap.mem ("str_"^id) env) || (SMap.mem ("uni_"^id) env)
                then raise (Type_error 
                  (dt.dectype_pos,"already defined union '"^id^"'")); 
		let env' = (SMap.add ("uni_"^id) (MUni new_uni) env)
		and dv' = TDt {tdectype = TDunion new_uni ; 
                tdectype_pos = dt.dectype_pos} in
		List.iter (fun (id,t) -> if (not (bien_forme env' t)) || 
                  (equiv t (TUnion new_uni)) then
		  raise (Type_error 
                    (dt.dectype_pos,"storage size of '"^(id)^"' is unknown")) )
		  new_uni.u_content ;
		let env2,l2 = fileType env' (List.tl l) in 
		env2,(dv'::l2)
	end 

      | Df df -> let t,id,lvar,b = df.decfun in 
	let t' = mtype_of_ttype env df.decfun_pos t in 
	if (SMap.mem ("fun_"^id) env) || (SMap.mem ("var_"^id) env) 
	then raise (Type_error 
          (df.decfun_pos, "trying to redefine function '"^id^"'")) ; 
	List.iter (fun (t,x) -> 
          if not (bien_forme env (mtype_of_ttype env df.decfun_pos t)) 
	  then raise (Type_error 
	    (df.decfun_pos,"type of variable '"^x^"' not well formed") )
	) lvar ; 
	let _ = List.fold_left (fun lvar (_,x) -> 
	  if List.mem x lvar 
	  then raise (Type_error (df.decfun_pos, "argument '"^x^
            "' is defined twice"))
	  else x::lvar) [] lvar 
	in
	let new_fun = 
	  {f_name = id; 
	  f_type = t' ; 
	  f_arg = List.map 
              (fun (t,x) -> (mtype_of_ttype env df.decfun_pos t,x)) lvar
          }
	in
	let env' = SMap.add ("fun_"^id) (MFun new_fun) env in
	let env_f = List.fold_left (fun e (t,x) -> SMap.add ("var_"^x) 
	  (MVar (TLvar {lv_name = id ; lv_loc = 0 ; 
          lv_type = mtype_of_ttype env df.decfun_pos t})) e) 
	  env' lvar in
	let new_b = match (instrType env_f t' 
          {instr = Bloc b ; instr_pos = b.bloc_pos}).tinstr with 
	  | TBloc b -> b
	  | _ -> assert false
	in 
	let dv' = TDf {tfun = new_fun ; 
        tcontent = new_b ; tdecfun_pos = df.decfun_pos}
	in
	let env2,l2 = fileType env' (List.tl l) in 
	env2,(dv'::l2)
          
let typage p = 
  let sbrk = MFun {f_name = "sbrk" ; 
  f_type = TPointer (TVoid) ; 
  f_arg = [TInt,"n"]}
  and putchar = MFun {f_name = "putchar" ; 
  f_type = TInt ; f_arg = [TInt,"c"]} 
  in 
  let env0 = SMap.add "fun_sbrk" sbrk (SMap.singleton "fun_putchar" putchar) in
  let env,l = (fileType env0 p.decl) in 
  let pos = (Lexing.dummy_pos,Lexing.dummy_pos) in 
  (*la position renvoyée des erreur ne correspond ici à rien*)
  try begin 
    let f' = SMap.find "fun_main" env in 
    match f' with 
      | MFun f -> if not (f.f_type = TInt) 
        then raise (Type_error (pos,"invalid type for function main")) ;
	  begin 
	    match f.f_arg with 
	      | [] | [TInt,_ ; TPointer(TPointer(TChar)),_] -> () ;
	      | _ -> 
		  let lt = List.map (fun (t,id) -> t) f.f_arg in 
		  raise (Argtype_error (pos,"main",lt))
	  end ;
      | MVar _ | MUni _ | MStr _ -> assert false
  end ;
    {tdecl = l}
  with Not_found -> raise (Type_error (pos,"function main is missing"))
    
