{
  (* partie inspirée du code du td3 *)
  open Lexing
  open Parser
  
  exception Lexing_error of string

  (* type tokenres = Teof | Const of Int32.t | Name of string | Chaine of string 
		  | IF | THEN | ELSE | FUNCTION |STRUCT | UNION | INT | CHAR
                  | VOID | NULL | FOR | WHILE | RETURN | ARROW
		  | OVER | OVER_OR_EQUAL | EQUAL_EQUAL | EQUAL 
		  | UNDER | UNDER_OR_EQUAL | NOT_EQUAL | PARENTHESIS_OPEN | COMMA
		  | PARENTHESIS_CLOSE | INDEX_OPEN | INDEX_CLOSE | DOT | REM | AND | OR
                  | PLUS_PLUS | MINUS_MINUS | BIN_NOT | GET_ADRESS | SIZEOF
		  | STAR | PLUS | MINUS | DIV | I_DOT | SEMICOLON | COLON 
                  | OPEN_BLOCK | CLOSE_BLOCK
*)
  (* tables des mots-clés *)
  let kwd_tbl = 
    ["if", IF; "then", THEN; "else", ELSE;
     "function", FUNCTION; "struct", STRUCT; "union", UNION; "int", INT; 
     "void",VOID; "NULL",NULL; "char", INT; "for", FOR;
     "while", WHILE; "return", RETURN; "sizeof", SIZEOF; (* rajouter putchar et sbrk ? *)
    ]

  let id_or_kwd = 
    let h = Hashtbl.create 17 in
    List.iter (fun (s,t) -> Hashtbl.add h s t) kwd_tbl;
    fun s -> 
      try List.assoc s kwd_tbl with _ -> Name s

  let newline lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <- 
      { pos with pos_lnum = pos.pos_lnum + 1; pos_bol = pos.pos_cnum }

}
let chiffre = ['0'-'9']
let chiffre_octal = ['0'-'7']
let chiffre_hexa = ['0'-'9' 'a'-'f' 'A'-'F' ]
let alpha = ['a'-'z' 'A'-'Z']
let ident = (alpha|'_') (alpha | chiffre |'_')*
let caractere =   [ ' ' '!' '#' - '[' ']'-'_'  'a'-'~' ]  | "\\\\" |"\\\'"|"\\\""  
                                     | ("\\x" chiffre_hexa chiffre_hexa)  
               (* je vais jusqu'à 126, pas 127 qui correspond à DEL *)
			   

rule token = parse
  | ident as s {id_or_kwd s}
  | ' ' | '\t' | '\r' { token lexbuf}
  | '\n' { newline lexbuf; token lexbuf } (* end of line *)
  | eof {Teof}
  |"0"  {Const Int32.zero} (* on autorise 0000 par le chemin octal*)
  |['1'-'9'] chiffre* as s {Const (Int32.of_string (s)) } (* il faudra vérifier si pas trop grand et faire int32. try... etc *)
  |"0"(chiffre_octal+ as s) {Const (Int32.of_string( "0o" ^ s)) }
  |("0x") (chiffre_hexa+ as s) 
                  {Const (Int32.of_string("0x" ^ s)) } 
  | "'" (caractere as c) "'" {Const (Int32.of_int (int_of_char (char_of_character (Lexing.from_string c))))}
  | "\"" { Chaine (lire_chaine lexbuf) }
  | "/*" { comment1 lexbuf; token lexbuf }
  | "*/" { raise (Lexing_error ("no opened comment")) }
  | "//" [ ^'\n']* '\n' { token lexbuf } (* a tester *)
  | "//" [ ^'\n']* eof { Teof }  (* en général il y a un saut à la ligne avant eof, mais dans certains cas il n'y en a pas *)
  | "->" { ARROW }
  | ">"  { OVER }
  | ">=" { OVER_OR_EQUAL }
  | "==" { EQUAL_EQUAL } 
  | "="  { EQUAL } 
  | "<"  { UNDER }
  | "<=" { UNDER_OR_EQUAL }
  | "!=" { NOT_EQUAL } 
  | "("  { PARENTHESIS_OPEN }
  | ")"  { PARENTHESIS_CLOSE }
  | "{"  { OPEN_BLOCK }
  | "}"  { CLOSE_BLOCK }
  | "["  { INDEX_OPEN }
  | "]"  { INDEX_CLOSE }
  | "."  { DOT }
  | "*"  { STAR }
  | "+"  { PLUS }
  | "-"  { MINUS }
  | "//" { DIV }
  | "%"  { REM }
  | "?"  { I_DOT}
  | ";"  { SEMICOLON }
  | ":"  { COLON }
  | ","  { COMMA }
  | "&&" { AND }
  | "&"  { GET_ADRESS }
  | "||" { OR }
  | _ as c  { raise (Lexing_error ("illegal character: " ^ String.make 1 c)) }

and comment1 = parse (* pas de commentaires du même type imbriqués. ici type /* commentaire */ *)
  | "*/" {}
  | "\n" {newline lexbuf}
  | eof { raise (Lexing_error( "unfinished comment") )}
  | _  {comment1 lexbuf}

and lire_chaine = parse
  | "\"" {""}
  | eof  {raise(Lexing_error "unfinished String" )}
  | "\n" {raise(Lexing_error "end of line before finishing string")}
  | caractere as c {(String.make 1 (char_of_character (Lexing.from_string c))) ^(lire_chaine lexbuf)}

  (*c'est une rule qui ne sera pas appelee sur lexbuf, mais sur une chaine 
  représentant un caractère pour le transformer en caractère caml correspondant*)
 and char_of_character = parse
	| [ ' ' '!' '#' - '[' ']'-'_'  'a'-'~' ] as c {c}
	| "\\\\" {'\\'}
	| "\\\'" {'\''}
	| "\\\""  {'\"'}
	| "\\x" ((chiffre_hexa chiffre_hexa) as c) {char_of_int (int_of_string ("0x"^c))}
	| _ {assert false}
{

}
