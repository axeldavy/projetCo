 
%{
  open Definition
  open Ast
  open Lexing

%}

%token <Int32.t> Const
%token <string> Name
%token <string> Chaine
%token DOT I_DOT IF THEN ELSE FUNCTION STRUCT UNION Teof
%token PARENTHESIS_OPEN PARENTHESIS_CLOSE INDEX_OPEN INDEX_CLOSE
%token INT VOID NULL ARROW RETURN COLON SEMICOLON WHILE FOR
%token PLUS MINUS STAR DIV
%token OVER OVER_OR_EQUAL EQUAL_EQUAL EQUAL UNDER UNDER_OR_EQUAL NOT_EQUAL



%left MINUS PLUS
%left STAR DIV
%nonassoc uminus
%nonassoc THEN
%nonassoc ELSE
%nonassoc ARROW

/* Point d'entrée de la grammaire */
%start prog

%type <Ast.program> prog



%%

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






%%
