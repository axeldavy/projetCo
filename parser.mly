 
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

vtype:
  |INT {Int}
  |VOID {Void}
  |CHAR {Char}

ident:
  c = Name { c }   

decl_var_interne(t) :
  ls = loption(STAR)  (* problème : * x va être reconnu comme *x. Est-ce correct en C? -> Il semble que oui*)
  id = ident
  { Dvar {decvar = ( get_type_star (t,ls),id); decvar_pos = $startpos}  }
  
decl_var:
  t = vtype (* ne prend pas les STAR *)
  lvar = loption( ((decl_var_interne(t) COMMA)*) ) @ [decl_var_interne(t)]  (* à vérifier *)
  SEMICOLON
  { Dvar {decvar = ( t,lvar); decvar_pos = $startpos} } 


expression:
  | c = Const {Entier c}
  | ch=Chaine {Chaine ch}
  | id = Name {Variable id}
  | STAR e = expression {Pointer_access e}  
  | e1 = expression INDEX_OPEN e2 = expression INDEX_CLOSE
        {Access_index (e1,e2)}  (* peut être peut-on faire sans Access_index *)
  | e = expression DOT id = ident {Access_field(e,id) }
  | e = expression ARROW id = ident { Access_field(pointer_access e,id) } (* à vérifier *)
  | e1 = expression EQUAL e2 = expression {Assignement (e1,e2)} (* vérifier e1 bien valeur gauche lors du typage ?*)
  | id = ident PARENTHESIS_OPEN 
                 le = loption( ((expression COMMA)*) ) le' = loption (expression) 
               PARENTHESIS_CLOSE
             {Call(id, le@le') }
  | u = unop_left e = expression {Unop(u,e)  }
  | e = expression u = unop_right {Unop(u,e) }
  | e1 = expression o = op e2 = expression {Binop(o,e1,e2)}
  | e1 = expression c = cmp e2 = expression {Binop(c,e1,e2)}
  | SIZEOF PARENTHESIS_OPEN t = vtype ls = loption (STAR) PARENTHESIS_CLOSE
        {Sizeof (get_type_star(t,ls) ) }  
  | PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE { e }



%inline cmp =
  |EQUAL_EQUAL { Eq}
  |NOT_EQUAL { Neq}
  |UNDER {Lt}
  |UNDER_OR_EQUAL {Leq}
  |OVER {Gt}
  |OVER_OR_EQUAL {Geq}

%inline op =
  |PLUS { BPlus}
  |MINUS {BMinus}
  |STAR { Mul }
  |DIV {Div}
  |REM {Mod}
  |AND {And}
  |OR {Or}

%inline unop_left = 
  |PLUS_PLUS { PPleft }
  |MINUS_MINUS { MMleft }
  |GET_ADRESS {Adr_get}
  |NOT {Not}
  |MINUS %prec uminus {UMinus}
  |PLUS %prec uplus {UPlus}  (* qu'est-ce que doit faire cette opérande? rien? *)

%inline unop_right =
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
  |FOR PARENTHESIS_OPEN le1 = loption( ((expression COMMA)*) ) le1' = loption (expression)
              SEMICOLON le2 = loption(expression)
              SEMICOLON le3 = loption( ((expression COMMA)*) ) le3' = loption (expression)
       PARENTHESIS_CLOSE
       i = instruction
       { 
         if List.length (le1') >=2 or List.length (le3') >=2 then failwith "message d'erreur a gerer";
         For(le1@le1',le2,le3@le3',i)  
       } 
  |RETURN e = expression? SEMICOLON {Return (e)}
  |b = block {Bloc b}

instruction: (* vérifier si donne la bonne position *)
i = instr { {instr = i; instr_pos = $startpos} }

block : 
  lvar = loption (decl_var)
  linstr = loption(instruction)
  { { bloc = (lvar,linstr) ; bloc_pos = $startpos}   }


%%

