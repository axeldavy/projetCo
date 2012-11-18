open Definition
 
(*module contenant le type de l'arbre de syntaxe abstraite*)	


	
type decl_fun = 
  {decfun : ttype * ident * ((ttype * ident) list) * bloc ;
   decfun_pos : position }

and decl_typ = {dectype : dec_t ; dectype_pos : position}

and decl_vars = {decvar : ttype * (ident list) ;
		  decvar_pos : position }

and dec_t = Dstruct of ident * decl_vars list 
	     | Dunion of ident * decl_vars list



and decl = 
	|Dvar of decl_vars
	|Dt of  decl_typ 
	|Df of decl_fun

and expr = 
  |Character of char
  |Entier of Int32.t
  |Chaine of string
  |Variable of ident 
  |Pointer_access of expression 
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
  |For of (expression list * (expression option) * instruction)
  |Return of (expression option)
  |Bloc of bloc
  
and instruction = {instr : instr ; instr_pos : position}
 
and bloc = {bloc : (decl_vars list) * (instruction list) ;
	    bloc_pos : position}

and cfunction = {name : string ;  body : bloc ; args : decl_vars list } 
(* à adapter *)

and program = {decl : decl list ; main: bloc }
