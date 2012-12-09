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
	| TStruct s -> List.fold_left (fun b var -> b&&(aligne var.lv_type)) true s.s_content
	| TUnion u -> List.fold_left (fun b var -> b&&(aligne var.lv_type)) true u.u_content


(*fonction qui renvoie la taille d'un type, en le calculant si nécessaire, et met à la bonne valeur 
les positions des différents champs pour les structures*)
let rec get_size = function
	| TInt | TPointer _ | TTypenull -> 4
	| TChar _ | TVoid-> 1
	| TStruct s -> if (s.s_size <> 0) then s.s_size  
		else let l = Sort.sort (fun var1 var2 -> aligne var1.lv_type < aligne var2.lv_type) s.s_content in 
		begin
		(*on met au début de la structure les variables qui ne doivent pas necessairement etre alignees*)
		s.s_content = l ;
		s.s_size <- List.fold_left (fun acc var -> var.lv_pos <- acc ;
		if (aligne var.lv_type)&&(acc mod 4 <> 0) 
			then acc +4 - (acc mod 4) + get_size var.lv_type
			else acc + get_size var.lv_type
			) 0 s.s_content ; 
		
		
		(s.s_size <- List.fold_left (fun acc var -> acc + (get_size var.lv_type)) 0 s.s_content ; s.s_size)
	| TUnion u -> if (u.u_size <> 0) then u.u_size  
		else (u.u_size <- List.fold_left (fun acc var -> max acc (get_size var.lv_type)) 0 u.u_content ; u.u_size)
		
		
(*fonction qui vérifie que la taille d'un type a bien déjà été calculée auparavant. 
Normalement, les fonctions suivantes calculeront la taille d'un type quand on a une déclaration 
de type, si après on a une occurence de ce type sans la bonne taille, c'est qu'il y a un 
problème (de partage de données surement)*)		
let size_up_to_date = function 
	| TInt | TPointer | TTypenull | TChar | TPointer _ -> true
	| Tstruct s -> s.s_size <> 0;
	| TUnion u -> u.u_size <> 0 
	

(*calcule les tailles des types dans les déclarations de type, prend en entrée un programme, 
et modifie les champs size des structures*)
let set_size p = 
	let aux = function 
		| TDvar | TDf-> ()
		| TDt dt -> match dt with 
			| TDstru s -> ignore (get_size (TStruct s))
			| TDunion u -> ignore (get_size (TUnion u))
	in
	List.iter aux p.tdecl ;
	
	
(*fonction pour mettre à la bonne valeur les positions des variables locales*)
let set_loc_instr pos = function 
	| TEmpty | TExpr _ | TReturn _ -> ()
	| TIf(_,i1,i2_opt) -> begin set_loc_instr pos i1 ;
		match i2_opt with 
			| None -> ()
			| Some i2 -> set_loc_instr pos i2
		end ;
	| TWhile(_,i1) -> set_loc_instr pos i1
	| TBloc b -> List.fold_left (fun acc decvar -> 
		let var = match get_size decvar.tdecvar with 
			| TLvar v -> v
			| TGvar _ -> assert false 
		in
		var.lv_pos = (**a finir**)
	
	) pos (fst b.tbloc)
	
	
	
	
		
let set_loc p = 
	let aux = function 
		| TDvar dv -> ()
		| TDf df -> set_loc_inst (-4) df.bloc
		| TDt dt -> () (*pour les déclarations de type, le placement des variables a déjà été fait avec la fonction get_size*)
	in 
	List.iter aux p.tdecl