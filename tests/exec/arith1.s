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
	li   $a0, 100
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 4
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 102
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sub  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 100
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 4
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 216
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	div  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 3
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 37
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 32
	li   $v0, 11
	syscall
	li   $a0, 118
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	rem  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 100
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 143
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 12
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	rem  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 113
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	slt  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 108
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	slt  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 99
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	li   $v0, 11
	syscall
	li   $a0, 10
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 2
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
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

