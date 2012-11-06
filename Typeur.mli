val equiv : Definition.ttype -> Definition.ttype -> bool

val num : Definition.ttype -> bool

val lvalue : Definition.expr -> bool

module SMap : Map.S with type key = string 

type mapelt = 
	| Var of Definition.ttype
	| Fun of Definition.ttype * (Definition.ttype list) 
	| Str of (Definition.ttype * string) list
	| Uni of (Definition.ttype * string) list

exception Type_error of Definition.position * string
exception Argtype_error of Definition.position * string * (Definition.ttype list)

val bien_forme : mapelt SMap.t -> Definition.ttype -> bool

val getType : mapelt SMap.t -> Definition.node -> Definition.ttype


