type position = int*int
and etiquette = ttype
and ident = string

and decl = 
	|Dvar of decl_vars
	|Dt of  decl_typ 
	|Df of ttype * ident * ((ttype * ident) list) * bloc

and decl_typ = Dstruct of ident * decl_vars list | Dunion of ident * decl_vars list

and decl_vars = ttype * (ident list)

and ttype = Void | Int | Char | Struct of ident | Union of ident (* ajout? *) | Pointer of ttype | Typenull

and unop = PPleft | PPright | MMleft | MMright | Adr_get | Not | UMinus | UPlus  

and bop = Eq | Neq | Lt | Leq | Gt | Geq | BPlus | BMinus | Mul | Div | Mod | And | Or

and expr = 
  |Entier of int
  |Chaine of string
  |Variable of ident 
  |Pointer_access of node 
  |Access_field of node * ident 
  |Assignement of node * node
  |Call of ident * (node list) 
  |Unop of unop * node 
  |Binop of bop * node * node 
  |Sizeof of ttype 
  
and node = {exp : expr ; pos : position; mutable data : etiquette} 
(*type noeud de l'arbre, pos correspond à la position dans le fichier*)
  
and instruction =
  |Empty
  |Expr of expr 
  |If of expr * instruction * (instruction option)
  |While of expr * instruction
  |For of (expr list * (expr option) * instruction)
  |Return of (expr option)
  |Bloc of bloc
  

and bloc = (decl_vars list) * (expr list)

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


