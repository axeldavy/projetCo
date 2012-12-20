open Mips
open Ast_Type
open Definition
open Aide_prod
open List
open Typeur
	

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
and
code_expr e = 
match e.texp with
  |TCharacter c -> mips[Li (A0,int_of_char c)]
  |TEntier i -> mips[Li32 (A0,i)]
  |TChaine s -> begin try
			mips[La(A0,Hashtbl.find echaine s)] 
		with Not_found -> assert false end
  |TVariable (TGvar gvar) -> (match(gvar.gv_type) with
				 | TInt | TChar | TPointer _ -> mips[Lw(A0,Alab("var_"^gvar.gv_name))]
				 | TStruct stru -> failwith "TODO"
				 | TUnion uni -> failwith "TODO"				  
				 | TVoid | TTypenull -> assert false



				)
  |TVariable (TLvar lvar) -> (match(lvar.lv_type) with
				 | TInt | TChar | TPointer _ -> mips[Lw(A0,Areg(lvar.lv_loc,FP))]
				 | TStruct stru -> failwith "TODO"
				 | TUnion uni -> failwith "TODO"				  
				 | TVoid | TTypenull -> assert false



				)
  |TPointer_access e -> let code = code_expr e in (* on suppose sortier dans A0. A completer et corriger*)
				code ++ (mips[Lw(A0,Areg(0,A0))])
  |TAccess_field (e,x) -> begin let code_adr = lvalue_code e in
				match e.texp_type with (* on suppose sortier dans A0. A completer et corriger*)
					| TUnion uni -> let str_var = List.find (fun var -> var.lv_name = x) uni.u_content in
						code_adr ++ (mips[Lw(A0,Areg(str_var.lv_loc,A0))])
					| TStruct stru -> let str_var = List.find (fun var -> var.lv_name = x) stru.s_content in
						code_adr ++ (mips[Lw(A0,Areg(str_var.lv_loc,A0))])
					| _ -> assert false
				end 
  |TAssignement (e1,e2) -> let code_adr = lvalue_code e1 in 
			   let code_e = code_expr e2 in (* on suppose sortier dans A0. A completer et corriger*)
			code_adr ++ (mips [Arith(Sub,SP,SP,Oimm(4));Sw(A0,Areg(0,SP)); ]) ++ code_e
				++ (mips[ Lw (A1,Areg(0,SP)); Sw (A0,Areg(0,A1)); Arith(Add,SP,SP,Oimm(4))])
  |TCall (f,[e]) when f.f_name = "putchar"-> let c = code_expr e in c++ (mips [Li (V0, 11) ; Syscall ]) (* on suppose dans A0 *) 
  |TCall (f,[e]) when f.f_name = "sbrk"-> let c = code_expr e in c ++ (mips [Li (V0, 9); Syscall; Move(A0,V0)]) (* on suppose dans A0; à tester *) 
  |TCall (f,l) -> failwith "TODO"
  |TUnop (op,e) ->   let code_interne = code_expr e in 
			(match op with
			| PPleft -> failwith "TODO"
			| PPright -> failwith "TODO"
			| MMleft -> failwith "TODO"
			| MMright -> failwith "TODO"
			| Adr_get -> lvalue_code e
			| Definition.Not    -> code_interne ++ (mips[Mips.Not(A0,A0)])
			| UMinus -> code_interne ++ (mips[Neg(A0,A0)])
			| UPlus  -> code_interne 

			) 
  |TBinop (op,e1,e2) -> failwith "TODO"
  |TSizeof (t) -> mips[Li (A0,get_size (t))]
	
	
let rec code_instr = function
	| TEmpty -> nop
	| TWhile(e,i) -> failwith "TODO"
	| TReturn e -> failwith "TODO"
	| TIf(e,i1,None) -> failwith "TODO"
	| TIf(e,i1,Some i2) -> failwith "TODO"
	| TExpression e -> code_expr e
	| TBloc b -> (* faire gestion déclaration de variables ?*)
			List.fold_left (fun acc inst -> acc ++ (code_instr (inst.tinstr))) nop (snd(b.tbloc))
	
let code_decl = function 
	| TDt _ -> nop (*pour une déclaration de type, il n'y a aucun code à produire*)
	| TDvar _ -> nop (*les déclarations de variables vont dans le champ data*)
	| TDf dec_f ->  let f = dec_f.tfun in(*appelera la fonction pour produire du code sur son bloc*)
			let code = code_instr (TBloc dec_f.tcontent) in (* on prend sp>=0*)			
			(mips[Label ("fun_"^f.f_name)]) ++ (func_begin (f.f_lvar_size)) ++ code ++ (func_end ()) 	

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
	 Hashtbl.fold (fun x y l -> Asciiz (y, x) :: l) echaine [Asciiz ("newline", "\n")]

	
let code_main = mips[Label "main";Arith(Sub, FP,SP,Oimm(8));Arith(Sub, SP,SP,Oimm(8));Sw(A0,Areg(4,SP));Sw(A1,Areg(0,SP));Jal "fun_main";Li(V0,10);Syscall]
(* SP dernière case occupée *)


let code_prog p = 
	set_loc p ;
(*manque certainement un bout du genre jump main et gestion des arguments du programme*)
	{text = code_main ++ List.fold_left (fun acc_code decl -> (code_decl decl) ++ acc_code) nop p.tdecl ; 
	data = code_data() @ List.fold_left (fun acc_data decl -> (code_data2 decl) @ acc_data ) [] p.tdecl}
