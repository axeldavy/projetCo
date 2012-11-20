 
%{
  open Definition
  open Ast
  open Lexing
  
  let rec get_type_star (t,ls) =
   if ls = [] then t
   else pointer of get_type_star (t, tl (ls))

%}

%token <Int32.t> Const
%token <string> Name
%token <string> Chaine
%token DOT I_DOT IF THEN ELSE FUNCTION STRUCT UNION Teof
%token PARENTHESIS_OPEN PARENTHESIS_CLOSE INDEX_OPEN INDEX_CLOSE 
%token MAY_BE_ADRESS_OR_BIN_AND COMMA
%token INT VOID NULL ARROW RETURN COLON SEMICOLON WHILE FOR
%token PLUS MINUS STAR DIV REM AND OR PLUS_PLUS MINUS_MINUS BIN_NOT 
%token OVER OVER_OR_EQUAL EQUAL_EQUAL EQUAL UNDER UNDER_OR_EQUAL NOT_EQUAL


%right EQUAL
%left OR 
%left AND
%left EQUAL_EQUAL NOT_EQUAL
%left UNDER UNDER_OR_EQUAL OVER OVER_OR_EQUAL
%left MINUS PLUS
%left STAR DIV REM
%right BIN_NOT PLUS_PLUS MINUS_MINUS get_adress bin_and get_pointer uplus uminus
%left parenthesis index ARROW DOT

/* Point d'entrée de la grammaire */
%start prog

%type <Ast.program> prog



%%

(*
prog:
 decl = decl*
 main = block
 Teof
{ {decl = decl; main = main } }

expression:
  | c = Const {Entier c}
  | id = Name {Variable id} 

block:
  VOID 
  {{bloc = ([],[]) ;
    bloc_pos =$startpos}}


decl:
  id = Name  
  EQUAL 
  res = expression 
  SEMICOLON 
(* faux bien sur *)
  { Dvar {decvar = ( (Int),[id]); decvar_pos = $startpos} }

*)

ident:
  c = Name { c }   

decl_var_interne(t) :
  ls = loption(STAR)  (* problème : * x va être reconnu comme *x. Est-ce correct en C? -> Il semble que oui*)
  id = ident
  { Dvar {decvar = ( get_type_star (t,ls),id); decvar_pos = $startpos}  }
  
decl_var:
  t = vtype 
  lvar = loption( ((decl_var_interne(t) COMMA)*) ) @ [decl_var_interne(t)]  (* à vérifier *)
  SEMICOLON
  { Dvar {decvar = ( t,lvar); decvar_pos = $startpos} } 

instruction:
  |SEMICOLON {Empty} (* il faudra les enlver à un moment *)
  |e = expression SEMICOLON {Expression e}
  |IF 

block : 
  lvar = List.concat (loption (decl_var))
  linstr = loption(instruction)
  { { bloc = (lvar,linstr) ; bloc_pos = $startpos}   }
%%

