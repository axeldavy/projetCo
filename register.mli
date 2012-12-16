open Mips 

(* interface simple pour sauvegarder/restaurer ce qu'il faut au début et à la fin des fonctions et pour allouer des nouvelles variables*)

(* Il n'y a pas d'optimisations pour choisir à quoi attribuer les registres et les places sur la stack. Donne un nouveau truc à chaque fois *)

type data_func = { size_fp : int; register_used : register list; register_to_save : register list }


val func_begin : data_func -> code 
val func_end : data_func -> code

type reg_or_stack = r of register | s of int

val new_var : data_func -> (data_func * reg_or_stack)

