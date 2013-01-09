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
	jal  fun_fact_rec
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if2
	li   $a0, 49
	li   $v0, 11
	syscall
if2:
	sub  $sp, $sp, 4
	li   $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_fact_rec
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
	li   $a0, 50
	li   $v0, 11
	syscall
if3:
	sub  $sp, $sp, 4
	li   $a0, 5
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_fact_rec
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 120
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if4
	li   $a0, 51
	li   $v0, 11
	syscall
if4:
	li   $a0, 10
	li   $v0, 11
	syscall
f_end_main:
	add  $sp, $fp, 4
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_fact_rec:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sle  $a0, $t0, $t1
	beqz $a0, if1
	li   $a0, 1
	sw   $a0, 8($fp)
	sub  $sp, $sp, 4
	j    f_end_fact_rec
if1:
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sub  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_fact_rec
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $a0, $t0, $t1
	sw   $a0, 8($fp)
	sub  $sp, $sp, 4
	j    f_end_fact_rec
f_end_fact_rec:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
newline:
	.asciiz "\n"

