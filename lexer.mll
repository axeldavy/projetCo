{
  (* partie inspirée du code du td3 *)
  open Lexing
  open Parser

  exception Lexing_error of string

  (* type tokenres = Teof | Const of Int32.t | Name of string | Chaine of string 
		  | IF | THEN | ELSE | FUNCTION |STRUCT | UNION | INT 
                  | VOID | NULL | FOR | WHILE | RETURN | ARROW
		  | OVER | OVER_OR_EQUAL | EQUAL_EQUAL | EQUAL 
		  | UNDER | UNDER_OR_EQUAL | NOT_EQUAL | PARENTHESIS_OPEN | COMMA
		  | PARENTHESIS_CLOSE | INDEX_OPEN | INDEX_CLOSE | DOT | REM | AND | OR
                  | PLUS_PLUS | MINUS_MINUS | BIN_NOT | MAY_BE_ADRESS_OR_BIN_AND 
		  | STAR | PLUS | MINUS | DIV | I_DOT | SEMICOLON | COLON *)

  (* tables des mots-clés *)
  let kwd_tbl = 
    ["if", IF; "then", THEN; "else", ELSE;
     "function", FUNCTION; "struct", STRUCT; "union", UNION; "int", INT; 
     "void",VOID; "NULL",NULL; "for", FOR;
     "while", WHILE; "return", RETURN;
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
let caractere =   ([' '-'~']  [^'\\' '\'' '\"'])  | "\\\\" |"\\\'"|"\\\""  
                                     | ("\\x" chiffre_hexa chiffre_hexa)  
               (* je vais jusqu'à 126, pas 127 qui correspond à DEL *)




rule token = parse
  | ident as s {id_or_kwd s}
  | ' ' | '\t' | '\r' { token lexbuf}
  | '\n' { newline lexbuf; token lexbuf } (* end of line *)
  | eof {Teof}
  |"0"  {Const Int32.zero} (* on autorise 0000 par le chemin octal*)
  |['1'-'9'] chiffre* as s {Const (Int32.of_string (s)) } (* il faudra vérifier si pas trop grand et faire int32 *)
  |"0"(chiffre_octal+ as s) {Const (Int32.of_string( String.concat "0o" [s])) }
  |("0x"|"0X") (chiffre_hexa+ as s) 
                  {Const (Int32.of_string( String.concat "0x" [s])) } (* doit on supporter 0X ? *)
  | "\"" { let p = lire_chaine [] lexbuf in Chaine (String.concat "" p) }
  | "/*" { comment1 lexbuf; token lexbuf }
  | "*/" { raise (Lexing_error ("no opened comment")) }
  | "//" { comment2 lexbuf; token lexbuf }
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
  | "||" { OR }
  | _ as c  { raise (Lexing_error ("illegal character: " ^ String.make 1 c)) }

and comment1 = parse (* pas de commentaires du même type imbriqués. ici type /* commentaire */ *)
  | "*/" {}
  | "\n" {newline lexbuf}
  | eof { raise (Lexing_error( "unfinished comment") )}
  | _  {comment1 lexbuf}

and comment2 = parse
  | "\n" {newline lexbuf}
  | eof {} (* problème ici: token ne va peut-être pas renvoyer TEOF *)
  | _ { comment2 lexbuf }

and lire_chaine p = parse
  | "\"" {p}
  | eof  {raise(Lexing_error "unfinished String" )}
  | "\\" {raise(Lexing_error "string functionnality not implemented")}
  | "\n" {raise(Lexing_error "end of line before finishing string")}
  | _ as c {lire_chaine ((String.make 1 c)::p) lexbuf}


{

}
