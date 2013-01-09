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
	sub  $sp, $fp, 20
	sub  $sp, $sp, 4
	sub  $sp, $sp, 8
	lw   $t4, -20($fp)
	sw   $t4, 0($sp)
	lw   $t4, -16($fp)
	sw   $t4, 4($sp)
	sub  $sp, $sp, 8
	lw   $t4, -12($fp)
	sw   $t4, 0($sp)
	lw   $t4, -8($fp)
	sw   $t4, 4($sp)
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
	add  $a0, $fp, 12
	add  $a0, $a0, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 65
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, 12
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 66
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, 12
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 12
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 8
	lw   $t4, 12($fp)
	sw   $t4, 0($sp)
	lw   $t4, 16($fp)
	sw   $t4, 4($sp)
	lw   $a1, 8($sp)
	lw   $t4, 0($sp)
	sw   $t4, 0($a1)
	lw   $t4, 4($sp)
	sw   $t4, 4($a1)
	add  $sp, $sp, 12
	sub  $sp, $sp, 8
	lw   $t4, 0($a1)
	sw   $t4, 0($sp)
	lw   $t4, 4($a1)
	sw   $t4, 4($sp)
	add  $sp, $sp, 8
	add  $a0, $fp, 4
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 4
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 12
	add  $a0, $a0, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 67
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, 12
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 68
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, 12
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 12
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 4
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 4
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 8
	lw   $t4, 4($fp)
	sw   $t4, 0($sp)
	lw   $t4, 8($fp)
	sw   $t4, 4($sp)
	lw   $a1, 8($sp)
	lw   $t4, 0($sp)
	sw   $t4, 0($a1)
	lw   $t4, 4($sp)
	sw   $t4, 4($a1)
	add  $sp, $sp, 12
	sub  $sp, $sp, 8
	lw   $t4, 0($a1)
	sw   $t4, 0($sp)
	lw   $t4, 4($a1)
	sw   $t4, 4($sp)
	add  $sp, $sp, 8
	add  $a0, $fp, 12
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 12
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 4
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, 4
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
f_end_f:
	add  $sp, $fp, 20
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
newline:
	.asciiz "\n"

