type position = int*int(*TODO: comment on récupère la poisition des différents éléments du fichier, 
cf menhir?*)

type ident = string

type decl = 
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
  
and node = {exp : expr ; pos : position} 
(*type noeud de l'arbre, pos correspond à la position dans le fichier*)
  
and instruction =
  |Expr of expr 
  |If of expr * bloc * bloc
  |While of expr * bloc
  |For of (expr list * (expr option) * expr list)
  |Return of (expr option)
  

and bloc = (decl_vars list) * (expr list)

