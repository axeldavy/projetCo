open Mips
open Ast_Type
open Definition

	(*fonction qui renvoie true si un type de données doit être aligné*)
let rec aligne = function 
	| TInt | TPointer _ -> true
	| TChar -> false
	| TTypenull -> true (*à voir, normalement on doit pas pouvoir définir de variables de types typenull, 
	donc le résultat renvoyé a peu d'intéret*)
	| TVoid -> true (*idem*)
	| TStruct s -> List.fold_left (fun b var -> b||(aligne var.lv_type)) false s.s_content
	| TUnion u -> List.fold_left (fun b var -> b||(aligne var.lv_type)) false u.u_content


	(*fonction qui renvoie la taille d'un type, en le calculant si nécessaire, et met à la bonne valeur 
	les positions des différents champs pour les structures*)
let rec get_size = function
	| TInt | TPointer _ | TTypenull -> 4
	| TChar _ | TVoid-> 1
	| TStruct s -> if (s.s_size <> 0) then s.s_size  
		else let l = Sort.list (fun var1 var2 -> aligne var1.lv_type > aligne var2.lv_type) s.s_content in 
		begin
		(*on met à la fin de la structure les variables qui ne doivent pas necessairement etre alignees*)
		s.s_content <- l ;
		s.s_size <- List.fold_left (fun acc var -> 
		if (aligne var.lv_type)
			then
				( var.lv_loc <- acc +((4 - (acc mod 4)) mod 4) ; (*un peu moche, renvoie la position alignée juste au dessus de acc.
				le problème vient du fait que mod peut renvoyer des valeurs négatives si ses arguments sont négatifs*)
				acc + ((4 - (acc mod 4)) mod 4) + get_size var.lv_type )
			else 
				(var.lv_loc <- acc;
				acc + get_size var.lv_type )
			) 0 s.s_content ;
		if aligne (TStruct s) then s.s_size <- s.s_size + ((4 -(s.s_size mod 4)) mod 4) ;
		(*si une structure doit être alignée, sa taille doit être un multiple de 4*)
		s.s_size ;
		end ;
		
		
	| TUnion u -> if (u.u_size <> 0) then u.u_size  
		else (u.u_size <- List.fold_left (fun acc var -> var.lv_loc <- 0 ; max acc (get_size var.lv_type)) 0 u.u_content ; u.u_size) 
		
		
		
	(*fonction qui vérifie que la taille d'un type a bien déjà été calculée auparavant. 
	Normalement, les fonctions suivantes calculeront la taille d'un type quand on a une déclaration 
	de type, si après on a une occurence de ce type sans la bonne taille, c'est qu'il y a un 
	problème (de partage de données surement)*)		
let size_up_to_date = function 
	| TInt | TVoid | TTypenull | TChar | TPointer _ -> true
	| TStruct s -> s.s_size <> 0;
	| TUnion u -> u.u_size <> 0 

	(*renvoie le nombre d'octets nécessaires pour stocker une variable du type t*)
let size_octet t = (get_size t +3)/4

	

	(*calcule les tailles des types dans les déclarations de type, prend en entrée un programme, 
	et modifie les champs size des structures*)
let set_size p = 
	let aux = function 
		| TDvar _ | TDf _-> ()
		| TDt dt -> match dt.tdectype with 
			| TDstruct s -> ignore (get_size (TStruct s))
			| TDunion u -> ignore (get_size (TUnion u))
	in
	List.iter aux p.tdecl 
	
	
	(*fonction pour mettre à la bonne valeur les positions des variables locales*)
	(*pos : dernière case occupée sur la pile par rapport à $fp. commence en -4 dans les déclarations de fonctions*)
	(*renvoie la dernière case occupée par une variable de l'instruction. Sert à calculer la taille du tableau d'activation*)
let rec set_loc_instr pos = function 
	| TEmpty | TExpression _ | TReturn _ -> pos ;
	| TIf(_,i1,i2_opt) -> begin let pos1 = set_loc_instr pos i1.tinstr in 
		let pos2 = match i2_opt with 
			| None -> 0
			| Some i2 -> set_loc_instr pos i2.tinstr
		in 
		max pos1 pos2
		end ;
	| TWhile(_,i1) -> set_loc_instr pos i1.tinstr
	| TBloc b -> 
		let aux acc decvar =  
			let var = match decvar.tdecvar with 
				| TLvar v -> v
				| TGvar _ -> assert false 
			in
			let size_o = size_octet var.lv_type in 
			let new_pos = assert (size_up_to_date var.lv_type) ;
				pos - 4* size_o 
			in 
			var.lv_loc <- new_pos ;
			new_pos 
		in 
		List.fold_left aux pos (fst b.tbloc) 
	
	
	
	
		
let set_loc p = 
	let aux = function 
		| TDvar _ | TDt _ -> ()(*pour les déclarations de type, le placement des variables a déjà été fait avec la fonction get_size*)
		| TDf df -> let posf = set_loc_instr (-4) (TBloc df.tcontent) in 
				df.tfun.f_lvar_size <- 4 + (abs posf) ;
			(*on suppose que tous les arguments de la fonction sont alignés sur la pile !!! (plus simple)*)
				let res_pos = List.fold_left (fun pos_libre var -> var.lv_loc <- pos_libre ; 
					assert (size_up_to_date var.lv_type) ;
					let size_o = size_octet var.lv_type in 
					pos_libre + 4*size_o 
					) 4 df.tfun.f_arg
			(*la première position libre pour un argument est en +4 (par rapport à $fp)*)
				in df.tfun.f_result_pos <- res_pos 
	in 
	List.iter aux p.tdecl
	

let move adr_depart adr_arrivee size = failwith "TODO"
	(*fonction pour déplacer des blocs de données,
	doit pouvoir marcher même sur des données non alignées*)
	

let code_expr sp = function 
  |TCharacter c -> failwith "TODO"
  |TEntier i -> failwith "TODO"
  |TChaine s -> failwith "TODO"
  |TVariable var -> failwith "TODO"
  |TPointer_access e -> failwith "TODO" 
  |TAccess_field (e,x) -> failwith "TODO"
  |TAssignement (e1,e2) -> failwith "TODO"
  |TCall (f,l) when f.f_name = "putchar"-> failwith "TODOfirst" 
  |TCall (f,l) when f.f_name = "sbrk"-> failwith "TODO" 
  |TCall (f,l) -> failwith "TODO" 
  |TUnop (op,e) -> failwith "TODO"
  |TBinop (op,e1,e2) -> failwith "TODO"
  |TSizeof (t) -> failwith "TODO"
	
	
let code_instr sp = function 
	| TEmpty -> failwith "TODO"
	| TWhile(e,i) -> failwith "TODO"
	| TReturn e -> failwith "TODO"
	| TIf(e,i1,None) -> failwith "TODO"
	| TIf(e,i1,Some i2) -> failwith "TODO"
	| TExpression e -> failwith "TODO"
	| TBloc b -> failwith "TODO"
	
let code_decl = function 
	| TDt _ -> nop (*pour une déclaration de type, il n'y a aucun code à produire*)
	| TDvar _ -> nop (*les déclarations de variables vont dans le champ data*)
	| TDf f -> failwith "TODO" (*appelera la fonction pour produire du code sur son bloc*)
	
let code_data = function 
	| TDt _ | TDf _ -> []
	| TDvar v -> failwith "TODO"
	
let code_prog p = 
(*manque certainement un bout du genre jump main et gestion des arguments du programme*)
	{text = List.fold_left (fun acc_code decl -> (code_decl decl) ++ acc_code) nop p.tdecl ; 
	data = List.fold_left (fun acc_data decl -> (code_data decl) @ acc_data ) [] p.tdecl}
