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
	li   $a0, 65
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	li   $v0, 11
	syscall
	li   $a0, 1
	beqz $a0, if1
	add  $a0, $fp, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 66
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, 0($fp)
	li   $v0, 11
	syscall
	b    if2
if1:
	add  $a0, $fp, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 67
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, 0($fp)
	li   $v0, 11
	syscall
if2:
	lw   $a0, -8($fp)
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

