{

}
let chiffre = ['0'-'9']
let chiffre_octal = ['0'-'7']
let chiffre_hexa = ['0'-'9' 'a'-'f' 'A'-'F' ]
let alpha = ['a'-'z' 'A'-'Z']
let ident = (alpha|'_') (alpha | chiffre |'_')*
rule entier = parse
  |"0"  {int32.zero} (* on autorise 0000 par le chemin octal*)
  |['1'-'9'] chiffre* as s {int32.of_string (s) } (* il faudra vérifier si pas trop grand et faire int32 *)
  |"0"(chiffre_octal+ as s) {int32.of_string("0o"..s) }
  |("0x"|"0X") (chiffre_hexa+ as s) {int32.of_string("0x"..s) } (* doit on supporter 0X ? *)
(* rq: doit on comme proposé accepter un 'caractère'?*)
and caractere = parse
  | [' '-'~']  [^'\\' '\'' '\"']  as c {c}
  | "\\\\" |"\\\'"|"\\\""   as c {c}
  | ("\\x" chiffre_hexa chiffre_hexa) as c {c}                (* je vais jusqu'à 126, pas 127 qui correspond à DEL *)


{

}
