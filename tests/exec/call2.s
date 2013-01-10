	.text
main:
	sub  $fp, $sp, 12
	sub  $sp, $sp, 12
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
	li   $a0, 65
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 66
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 67
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_f
	add  $sp, $sp, 4
	li   $a0, 10
	li   $v0, 11
	syscall
f_end_main:
	add  $sp, $fp, 4
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_f:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 4
	lw   $a0, 16($fp)
	beqz $a0, if1
	lw   $a0, 16($fp)
	li   $v0, 11
	syscall
	sub  $sp, $sp, 4
	lw   $a0, 12($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 16($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_f
	add  $sp, $sp, 4
if1:
f_end_f:
	add  $sp, $fp, 20
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
	.align 2
newline:
	.asciiz "\n"

