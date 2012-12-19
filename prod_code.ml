open Mips
open Ast_Type
open Definition
open Aide_prod
open List
open Typeur
	

let move adr_depart adr_arrivee size = failwith "TODO"
	(*fonction pour déplacer des blocs de données,
	doit pouvoir marcher même sur des données non alignées*)
	

let rec code_expr = function 
  |TCharacter c -> mips[Li (A0,int_of_char c)]
  |TEntier i -> mips[Li32 (A0,i)]
  |TChaine s -> begin try
			mips[La(A0,Hashtbl.find echaine s)] 
		with Not_found -> assert false end
  |TVariable var -> failwith "TODO"
  |TPointer_access e -> failwith "TODO" 
  |TAccess_field (e,x) -> failwith "TODO"
  |TAssignement (e1,e2) -> failwith "TODO"
  |TCall (f,[e]) when f.f_name = "putchar"-> let c = code_expr e.texp in c++ (mips [Li (V0, 11) ; Syscall ]) (* on suppose dans A0 *) 
  |TCall (f,l) when f.f_name = "sbrk"-> failwith "TODO" 
  |TCall (f,l) -> failwith "TODO" 
  |TUnop (op,e) -> failwith "TODO"
  |TBinop (op,e1,e2) -> failwith "TODO"
  |TSizeof (t) -> failwith "TODO"
	
	
let rec code_instr = function 
	| TEmpty -> nop
	| TWhile(e,i) -> failwith "TODO"
	| TReturn e -> failwith "TODO"
	| TIf(e,i1,None) -> failwith "TODO"
	| TIf(e,i1,Some i2) -> failwith "TODO"
	| TExpression e -> code_expr e.texp
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
	| TDvar v -> failwith "TODO"

let code_data () =  
	 Hashtbl.fold (fun x y l -> Asciiz (y, x) :: l) echaine [Asciiz ("newline", "\n")]

	
let code_main = mips[Label "main";Jal "fun_main";Li(V0,10);Syscall]

let code_prog p = 
	set_loc p ;
(*manque certainement un bout du genre jump main et gestion des arguments du programme*)
	{text = code_main ++ List.fold_left (fun acc_code decl -> (code_decl decl) ++ acc_code) nop p.tdecl ; 
	data = code_data() @ List.fold_left (fun acc_data decl -> (code_data2 decl) @ acc_data ) [] p.tdecl}
