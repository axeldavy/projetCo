	.text
main:
	sub  $fp, $sp, 8
	sub  $sp, $sp, 8
	sw   $a0, 4($sp)
	sw   $a1, 0($sp)
	jal  fun_main
	li   $v0, 10
	syscall
fun_main:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 4
	sub  $sp, $sp, 4
	la   $a0, str_0
	sw   $a0, -4($sp)
	sub  $sp, $sp, 4
	jal  fun_print_endline
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	la   $a0, str_1
	sw   $a0, -4($sp)
	sub  $sp, $sp, 4
	jal  fun_print_string
	add  $sp, $sp, 4
f_end_main:
	add  $sp, $fp, 4
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_print_endline:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 4
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	sw   $a0, -4($sp)
	sub  $sp, $sp, 4
	jal  fun_print_string
	add  $sp, $sp, 4
	li   $a0, 10
	li   $v0, 11
	syscall
f_end_print_endline:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_print_string:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 8
	j    while2
while1:
	lw   $a0, -8($fp)
	li   $v0, 11
	syscall
while2:
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 4($sp)
	add  $a0, $fp, 4
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	lb   $a0, 0($a0)
	lw   $a1, 4($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	bnez $a0, while1
f_end_print_string:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
str_1:
	.asciiz "hello world\n"
str_0:
	.asciiz "foo"
newline:
	.asciiz "\n"

