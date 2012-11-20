open Definition
 
(*module contenant le type de l'arbre de syntaxe abstraite*)	


	
type decl_fun = 
  {decfun : ttype * ident * ((ttype * ident) list) * bloc ;
   decfun_pos : position }

and decl_typ = {dectype : dec_t ; dectype_pos : position}

and decl_vars = {decvar : ttype * ident ;
		  decvar_pos : position }

and dec_t = Dstruct of ident * decl_vars list 
	     | Dunion of ident * decl_vars list



and decl = 
	|Dvar of decl_vars
	|Dt of  decl_typ 
	|Df of decl_fun

and expr = 
  |Character of char (*est ce qu'il faut pas les laisser quand m�me 
parce qu'ils sont cod�s sur seulement 1 octet en m�moire, et pas 4 comme 
les entiers, sinon au niveau du typage, �a pose pas de probl�me*)
  |Entier of (Int32.t)
  |Chaine of string
  |Variable of ident 
  |Pointer_access of expression 
 (* |Access_index of expression * expression c'est pour les expressions t[i] 
 c'est �a? dans le poly, ils disent qu'on peut remplacer cette expression par *(t+i) *)
  |Access_field of expression * ident 
  |Assignement of expression * expression
  |Call of ident * (expression list) 
  |Unop of unop * expression 
  |Binop of bop * expression * expression 
  |Sizeof of ttype 
 
and expression = {exp : expr ; exp_pos : position}
  
and instr =
  |Empty
  |Expression of  expression
  |If of expression * instruction * (instruction option)
  |While of expression * instruction
  |For of (expression list) * (expression option) * (expression list) * instruction
 (*�a d�range si je laisse le option l� au lieu du list? parce que du coup on peut 
pas avoir plus d'une expression dans ce champ l� *)
  |Return of (expression option)
  |Bloc of bloc
  
and instruction = {instr : instr ; instr_pos : position}
 
and bloc = {bloc : (decl_vars list) * (instruction list) ;
	    bloc_pos : position}

and cfunction = {name : string ;  body : bloc ; args : decl_vars list } 
(* � adapter *)

and program = {decl : decl list ; main: bloc }