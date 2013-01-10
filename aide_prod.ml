open Mips
open Ast_Type
open Definition


let rec not_struct = function 
  | TInt | TChar | TPointer _ | TTypenull | TVoid-> true
  | _ -> false


(*fonction qui renvoie true si un type de donnees doit etre aligne*)
let rec aligne = function 
  | TInt | TPointer _ -> true
  | TChar -> false
  | TTypenull -> true
  | TVoid -> true
  | TStruct s -> 
      List.fold_left (fun b var -> b||(aligne var.lv_type)) false s.s_content
  | TUnion u -> 
      List.fold_left (fun b var -> b||(aligne var.lv_type)) false u.u_content


(*fonction qui renvoie la taille d'un type, en le calculant si necessaire, et
 met a la bonne valeur les positions des differents champs pour les structures*)
let rec get_size = function
  | TInt | TPointer _ | TTypenull -> 4
  | TChar _ | TVoid-> 1
  | TStruct s -> if (s.s_size <> 0) then s.s_size  
    else let l = Sort.list 
      (fun var1 var2 -> aligne var1.lv_type > aligne var2.lv_type) 
        s.s_content in 
    begin
      (*on met a la fin de la structure les variables 
qui ne doivent pas necessairement etre alignees*)
      s.s_content <- l ;
      s.s_size <- List.fold_left (fun acc var -> 
	if (aligne var.lv_type)
	then
	  ( var.lv_loc <- acc +((4 - (acc mod 4)) mod 4) ; 
(* renvoie la position alignee juste au dessus de acc.*)
	  acc + ((4 - (acc mod 4)) mod 4) + get_size var.lv_type )
	else 
	  (var.lv_loc <- acc;
	  acc + get_size var.lv_type )
      ) 0 s.s_content ;
      if aligne (TStruct s) then 
        s.s_size <- s.s_size + ((4 -(s.s_size mod 4)) mod 4) ;
(*si une structure doit etre alignee, sa taille doit etre un multiple de 4*)
      s.s_size ;
    end ;
    
    
  | TUnion u -> if (u.u_size <> 0) then u.u_size  
    else (u.u_size <- List.fold_left 
      (fun acc var -> var.lv_loc <- 0 ; max acc (get_size var.lv_type)) 
        0 u.u_content ; u.u_size) 
      
      
      
(*fonction qui verifie que la taille d'un type a bien deja ete calculee
 auparavant. 
Normalement, les fonctions suivantes calculeront la taille 
 d'un type quand on a une declaration de type, si apres on a une occurence 
 de ce type sans la bonne taille, c'est qu'il y a un 
  probleme (de partage de donnees surement)*)		
let size_up_to_date = function 
  | TInt | TVoid | TTypenull | TChar | TPointer _ -> true
  | TStruct s -> s.s_size <> 0;
  | TUnion u -> u.u_size <> 0 
      
(*renvoie le nombre d'octets necessaires pour stocker une variable du type t*)
let taille_arrondie t = 4*((get_size t +3)/4)
  
  
  
(*calcule les tailles des types dans les declarations de type,
 prend en entree un programme, et modifie les champs size des structures*)
let set_size p = 
  let aux = function 
    | TDvar _ | TDf _-> ()
    | TDt dt -> match dt.tdectype with 
	| TDstruct s -> ignore (get_size (TStruct s))
	| TDunion u -> ignore (get_size (TUnion u))
  in
  List.iter aux p.tdecl 
    
    
(*fonction pour mettre a la bonne valeur les positions des variables locales*)
(*pos : derniere case occupee sur la pile par rapport a $fp. 
  commence en -4 dans les declarations de fonctions*)
(*renvoie la derniere case occupee par une variable de l'instruction. 
  Sert a calculer la taille du tableau d'activation*)
let rec set_loc_instr pos = function 
  | TEmpty | TExpression _ | TReturn _ -> pos ;
  | TIf(_,i1,i2_opt) -> begin let pos1 = set_loc_instr pos i1.tinstr in 
    let pos2 = match i2_opt with 
      | None -> 0
      | Some i2 -> set_loc_instr pos i2.tinstr
    in 
    min pos1 pos2
    end ;
  | TWhile(_,i1) -> set_loc_instr pos i1.tinstr
  | TBloc b -> 
      let aux acc decvar =  
	let var = match decvar.tdecvar with 
	  | TLvar v -> v
	  | TGvar _ -> assert false 
	in
	let size = taille_arrondie var.lv_type in 
	let new_pos = assert (size_up_to_date var.lv_type) ;
	  acc - size
	in 
	var.lv_loc <- new_pos ;	
	new_pos 
          
      in 
      let pos' = List.fold_left aux pos (fst b.tbloc)
      in List.fold_left 
           (fun pos2 instr -> min (set_loc_instr pos' instr.tinstr) pos2) 
            pos' (snd b.tbloc) 
	   
	   
(* rq: les locations sont donnees dans le sens inverse des declarations
    par choix du compilateur *)
	   
	   
let set_loc p = 
  let aux = function 
    | TDvar _ | TDt _ -> ()
(*pour les declarations de type, le placement des variables a deja 
  ete fait avec la fonction get_size*)
    | TDf df -> let posf = set_loc_instr (-4) (TBloc df.tcontent) in 
      df.tfun.f_lvar_size <- 4 + (abs posf) ;
 (*on suppose que tous les arguments de la fonction sont alignes sur la pile.*)
      let res_pos = List.fold_right 
        (fun var pos_libre -> var.lv_loc <- pos_libre ; 
	  assert (size_up_to_date var.lv_type) ;
	  let size = taille_arrondie var.lv_type in 
	  pos_libre + size 
        ) df.tfun.f_arg 4
	(*la premiere position libre pour un argument est en +4 
            par rapport a $fp*)
      in df.tfun.f_result_pos <- res_pos 
  in 
  set_size p ;
  List.iter aux p.tdecl
    
let func_begin frame_size =
  mips[Sw(FP, Areg(-4,SP)); Arith (Sub ,FP, SP, Oimm (4));
       Sw(RA, Areg(-4,FP)); Arith(Sub, SP,FP,Oimm(frame_size-4))]
    
let func_end f =
  mips[Label ("f_end_" ^f.f_name) ; Arith(Add,SP,FP,Oimm(f.f_result_pos));
       Lw(RA,Areg(-4,FP));Lw(FP,Areg(0,FP)); Jr(RA) ]
    (*on positionne SP sur le résultat renvoyé par la fonction*)
    
    
(*fonction qui renvoie le type sous un pointeur*)
let pointed_type = function 
  | TPointer t -> t
  | _ -> assert false
      
let new_label = 
  let compteur = ref 0 in 
  function s -> incr compteur ; s ^ (string_of_int !compteur)
    

(*charge dans reg ce qui est à adress. 
  Rq : on ne met dans les registres que des Int Char et Pointer *)
let load_reg reg adress = function 
  | TInt | TPointer _ -> mips [Lw(reg,adress)]
  | TChar -> mips [Lb(reg,adress)]
  | _ -> assert false
      
let store_reg reg adress = function 
  | TInt | TPointer _ -> mips [Sw(reg,adress)]
  | TChar -> mips [Sb(reg,adress)]
  | TVoid -> nop
  | _ -> assert false




