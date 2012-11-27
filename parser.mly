 
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
%token OPEN_BLOCK CLOSE_BLOCK 
%token GET_ADRESS COMMA
%token CHAR INT VOID NULL ARROW RETURN COLON SEMICOLON WHILE FOR SIZEOF
%token PLUS MINUS STAR DIV REM AND OR PLUS_PLUS MINUS_MINUS BIN_NOT 
%token OVER OVER_OR_EQUAL EQUAL_EQUAL EQUAL UNDER UNDER_OR_EQUAL NOT_EQUAL


%right EQUAL
%left OR 
%left AND
%left EQUAL_EQUAL NOT_EQUAL
%left UNDER UNDER_OR_EQUAL OVER OVER_OR_EQUAL
%left MINUS PLUS
%left STAR DIV REM
%right BIN_NOT PLUS_PLUS MINUS_MINUS GET_ADRESS get_pointer uplus uminus
%left parenthesis index ARROW DOT

/* Point d'entrée de la grammaire */
%start prog

%type <Ast.program> prog



%%

vtype:
  |INT {Int}
  |VOID {Void}
  |CHAR {Char}
  |STRUCT id = ident {Struct id}
  |UNION id = ident {Union id}

ident:
  c = Name { c }   

decl_var_interne(t):
  ls = list(STAR) 
  id = ident
  {  {decvar = ( get_type_star (t,ls),id); decvar_pos = ($startpos,$endpos)}  }
  
decl_var:
  t = vtype;  (* ne prend pas les STAR *)
  lvar = separated_nonempty_list( COMMA , decl_var_interne(t)) 
  SEMICOLON
  { lvar } 


expression:
  | c = Const {Entier c}
  | ch=Chaine {Chaine ch}
  | id = Name {Variable id}
  | STAR e = expression {Pointer_access e}  
  | e1 = expression INDEX_OPEN e2 = expression INDEX_CLOSE
        {Pointer_access( Binop(PLUS, e1, e2))}
  | e = expression DOT id = ident {Access_field(e,id) }
  | e = expression ARROW id = ident { Access_field(Pointer_access e,id) } (* à vérifier, manque un enregistrement -> je vois pas lequel *)
  | e1 = expression EQUAL e2 = expression {Assignement (e1,e2)} (* vérifier e1 bien valeur gauche lors du typage ? oui*)
  | id = ident PARENTHESIS_OPEN 
                 le = separated_list(COMMA, expression)  
               PARENTHESIS_CLOSE
             {Call(id, le) }
  | u = unop_left e = expression {Unop(u,e)  }
  | e = expression u = unop_right {Unop(u,e) }
  | e1 = expression o = op e2 = expression {Binop(o,e1,e2)}
  | e1 = expression c = cmp e2 = expression {Binop(c,e1,e2)}
  | SIZEOF PARENTHESIS_OPEN t = vtype ls = loption (STAR) PARENTHESIS_CLOSE
        {Sizeof (get_type_star(t,ls) ) }  
  | PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE { e }



%inline cmp:
  |EQUAL_EQUAL { Eq}
  |NOT_EQUAL { Neq}
  |UNDER {Lt}
  |UNDER_OR_EQUAL {Leq}
  |OVER {Gt}
  |OVER_OR_EQUAL {Geq}

%inline op:
  |PLUS { BPlus}
  |MINUS {BMinus}
  |STAR { Mul }
  |DIV {Div}
  |REM {Mod}
  |AND {And}
  |OR {Or}

%inline unop_left: 
  |PLUS_PLUS { PPleft }
  |MINUS_MINUS { MMleft }
  |GET_ADRESS {Adr_get}
  |NOT {Not}
  |MINUS %prec uminus {UMinus}
  |PLUS %prec uplus {UPlus}  (* qu'est-ce que doit faire cette opérande? rien? ouais *)

%inline unop_right:
 |PLUS_PLUS { PPright }
 |MINUS_MINUS { MMright }


instr:
  |SEMICOLON {Empty} (* il faudra les enlever à un moment *)
  |e = expression SEMICOLON {Expression e}
  |IF PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE i = instruction
                                      { If(e,i,None)  }
  |IF PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE i1 = instruction 
                ELSE  i2 = instruction { If(e,i1,Some i2)}
  |While PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE i = instruction
                                      { While (e,i) }
  |FOR PARENTHESIS_OPEN le1 = separated_list(COMMA, expression) 
              SEMICOLON le2 = option(expression)
              SEMICOLON le3 = separated_list(COMMA, expression) 
       PARENTHESIS_CLOSE
       i = instruction
       { 
         For(le1,le2,le3,i)  
       } 
  |RETURN e = option(expression) SEMICOLON {Return (e)}
  |b = block {Bloc b}

instruction: (* vérifier si donne la bonne position *)
i = instr { {instr = i; instr_pos = ($startpos,$endpos)} }

block : 
OPEN_BLOCK
  lvar = loption (decl_var)
  linstr = list(instruction)
CLOSE_BLOCK
  { { bloc = (lvar,linstr) ; bloc_pos = ($startpos,$endpos)}   }

decl_typ:
  |STRUCT id = ident OPEN_BLOCK lvar =loption(loption(decl_var)) CLOSE_BLOCK  (* à tester *)
                   { {Dstruct(id,lvar)} } 
  |UNION id = ident OPEN_BLOCK lvar =loption(loption(decl_var)) CLOSE_BLOCK  (* à tester *)
                   { {Dunion(id,lvar)} } 

argument:
  t = vtype
  ls = list(STAR) 
  id = ident
  {  {decvar = ( get_type_star (t,ls),id); decvar_pos = ($startpos,$endpos)}  }
  

decl_fct:
  t = vtype 
  ls = list(STAR) 
  id = ident
  PARENTHESIS_OPEN
  larg = separated_list(COMMA, argument)
  PARENTHESIS_CLOSE
  b = block
  { { name = id; body = b; args = larg ; rtype = get_type_star(t,ls) } }

decl:
  | d = decl_var {Dvar d}
  | d = decl_typ {Dt d}
  | d = decl_fct {Df d}

prog:
ld = decl list Teof {decl = ld}


%%

