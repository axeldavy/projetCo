

type ident == string

type decl = Dv of decl_vars | Dt of  decl_typ | Df of decl_fct
and decl_vars = { dvtype of ttype ; lvar of var list }
and decl_typ = Dstruct of ident * decl_vars list | Dunion of ident * decl_vars list
and etoile = Etoile
and decl_fct = func of ttype * (etoile list) * argument list * bloc
and ttype = Void | Int | Char | Struct of ident | Union of ident (* ajout? *) | Pointer of ttype | Typenull
and argument = { argtype of ttype ; argvar of var}
and var = Direct_access of ident | Pointer_access of var
and unoptype = PPleft | PPright | MMleft | MMright | Adr_get | Not | Minus | Plus  
and expr = 
  |Entier of int  (* int ou int32?*)
  |Chaine of char list
  |Id of ident
  |Pointer_access_expr of expr
  |Pointer_plus_something_access_expr of expr * expr
  |Access_field of expr * ident (* ici on a bien ident = string *)
  |Pointer_field of expr * ident
  |Assignement of expr * expr
  |Call of ident * (expr list) (* rq : un jour tester le nombre d'arguments *)
  |Unop of unoptype * expr 
  |Op of expr * operateur * expr
  |Get_size of ttype * (etoile list) 
  |Parenthesis of expr (* inutile pour le typage, mais peut-être pas pour le parser*)
and operateur = EqualEqual | N 
