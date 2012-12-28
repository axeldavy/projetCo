
open Mips
open Ast_Type
open Definition

(*fonction qui renvoie true si un type de données doit être aligné*)
val aligne : mtype -> bool
val get_size : mtype -> int
val size_octet : mtype -> int
val set_loc : program -> unit
val func_begin : int -> code (* pour le moment prend juste fp en paramètre et alloue de la frame*)
val func_end : func -> code
val pointed_type : mtype -> mtype
(*val avant_appel : unit -> code
val apres_appel : unit -> code*)
(*val prep_binop : mtype -> mtype -> code
val prep_unop : mtype -> code *)
val new_label : string -> string
val charger_p : mtype -> register -> register -> code
val mettre_p : mtype -> register -> register -> code
val charger_p2 : int -> register -> register -> int -> code
val mettre_p2 : int -> register -> register -> int -> code
