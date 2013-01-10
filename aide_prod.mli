
open Mips
open Ast_Type
open Definition

(*fonction qui renvoie true si un type de données doit être aligné*)
val not_struct : mtype -> bool
val aligne : mtype -> bool
val get_size : mtype -> int
val taille_arrondie : mtype -> int
val set_loc : program -> unit
val func_begin : int -> code
val func_end : func -> code
val pointed_type : mtype -> mtype
val new_label : string -> string
val load_reg : register -> address -> mtype -> code
val store_reg : register -> address -> mtype -> code
