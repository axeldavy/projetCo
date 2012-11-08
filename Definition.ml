
type position = Lexing.position
 
type ident = string

type ttype = Void | Int | Char | Struct of ident | Union of ident (* ajout? *) | Pointer of ttype | Typenull
type unop = PPleft | PPright | MMleft | MMright | Adr_get | Not | UMinus | UPlus  

type  bop = Eq | Neq | Lt | Leq | Gt | Geq | BPlus | BMinus | Mul | Div | Mod | And | Or


let rec string_of_type = function 
	| Int -> "int" 
	| Char -> "char"
	| Void -> "void"
	| Typenull -> "typenull"
	| Struct s -> "struct : " ^s
	| Union s -> "union : " ^s
	| Pointer p -> "(" ^(string_of_type p)^")*"
	
let string_of_unop = function 
	| PPleft -> "increment left operand"
	| PPright -> "increment right operand"
	| MMleft -> "decrement left operand"
	| MMright -> "decrement right operand"
	| Adr_get -> "unary '&' operand"
	| Not -> "unary '!' operand"
	| UPlus -> "unary '+' operand"
	| UMinus -> "unary '-' operand"
	
let string_of_binop = function 
	| Eq -> "binary '=='"
	| Neq -> "binary '!='"
	| Lt -> "binary '<'"
	| Leq -> "binary '<='"
	| Gt -> "binary '>'"
	| Geq -> "binary '>='"
	| BPlus -> "binary '+'"
	| BMinus -> "binary '-'"
	| Mul -> "binary '*'"
	| Div -> "binary '/'"
	| Mod -> "binary '%'"
	| And -> "binary '&&'"
	| Or -> "binary '||'"

	
(*module contenant le type de l'arbre de syntaxe abstraite*)	
module Ast = struct
type decl = 
	|Dvar of decl_vars
	|Dt of  decl_typ 
	|Df of decl_fun
	
and decl_fun = {decfun : ttype * ident * ((ttype * ident) list) * bloc ; decfun_pos : position }

and decl_typ = {dectype : dec_t ; dectype_pos : position}

and dec_t = Dstruct of ident * decl_vars list | Dunion of ident * decl_vars list

and decl_vars = {decvar : ttype * (ident list) ; decvar_pos : position }

and expr = 
  |Character of char
  |Entier of int
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
 
and bloc = {bloc : (decl_vars list) * (instruction list) ; bloc_pos : position}

end


(*module contenant le type de l'arbre décoré*)
module Ast_Type = struct 

type gvar = {gv_name : ident ; gv_type : mtype}	
and lvar = {lv_name : ident ; mutable lv_loc : int ; lv_type : mtype}
(*loc : localisation de la variable locale sur la pile, sera utilisé plus tard*)
and var = TGvar of gvar | TLvar of lvar
and func = {f_name : ident ; f_type : mtype ; f_arg : (ident * mtype) list}	
and stru = {s_name : ident ; s_content : (ident * mtype) list ; s_size : int}
and uni = {u_name : ident ; u_content : (ident * mtype) list ; u_size : int}
and mtype = TVoid | TInt | TChar | TStruct of stru | TUnion of uni | TPointer of mtype | TTypenull

type decl = 
	|TDvar of decl_vars
	|TDt of  decl_typ 
	|TDf of decl_fun
	
and decl_fun = {tfun : func ; tcontent : bloc ; tdecfun_pos : position }
and decl_typ = {tdectype : dec_t ; tdectype_pos : position}
and dec_t = TDstruct of stru | TDunion of uni
and decl_vars = {decvar : var list ; decvar_pos : position }

and expr = 
  |TCharacter of char
  |TEntier of int
  |TChaine of string
  |TVariable of var
  |TPointer_access of expression 
  |TAccess_field of expression * ident 
  |TAssignement of expression * expression
  |TCall of func * (expression list) 
  |TUnop of unop * expression 
  |TBinop of bop * expression * expression 
  |TSizeof of mtype 
 
 and expression = {texp : expr ; texp_pos : position; texp_type : mtype}
  
and instr =
  |TEmpty
  |TExpression of  expression
  |TIf of expression * instruction * (instruction option)
  |TWhile of expression * instruction
  |TReturn of (expression option)
  |TBloc of bloc
  
and instruction = {tinstr : instr ; tinstr_pos : position }
 
and bloc = {tbloc : (decl_vars list) * (instruction list) ; tbloc_pos : position}


exception Type_error of position * string
exception Argtype_error of position * string * (mtype list)
(*== erreur à la position pos, la fonction (l'opérateur string) a eu les types de la liste en argument *)	
	
end 