open Ast
open Ast_Type
open Definition

exception Type_error of position * string
exception Argtype_error of position * string * (mtype list)



module SMap : Map.S with type key = string

val equiv : mtype -> mtype -> bool

val num : mtype -> bool

val lvalue : Ast_Type.expr -> bool

val mtype_of_ttype : mapelt SMap.t ->  position-> ttype -> mtype

val ttype_of_mtype : mtype -> ttype

val string_of_mtype : mtype -> string

val bien_forme : mapelt SMap.t -> mtype -> bool

val exprType : mapelt SMap.t -> Ast.expression -> Ast_Type.expression

val instrType : mapelt SMap.t -> mtype -> Ast.instruction -> Ast_Type.instruction 

val fileType : mapelt SMap.t -> Ast.decl list -> mapelt SMap.t * Ast_Type.decl list

val typage : Ast.program -> Ast_Type.program

