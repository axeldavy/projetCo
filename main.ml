(*Tres fort inspire du td3 *)

open Format
open Lexing

(* Option de compilation, pour s'arrêter à l'issue du parser *)
let parse_only = ref false

(* Noms des fichiers source et cible *)
let ifile = ref ""
let ofile = ref ""

let set_file f s = f := s 

(* Les options du compilateur que l'on affiche en tapant minic --help *)
let options = 
  ["-parse-only", Arg.Set parse_only, 
   "  Pour ne faire uniquement que la phase d'analyse syntaxique"]

let usage = "usage: minic [option] file.c"

(* localise une erreur en indiquant la ligne et la colonne *)
let localisation pos =
  let l = pos.pos_lnum in
  let c = pos.pos_cnum - pos.pos_bol + 1 in
  eprintf "File \"%s\", line %d, characters %d-%d:\n" !ifile l (c-1) c

let () = 
  (* Parsing de la ligne de commande *)
  Arg.parse options (set_file ifile) usage;

  (* On vérifie que le nom du fichier source a bien été indiqué *)
  if !ifile="" then begin eprintf "Aucun fichier à compiler\n@?"; exit 1 end; 

  (* Ce fichier doit avoir l'extension .c *)
  if not (Filename.check_suffix !ifile ".c") then begin
    eprintf "Le fichier d'entrée doit avoir l'extension .c\n@?";
    Arg.usage options usage;
    exit 1
  end;

  (* Ouverture du fichier source en lecture *)
  let f = open_in !ifile in
    
  (* Création d'un tampon d'analyse lexicale *)
  let buf = Lexing.from_channel f in
  
  try
    let p = Parser.prog Lexer.token buf in
    close_in f;
    if !parse_only then exit 0;
    let r = Typeur.typage p in ();
    printf "Compilation de %s terminee@." !ifile;
    exit 0 
  with
    | Lexer.Lexing_error c -> 
	(* Erreur lexicale. On récupère sa position absolue et 
	   on la convertit en numéro de ligne *)
	localisation (Lexing.lexeme_start_p buf);
	eprintf "Erreur dans l'analyse lexicale: %s@." c;
	exit 1
    | Parser.Error -> 
	(* Erreur syntaxique. On récupère sa position absolue et on la 
	   convertit en numéro de ligne *)
	localisation (Lexing.lexeme_start_p buf);
	eprintf "Erreur dans l'analyse syntaxique@.";
	exit 1
    | Typeur.Type_error (p,s) -> 
        localisation (fst p) ;
        eprintf "Erreur de Typage: %s @." s;
        exit 1
    | Typeur.Argtype_error (pos,id,l) -> 
	localisation (fst pos) ; 
	eprintf "Erreur de Typage: les arguments reçus de '%s' sont du type : @." id ;
	List.iter (fun t -> eprintf "%s, " (Typeur.string_of_mtype t)) l ; 
	eprintf "@.";	
	exit 1 
 
