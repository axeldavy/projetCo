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
	sub  $sp, $fp, 8
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 5
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $a0, $t0, $t1
	li   $v0, 9
	syscall
	move $a0, $v0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	add  $a0, $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 65
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 66
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 1($a0)
	li   $v0, 11
	syscall
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 0($a0)
	li   $v0, 11
	syscall
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	add  $a0, $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 97
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 98
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 1($a0)
	li   $v0, 11
	syscall
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 0($a0)
	li   $v0, 11
	syscall
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 1($a0)
	li   $v0, 11
	syscall
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 0($a0)
	li   $v0, 11
	syscall
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	add  $a0, $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 67
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 1($a0)
	li   $v0, 11
	syscall
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 3
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 68
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 3
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 0($a0)
	li   $v0, 11
	syscall
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 4
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 69
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 4
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 2
	add  $a0, $t0, $t1
	lb   $a0, 0($a0)
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

