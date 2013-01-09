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
	li   $a0, 65
	li   $v0, 11
	syscall
	li   $a0, 10
	li   $v0, 11
	syscall
f_end_main:
	add  $sp, $fp, 4
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
newline:
	.asciiz "\n"

