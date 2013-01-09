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
	la   $a0, var_s1
	add  $a0, $a0, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 65
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	la   $a0, var_s1
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 66
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	la   $a0, var_s1
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s1
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s2
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 8
	lw   $t4, var_s1+0
	sw   $t4, 0($sp)
	lw   $t4, var_s1+4
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
	la   $a0, var_s2
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s2
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s1
	add  $a0, $a0, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 67
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	la   $a0, var_s1
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 68
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	la   $a0, var_s1
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s1
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s2
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s2
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 8
	lw   $t4, var_s2+0
	sw   $t4, 0($sp)
	lw   $t4, var_s2+4
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
	la   $a0, var_s1
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s1
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s2
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	la   $a0, var_s2
	lw   $a0, 0($a0)
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
var_s2:
	.space 8
var_s1:
	.space 8

