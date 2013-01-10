
type position = Lexing.position*Lexing.position
 
type ident = string

type ttype = Void | Int | Char | Struct of ident 
	     | Union of ident | Pointer of ttype | Typenull
type unop = PPleft | PPright | MMleft | MMright | Adr_get | Not 
	    | UMinus | UPlus | PointerPPleft | PointerPPright 
            | PointerMMleft | PointerMMright

type  bop = Eq | Neq | Lt | Leq | Gt | Geq | BPlus | BMinus 
	    | Mul | Div | Mod | And | Or | PointerBPlus 
            | PointerIntBMinus | PointerPointerBMinus
(*les deux derniers sont pour la soustraction entre 2 pointeurs, 
et entre un pointeur et un entier*)
(*Dans le cas de PointerBPlus et de PointerIntBMinus, 
les expressions qui correspondent au type pointeur 
sont le premier élément du coupe (effectué par le typeur)*)


let rec string_of_type = function 
	| Int -> "int" 
	| Char -> "char"
	| Void -> "void"
	| Typenull -> "typenull"
	| Struct s -> "struct : " ^s
	| Union s -> "union : " ^s
	| Pointer p -> "(" ^(string_of_type p)^")*"
	
let string_of_unop = function 
	| PPleft | PointerPPleft -> "increment left operand"
	| PPright | PointerPPright -> "increment right operand"
	| MMleft | PointerMMleft -> "decrement left operand"
	| MMright | PointerMMright-> "decrement right operand"
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
	| BPlus | PointerBPlus -> "binary '+'"
	| BMinus | PointerIntBMinus | PointerPointerBMinus -> "binary '-'"
	| Mul -> "binary '*'"
	| Div -> "binary '/'"
	| Mod -> "binary '%'"
	| And -> "binary '&&'"
	| Or -> "binary '||'"

	
