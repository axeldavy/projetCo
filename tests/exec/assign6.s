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
	add  $a0, $fp, -16
	add  $a0, $a0, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 65
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, -16
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 66
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	add  $a0, $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 120
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 121
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, -16
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	lb   $a0, 1($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	lb   $a0, 0($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	li   $a0, 10
	li   $v0, 11
	syscall
	add  $a0, $fp, -20
	add  $a0, $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 88
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, -20
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 89
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, -16
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	lb   $a0, 1($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	lb   $a0, 0($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	lw   $a0, 0($a0)
	li   $v0, 11
	syscall
	li   $a0, 10
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $t4, -20($fp)
	sw   $t4, 0($sp)
	lw   $a1, 4($sp)
	lw   $t4, 0($sp)
	sw   $t4, 0($a1)
	add  $sp, $sp, 8
	sub  $sp, $sp, 4
	lw   $t4, 0($a1)
	sw   $t4, 0($sp)
	add  $sp, $sp, 4
	add  $a0, $fp, -16
	lw   $a0, 4($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	lb   $a0, 1($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
	add  $a0, $a0, 8
	lb   $a0, 0($a0)
	li   $v0, 11
	syscall
	add  $a0, $fp, -16
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

