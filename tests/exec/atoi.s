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
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_test
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	li   $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_test
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	li   $a0, 42
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_2
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_test
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	li   $a0, 255
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_3
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_test
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	li   $a0, 63
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_test
	add  $sp, $sp, 4
	li   $a0, 10
	li   $v0, 11
	syscall
	li   $a0, 0
	sw   $a0, 4($fp)
	j    f_end_main
f_end_main:
	add  $sp, $fp, 4
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_test:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 4
	lw   $a0, 8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_atoi
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if3
	li   $a0, 49
	li   $v0, 11
	syscall
	b    if4
if3:
	li   $a0, 48
	li   $v0, 11
	syscall
if4:
f_end_test:
	add  $sp, $fp, 12
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_atoi:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 12
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	j    while2
while1:
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 10
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -12($fp)
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -8($fp)
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 48
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sub  $a0, $t0, $t1
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
while2:
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	add  $a0, $fp, 4
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	lb   $a0, 0($a0)
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	bnez $a0, while1
	lw   $a0, -12($fp)
	sw   $a0, 8($fp)
	j    f_end_atoi
f_end_atoi:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
str_1:
	.asciiz "1"
str_0:
	.asciiz "0"
str_4:
	.asciiz "63"
str_3:
	.asciiz "255"
str_2:
	.asciiz "42"
newline:
	.asciiz "\n"

