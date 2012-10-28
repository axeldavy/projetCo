

type ident = string

type decl = 
	|Globvar of ttype * (ident list)
	|Dt of  decl_typ 
	|Df of ttype * indent * ((ttype * ident) list) * bloc
(*and decl_vars = { dvtype of ttype ; lvar of var list } je pense qu'on doit pouvoir traiter les déclarations de variable en même temps que le reste
il est possible que le parser ai à les traiter à part, mais après, on doit pouvoir considérer que c'est un simple expression, du moins pour les 
variables locales. un truc semble bizarre, pour les variables globales, on peut les déclarer en dehors d'une fonction, mais pas lui affecter de valeur,
du moins vu la façon dont c'est expliqué dans le poly, vu qu'on a pas le droit de mettre d'expression en dehors des déclarations de fonctions*)
(*pour les fonction, c'est pas trop utile de rajouter le type decl_fct qui n'a qu'un seul constructeur*)

and decl_typ = Dstruct of ident * decl_vars list | Dunion of ident * decl_vars list

(*and etoile = Etoile plus nécessaire du coup*)

(*
and decl_fct = Func of ttype * ((ttype * ident) list) * bloc (*les étoiles sont gérées directement par ttype, je suis pas tout à fait sûr ce ça, 
normalement quand on écrit int f(int *x) {...} cela signifie que x est du type int* c'est ça? *)
*)

and ttype = Void | Int | Char | Struct of ident | Union of ident (* ajout? *) | Pointer of ttype | Typenull

(*and argument = { argtype of ttype ; argvar of var} plus utile*)

(*and var = Direct_access of ident | Pointer_access of var plus utile non plus maintenant*)

and unop = PPleft | PPright | MMleft | MMright | Adr_get | Not | Minus | Plus  

and expr = 
  |Var_decl of ttype * (ident list)
  |Entier of string  (* int ou int32?*) (*dépend de à quel moment on décide de différencier les entiers écrits en 
  decimal, octal, hexa, peut être utile de les garder sous forme de chaine jusqu'à ce qu'on traduise en mips*)
  |Chaine of string
  |Var of ident (*à priori un ident peut être soit une variable, soit une fonction, le cas des fonctions étant traité après, on peut considérer
  que c'est toujours une variable*)
  |Pointer_access of expr 
  (*|Pointer_plus_something_access_expr of expr * expr (*supprimer à cause de la remarque début du II*) *)
  |Access_field of expr * ident (* ici on a bien ident = string *) 
 (* |Pointer_field of expr * ident idem *)
  |Assignement of expr * expr
  |Call of ident * (expr list) (* rq : un jour tester le nombre d'arguments *)
  |Unop of unop * expr 
  |BinOp of bop * expr * expr (*plus clair si on précise qu'il s'agit d'opérateurs binaires je pense*)
  |Get_size of ttype  (*idem, étoiles traitées par ttype*)
  (*|Parenthesis of expr (* inutile pour le typage, mais peut-être pas pour le parser*) je pense que c'est inutile ici, 
  c'est justement le parser qui va créer cet arbre, et une fois que l'arbre est fait, les parenthèses ne sont plus utiles*)
  |If of expr * bloc * bloc
  |While of expr * bloc
  |For of (*à traiter, je comprends pas trop ce qui est écrit dans le poly pour ça*)
  |Return of expr
  
and bop = Eq | Neq | Lt | Leq | | Gt | Geq | Plus | Minus | Mul | Div | Mod | And | Or

and bloc = expr list

