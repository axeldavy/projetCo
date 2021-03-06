
type register =
  | ZERO | A0 | A1 | A2 | A3 | V0 | V1 | T0 | T1 | T2 | T3 | T4 
  | S0 | S1 | S2 | S3 | S4 | RA | SP | FP 

type address =
  | Alab of int * string
  | Areg of int * register

type operand =
  | Oimm of int
  | Oreg of register

type arith = Add | Sub | Mul | Div | Rem

type condition = Eq | Ne | Le | Lt | Ge | Gt

type label = string

type instruction =
  | Move of register * register
  | Li of register * int
  | Li32 of register * int32
  | La of register * label
  | Lw of register * address
  | Sw of register * address
  | Lb of register * address
  | Sb of register * address
  | Arith of arith * register * register * operand
  | And of register * register * operand
  | Or of register * register * operand
  | Neg of register * register
  | Not of register * register (* pseudo-instruction *)
  | Set of condition * register * register * operand
  | B of label
  | Beq of register * register * label
  | Beqz of register * label
  | Bnez of register * label
  | J of string
  | Jal of string
  | Jr of register
  | Jalr of register
  | Syscall
  | Label of string
  | Inline of string

type code

val nop : code
val mips : instruction list -> code
val inline : string -> code
val (++) : code -> code -> code

type word = Wint of int | Waddr of string

type data =
  | Asciiz of string * string
  | Word of string * word list
  | Space of string * int
  | Align of int

type program = {
  text : code;
  data : data list;
}

val print_program : Format.formatter -> program -> unit

