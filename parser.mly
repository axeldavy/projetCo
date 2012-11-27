 
%{
  open Definition
  open Ast
  open Lexing
  
  let rec get_type_star (t,ls) =
   if ls = [] then t
   else Pointer (get_type_star (t, List.tl (ls)))

%}

%token <Int32.t> CONST
%token <string> NAME
%token <string> CHAINE
%token DOT (*I_DOT*) IF (*THEN*) ELSE (*FUNCTION*) STRUCT UNION Teof 
%token PARENTHESIS_OPEN PARENTHESIS_CLOSE INDEX_OPEN INDEX_CLOSE
%token OPEN_BLOCK CLOSE_BLOCK 
%token GET_ADRESS COMMA
%token CHAR INT VOID (*NULL*) ARROW RETURN SEMICOLON WHILE FOR SIZEOF
%token PLUS MINUS STAR DIV REM AND OR PLUS_PLUS MINUS_MINUS NOT 
%token OVER OVER_OR_EQUAL EQUAL_EQUAL EQUAL UNDER UNDER_OR_EQUAL NOT_EQUAL


%right EQUAL
%left OR 
%left AND
%left EQUAL_EQUAL NOT_EQUAL
%left UNDER UNDER_OR_EQUAL OVER OVER_OR_EQUAL
%left MINUS PLUS
%left STAR DIV REM
%right NOT PLUS_PLUS MINUS_MINUS GET_ADRESS get_pointer uplus uminus
%left PARENTHESIS_OPEN PARENTHESIS_CLOSE INDEX_OPEN INDEX_CLOSE ARROW DOT
(*vérif à faire sur la dernière ligne, les parenthèses, et index*)

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
  c = NAME { c }   

aux_decl_var:
  ls = list(STAR) 
  id = ident
  { ls,id,($startpos,$endpos)  }
  
decl_var:
  t = vtype;  (* ne prend pas les STAR *)
  lvar = separated_nonempty_list( COMMA , aux_decl_var) 
  SEMICOLON
  { List.map (fun (ls,id,pos) -> 
    {decvar = get_type_star (t,ls),id ; decvar_pos = pos} ) lvar } 

expression :
  e = expr {{exp = e; exp_pos = ($startpos,$endpos)}} 
expr:
  | c = CONST {Entier c}
  | ch=CHAINE {Chaine ch}
  | id = NAME {Variable id}
  | STAR e  = expression  %prec get_pointer {Pointer_access e}  
  | e1 = expression INDEX_OPEN e2 = expression INDEX_CLOSE
      {Pointer_access({exp= Binop(BPlus, e1, e2); exp_pos= ($startpos,$endpos)})}
  | e = expression DOT id = ident {Access_field(e,id) }
  | e = expression ARROW id = ident 
      { Access_field({exp=Pointer_access(e);exp_pos = ($startpos,$endpos)},id) }
  | e1 = expression EQUAL e2 = expression {Assignement (e1,e2)} 
  | id = ident PARENTHESIS_OPEN 
                 le = separated_list(COMMA, expression)  
               PARENTHESIS_CLOSE
             {Call(id, le) }
  | u = unop_left e = expression {Unop(u,e)  }
  | e = expression u = unop_right {Unop(u,e) }
  | e1 = expression o = op e2 = expression {Binop(o,e1,e2)}
  | e1 = expression c = cmp e2 = expression {Binop(c,e1,e2)}
  | SIZEOF PARENTHESIS_OPEN t = vtype ls = list (STAR) PARENTHESIS_CLOSE
        {Sizeof (get_type_star(t,ls) ) }  
  | PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE { e.exp }



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
  |MINUS {UMinus}
  |PLUS {UPlus} (*on ne peut pas mettre de %prec dans un %inline, voir à mofifier le truc si ça pose problème de pas le mettre*) 

%inline unop_right:
 |PLUS_PLUS { PPright }
 |MINUS_MINUS { MMright }


instr:
  |SEMICOLON {Empty} 
  |e = expression SEMICOLON {Expression e}
  |IF PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE i = instruction
                                      { If(e,i,None)  }
  |IF PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE i1 = instruction 
                ELSE  i2 = instruction { If(e,i1,Some i2)}
  |WHILE PARENTHESIS_OPEN e = expression PARENTHESIS_CLOSE i = instruction
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
  lvar = list (decl_var)
  linstr = list(instruction)
CLOSE_BLOCK
  { let lvar = List.flatten lvar in 
  { bloc = (lvar,linstr) ; bloc_pos = ($startpos,$endpos) }  }

decl_typ:
  |STRUCT id = ident OPEN_BLOCK lvar =list(decl_var) CLOSE_BLOCK  (* à tester *)
             {let lvar = List.flatten lvar in
	      {dectype =Dstruct(id,lvar); dectype_pos = ($startpos,$endpos)} } 
  |UNION id = ident OPEN_BLOCK lvar =list(decl_var) CLOSE_BLOCK  (* à tester *)
             {let lvar = List.flatten lvar in 
	     {dectype = Dunion(id,lvar); dectype_pos = ($startpos,$endpos)} } 

argument:
  t = vtype
  ls = list(STAR) (*selon le poly, les arguments ne peuvent pas être des pointeurs*)
  id = ident
  {  get_type_star (t,ls) ,id  }
  

decl_fct:
  t = vtype 
  ls = list(STAR) 
  id = ident
  PARENTHESIS_OPEN
  larg = separated_list(COMMA, argument)
  PARENTHESIS_CLOSE
  b = block
  { { decfun = (get_type_star(t,ls)), id, larg, b ;
   decfun_pos = ($startpos,$endpos) }}

decl:
  | d = decl_var {List.map (fun dv -> Dvar dv) d}
  | d = decl_typ {[Dt d]}
  | d = decl_fct {[Df d]}

prog:
ld = list(decl) Teof {{decl = List.flatten ld}}


%%

