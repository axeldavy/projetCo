open Ast


type gvar = {gv_name : ident ; gv_type : mtype}	
and lvar = {lv_name : ident ; mutable lv_loc : int ; lv_type : mtype}
(*loc : localisation de la variable locale sur la pile, sera utilis� plus tard*)
and var = TGvar of gvar | TLvar of lvar
and func = {f_name : ident ; f_type : mtype ; f_arg : (mtype * ident) list}	
and stru = {s_name : ident ; s_content : (ident * mtype) list ; s_size : int}
and uni = {u_name : ident ; u_content : (ident * mtype) list ; u_size : int}
and mtype = TVoid | TInt | TChar | TStruct of stru | TUnion of uni | TPointer of mtype | TTypenull

type decl = 
	|TDvar of decl_vars
	|TDt of  decl_typ 
	|TDf of decl_fun
	
and file = decl list
	
and decl_fun = {tfun : func ; tcontent : bloc ; tdecfun_pos : position }
and decl_typ = {tdectype : dec_t ; tdectype_pos : position}
and dec_t = TDstruct of stru | TDunion of uni
and decl_vars = {tdecvar : var list ; tdecvar_pos : position }

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
(*== erreur � la position pos, la fonction (l'op�rateur string) a eu les types de la liste en argument *)	
exception Returntype_error of position * mtype * mtype 
(*erreur � la position pos, got type1, expected type2*)

(* on conserve dans l'environnement le type de toutes les variables et les fonctions, ainsi que
les structures et unions
Le champ arg permet de savoir si l'indent donn� correspond � une variable, ou une fonction
et donne les types des arguments de la fonction*)
module SMap = Map.Make(String) 

(*type des �l�ments de l'environnement, il doit contenir les variables, les fonctions, 
et les structures et unions de types*)	

type mapelt = 
	| MVar of var	
	| MFun of func
	| MStr of stru
	| MUni of uni	