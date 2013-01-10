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
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_fact_imp
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if3
	li   $a0, 49
	li   $v0, 11
	syscall
if3:
	sub  $sp, $sp, 4
	li   $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_fact_imp
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if4
	li   $a0, 50
	li   $v0, 11
	syscall
if4:
	sub  $sp, $sp, 4
	li   $a0, 5
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_fact_imp
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 120
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if5
	li   $a0, 51
	li   $v0, 11
	syscall
if5:
	li   $a0, 10
	li   $v0, 11
	syscall
f_end_main:
	add  $sp, $fp, 4
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_fact_imp:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 8
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	j    while2
while1:
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	add  $a0, $fp, 4
	lw   $t0, 0($a0)
	sub  $t0, $t0, 1
	sw   $t0, 0($a0)
	add  $a0, $t0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $a0, $t0, $t1
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
while2:
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sgt  $a0, $t0, $t1
	bnez $a0, while1
	lw   $a0, -8($fp)
	sw   $a0, 8($fp)
	j    f_end_fact_imp
f_end_fact_imp:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
	.align 2
newline:
	.asciiz "\n"

