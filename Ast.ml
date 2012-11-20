type position = Lexing.position*Lexing.position
 
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
	
	
	
type decl = 
	|Dvar of decl_vars
	|Dt of  decl_typ 
	|Df of decl_fun
	
and	file = decl list
	
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
  |For of ((expression list) * (expression option)* (expression list) * instruction)
  |Return of (expression option)
  |Bloc of bloc
  
and instruction = {instr : instr ; instr_pos : position}
 
and bloc = {bloc : (decl_vars list) * (instruction list) ; bloc_pos : position}