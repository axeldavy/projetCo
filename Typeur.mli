open Ast
open Ast_Type

val equiv : mtype -> mtype -> bool

val num : mtype -> bool

val lvalue : Ast_Type.expr -> bool

val mtype_of_ttype : mapelt SMap.t -> ttype -> mtype


val bien_forme : mapelt SMap.t -> mtype -> bool

val exprType : mapelt SMap.t -> Ast.expression -> Ast_Type.expression

val instrType : mapelt SMap.t -> mtype -> Ast.instruction -> Ast_Type.instruction 

val fileType : mapelt SMap.t -> Ast.decl list -> mapelt SMap.t * Ast_Type.decl list


