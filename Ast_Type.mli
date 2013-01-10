open Definition


type gvar = {gv_name : ident ; gv_type : mtype}	
and lvar = {lv_name : ident ; mutable lv_loc : int ; lv_type : mtype}
(*loc : localisation de la variable locale sur la pile, sera utilisé plus tard*)
and var = TGvar of gvar | TLvar of lvar
and func = {f_name : ident ; f_type : mtype ; f_arg : lvar list ;
	mutable f_lvar_size : int (*taille du tableau d'activation*) ;
        mutable f_result_pos : int (*position du résultat*)}	
and stru = {s_name : ident ; 
   mutable s_content : lvar list ;
   mutable s_size : int}
and uni = {u_name : ident ; 
   mutable u_content :lvar list ;
   mutable u_size : int}
and mtype = TVoid | TInt | TChar | TStruct of stru 
           | TUnion of uni | TPointer of mtype | TTypenull

type decl = 
	|TDvar of decl_vars
	|TDt of  decl_typ 
	|TDf of decl_fun
	
and file = decl list
	
and decl_fun = {tfun : func ; tcontent : bloc ; tdecfun_pos : position }
and decl_typ = {tdectype : dec_t ; tdectype_pos : position}
and dec_t = TDstruct of stru | TDunion of uni
and decl_vars = {tdecvar : var ; tdecvar_pos : position }

and expr = 
  |TCharacter of char
  |TEntier of Int32.t
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
 
and bloc = {tbloc : (decl_vars list) * (instruction list) ; 
    tbloc_pos : position}

and program = {tdecl : decl list }



(*type des éléments de l'environnement, il doit contenir les variables, 
les fonctions, et les structures et unions de types*)	

type mapelt = 
	| MVar of var	
	| MFun of func
	| MStr of stru
	| MUni of uni	
