open Typeur
open Mips
open Ast_Type
open Definition
open Aide_prod
open List
	

let move adr_depart adr_arrivee size = failwith "TODO"
	(*fonction pour déplacer des blocs de données,
	doit pouvoir marcher même sur des données non alignées*)
	
let rec lvalue_code e = match e.texp with
  |TCharacter _ |TEntier _ |TChaine _ |TAssignement _ |TCall _ -> assert false
  |TUnop _ |TBinop _ |TSizeof _ -> assert false 
  |TVariable var -> begin match var with 
    | TGvar v -> mips [La(A0,"var_"^v.gv_name)]
    | TLvar v -> mips [Arith(Add,A0,FP,Oimm(v.lv_loc))] 
  end 
  |TPointer_access e ->  code_expr e   
  |TAccess_field (e,x) -> begin let lval_code = lvalue_code e in
	match e.texp_type with
	| TUnion uni -> let str_var = List.find (fun var -> var.lv_name = x) uni.u_content in
			lval_code ++ (mips [Arith(Add,A0,A0,Oimm(str_var.lv_loc))])
	| TStruct stru -> let str_var = List.find (fun var -> var.lv_name = x) stru.s_content in
			  lval_code ++ (mips [Arith(Add,A0,A0,Oimm(str_var.lv_loc))])
	| _ -> assert false
  end
  
and code_expr e = 
  match e.texp with
  |TCharacter c -> mips[Li (A0,int_of_char c)]
  |TEntier i -> mips[Li32 (A0,i)]
  |TChaine s -> begin try
			mips[La(A0,Hashtbl.find Typeur.echaine s)] 
    with Not_found -> assert false 
	end
  |TVariable (TGvar gvar) -> begin match(gvar.gv_type) with
    | TInt | TChar | TPointer _ -> mips[Lw(A0,Alab(0,"var_"^gvar.gv_name))]
    | TStruct stru -> failwith "TODO"
    | TUnion uni -> failwith "TODO"				  
    | TVoid | TTypenull -> assert false
    end
	
  |TVariable (TLvar lvar) -> begin match(lvar.lv_type) with
    | TInt | TChar | TPointer _ -> mips[Lw(A0,Areg(lvar.lv_loc,FP))]
    | TStruct stru -> failwith "TODO"
    | TUnion uni -> failwith "TODO"				  
    | TVoid | TTypenull -> assert false
    end 
	
  |TPointer_access e when num (pointed_type e.texp_type) -> 
			let code = code_expr e and type1 = pointed_type (e.texp_type) in (* on suppose sortier dans A0. A completer et corriger*)
			code ++ load_reg A0 (Areg(0,A0)) type1
			
  |TPointer_access e -> failwith "TODO"
			
  |TAccess_field (e,x) -> begin let code_adr = lvalue_code e in
				match e.texp_type with (* on suppose sortier dans A0. A completer et corriger*)
				| TUnion uni -> let str_var = List.find (fun var -> var.lv_name = x) uni.u_content in
						code_adr ++ (mips[Lw(A0,Areg(str_var.lv_loc,A0))])
				| TStruct stru -> let str_var = List.find (fun var -> var.lv_name = x) stru.s_content in
						  code_adr ++ (mips[Lw(A0,Areg(str_var.lv_loc,A0))])
					| _ -> assert false
  end 
  |TAssignement (e1,e2) -> let code_adr = lvalue_code e1 in 
			   let type1 = e1.texp_type in (*ici, type1 est un pointeur*)
			   let code_e = code_expr e2 in (* on suppose sortier dans A0. A completer et corriger*)
			   code_adr 
			   ++ (mips [Arith(Sub,SP,SP,Oimm(4))]) 
			   ++ store_reg A0 (Areg(0,SP)) type1 
			   ++ code_e
			   ++ load_reg A1 (Areg(0,SP)) type1 
			   ++ store_reg A0 (Areg(0,A1)) e2.texp_type 
			   ++ mips[Arith(Add,SP,SP,Oimm(4))]
  |TCall (f,[e]) when f.f_name = "putchar"-> let c = code_expr e in c++ (mips [Li (V0, 11) ; Syscall ])
  
  |TCall (f,[e]) when f.f_name = "sbrk"-> let c = code_expr e in c ++ (mips [Li (V0, 9); Syscall; Move(A0,V0)]) 
  
  |TCall (f,l) -> (* on suppose sortier dans A0. A completer et corriger*)
    let put_arg e =  
      (code_expr e) ++ store_reg A0 (Areg(-4,SP)) TInt ++ (mips [Arith(Sub,SP,SP,Oimm(4))]) (* les arguments sont toujours alignés*)
    in 
    let taille_resultat = taille_arrondie f.f_type in
    let code_arg = List.fold_left (fun acc e -> acc ++ (put_arg e)) nop l in
    (mips[Arith(Sub,SP,SP,Oimm(taille_resultat)) ]) 
	++ code_arg 
	++ (mips [Jal("fun_"^f.f_name) ] (*à l'issue de l'appel de fonction, SP pointe sur le résultat, et le résultat est sur la pile*)
	++ store_reg A0 (Areg(0,SP)) f.f_type (*pas de problème ici normalement puisque le résultat est aligné*)
	++ mips[Arith(Add,SP,SP,Oimm(taille_resultat))])
	
  |TUnop (op,e) -> (begin let type1 = e.texp_type in
     match op with
    | PPleft -> let code_adr = lvalue_code e in
		code_adr ++ load_reg T0 (Areg(0,A0)) type1 ++ mips[ Arith(Add,T0,T0,Oimm(1)) ] ++ store_reg T0 (Areg(0,A0)) type1 ++ mips[ Move(A0,T0)] 
    | PPright -> let code_adr = lvalue_code e in
		 code_adr ++ load_reg T0 (Areg(0,A0)) type1 ++ mips[ Arith(Add,T0,T0,Oimm(1)) ] ++ store_reg T0 (Areg(0,A0)) type1 ++ mips[ Arith(Sub,A0,T0,Oimm(1))] 
    | MMleft -> let code_adr = lvalue_code e in
		code_adr ++ load_reg T0 (Areg(0,A0)) type1 ++ mips[Arith(Sub,T0,T0,Oimm(1)) ] ++ store_reg T0 (Areg(0,A0)) type1 ++ mips[ Move(A0,T0)] 
    | MMright -> let code_adr = lvalue_code e in
		 code_adr ++ load_reg T0 (Areg(0,A0)) type1 ++ mips[Arith(Sub,T0,T0,Oimm(1)) ] ++ store_reg T0 (Areg(0,A0)) type1 ++ mips[ Arith(Add,A0,T0,Oimm(1))] 
    | Adr_get -> lvalue_code e 
    | Definition.Not -> (code_expr e) ++ (mips[Mips.Not(A0,A0)])
    | UMinus -> let code_e = code_expr e in 
		code_e ++ (mips[Neg(A0,A0)])
    | UPlus  -> code_expr e
      
    | PointerPPleft -> let code_adr = lvalue_code e in
		       let taille = get_size (pointed_type e.texp_type) in (*t = taille du type pointé*)
		       code_adr ++ (mips[Lw(T0,Areg(0,A0)) ; Arith(Add,T0,T0,Oimm(taille)) ; Sw(T0,Areg(0,A0)) ; Move(A0,T0)])
    | PointerPPright -> let code_adr = lvalue_code e in
			let taille = get_size (pointed_type e.texp_type) in
			code_adr ++ (mips[Lw(T0,Areg(0,A0)) ; Arith(Add,T0,T0,Oimm(taille)) ; Sw(T0,Areg(0,A0)) ; Arith(Mips.Sub,A0,T0,Oimm(taille))])
    | PointerMMleft -> let code_adr = lvalue_code e in
		       let taille = get_size (pointed_type e.texp_type) in
		       code_adr ++ (mips[Lw(T0,Areg(0,A0)) ; Arith(Mips.Sub,T0,T0,Oimm(taille)) ; Sw(T0,Areg(0,A0)) ; Move(A0,T0)])
    | PointerMMright -> let code_adr = lvalue_code e in
			let taille = get_size (pointed_type e.texp_type) in
			code_adr ++ (mips[Lw(T0,Areg(0,A0)) ; Arith(Mips.Sub,T0,T0,Oimm(taille)) ; Sw(T0,Areg(0,A0)) ])
  end )
    
  |TBinop (op,e1,e2) -> begin let code_debut = (code_expr e1) 
				++ (mips[Sw(A0,Areg(-4,SP)) ; Arith(Sub,SP,SP,Oimm(4))]) 
				++ (code_expr e2) 
				++ (mips[Lw(T0,Areg(0,SP)) ; Arith(Add,SP,SP,Oimm(4)) ; Move(T1,A0)]) in
			      let code_operation = 
				match op with 
				| Eq -> mips[Set(Mips.Eq,A0,T0,Oreg(T1))]
				| Neq -> mips[Set(Mips.Ne,A0,T0,Oreg(T1))]
				| Lt -> mips[Set(Mips.Lt,A0,T0,Oreg(T1))]
				| Leq -> mips[Set(Mips.Le,A0,T0,Oreg(T1))]
				| Gt -> mips[Set(Mips.Gt,A0,T0,Oreg(T1))]
				| Geq -> mips[Set(Mips.Ge,A0,T0,Oreg(T1))]
				| BPlus -> mips[Arith(Mips.Add,A0,T0,Oreg(T1))]
				| BMinus -> mips[Arith(Mips.Sub,A0,T0,Oreg(T1))]
				| Mul -> mips[Arith(Mips.Mul,A0,T0,Oreg(T1))]
				| Div -> mips[Arith(Mips.Div,A0,T0,Oreg(T1))]
				| Mod -> mips[Arith(Mips.Rem,A0,T0,Oreg(T1))]
				| And -> mips[Mips.And(A0,T0,Oreg(T1))]
				| Or -> mips[Mips.Or(A0,T0,Oreg(T1))]
				| PointerBPlus -> let taille = get_size (pointed_type e1.texp_type) in
						  mips[Arith(Mips.Mul,T1,T1,Oimm(taille)) ; Arith(Mips.Add,A0,T0,Oreg(T1))]
				| PointerIntBMinus -> let taille = get_size (pointed_type e1.texp_type) in
						      mips[Arith(Mips.Mul,T1,T1,Oimm(taille)) ; Arith(Sub,A0,T0,Oreg(T1))]
				| PointerPointerBMinus -> (*je suis pas certain que ce soit cela que ça fait*)
				  let taille = get_size (pointed_type e1.texp_type) in
				  mips[Arith(Sub,A0,T0,Oreg(T1)) ; Arith(Mips.Div,A0,A0,Oimm(taille))]
			      in code_debut ++ code_operation
  end 
    
  |TSizeof (t) -> mips[Li (A0,get_size (t))]
    
    (*on passe en argument la fonction dont c'est le corps pour les returns*)
let rec code_instr f = function
  | TEmpty -> nop
  | TWhile(e,i) -> let label_1 = new_label "while" and label_2 = new_label "while" in 
		   (mips[J label_2 ; Label label_1]) ++ (code_instr f i.tinstr) 
		   ++ (mips[Label label_2]) ++ (code_expr e) ++ (mips[Bnez(A0,label_1)]) 
		   
  | TReturn None -> nop		   
  | TReturn (Some e) -> (*on suppose sortier dans A0. A completer et corriger*) 
		(code_expr e)  
		++ (mips [Sw(A0,Areg(f.f_result_pos,FP)) ; Arith(Sub,SP,SP,Oimm(4)) ; J ("f_end_" ^f.f_name)])
		
  | TIf(e,i1,None) -> let code_e = code_expr e in
		      let label_1 = new_label "if" in
		      let code_i1 = code_instr f i1.tinstr in
		      code_e ++ mips[Beqz(A0,label_1)] ++ code_i1 ++ mips[Label label_1]
			  
  | TIf(e,i1,Some i2) -> let code_e = code_expr e in
			 let label_1 = new_label "if" and label_2 = new_label "if" in
			 let code_i1 = code_instr f i1.tinstr and code_i2 = code_instr f i2.tinstr in
			 code_e ++ mips[Beqz(A0,label_1)] ++ code_i1 ++ mips[B(label_2)] 
			 ++ mips[Label label_1] ++ code_i2 ++ mips[Label (label_2)]
			 
  | TExpression e -> code_expr e
  
  | TBloc b -> (* faire gestion déclaration de variables ?*)
    List.fold_left (fun acc inst -> acc ++ (code_instr f (inst.tinstr))) nop (snd(b.tbloc))
      
let code_decl = function 
  | TDt _ -> nop (*pour une déclaration de type, il n'y a aucun code à produire*)
  | TDvar _ -> nop (*les déclarations de variables vont dans le champ data*)
  | TDf dec_f ->  let f = dec_f.tfun in(*appelera la fonction pour produire du code sur son bloc*)
		  let code = code_instr f (TBloc dec_f.tcontent) in (* on prend sp>=0*)			
		  (mips[Label ("fun_"^f.f_name)]) ++ (func_begin (f.f_lvar_size)) ++ code ++ (func_end f) 	
		    
let code_data2 = function 
  | TDt _ | TDf _ -> []
  | TDvar {tdecvar = TGvar v; tdecvar_pos = _} -> (match v.gv_type with
    | TInt | TChar | TPointer _ -> [Word("var_"^v.gv_name, [Wint 0])]
    | TStruct stru -> [Space("var_"^v.gv_name,get_size(v.gv_type))] (* à tester *)
    | TUnion uni -> [Space("var_"^v.gv_name,get_size(v.gv_type))]				  
    | TVoid | TTypenull -> assert false			
      
  )
  | _ -> assert false
    
let code_data () =  
  Hashtbl.fold (fun x y l -> Asciiz (y, x) :: l) Typeur.echaine [Asciiz ("newline", "\n")]
    
    
let code_main = mips[Label "main";Arith(Sub, FP,SP,Oimm(8));Arith(Sub, SP,SP,Oimm(8));Sw(A0,Areg(4,SP));Sw(A1,Areg(0,SP));Jal "fun_main";Li(V0,10);Syscall]
(* SP dernière case occupée *)
  

let code_prog p = 
  set_loc p ;
  {text = code_main ++ List.fold_left (fun acc_code decl -> (code_decl decl) ++ acc_code) nop p.tdecl ; 
   data = code_data() @ List.fold_left (fun acc_data decl -> (code_data2 decl) @ acc_data ) [] p.tdecl}
    
