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
	sub  $sp, $sp, 4
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_itoa
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_endline
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sub  $sp, $sp, 4
	li   $a0, 17
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_itoa
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_endline
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sub  $sp, $sp, 4
	li   $a0, 5003
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_itoa
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_endline
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sub  $sp, $sp, 4
	li   $a0, 12
	neg  $a0, $a0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_itoa
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_endline
	add  $sp, $sp, 4
	li   $a0, 0
	sw   $a0, 4($fp)
	j    f_end_main
f_end_main:
	add  $sp, $fp, 4
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_print_endline:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 4
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_string
	add  $sp, $sp, 4
	li   $a0, 10
	li   $v0, 11
	syscall
f_end_print_endline:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_print_string:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 8
	j    while9
while8:
	lw   $a0, -8($fp)
	li   $v0, 11
	syscall
while9:
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
	bnez $a0, while8
f_end_print_string:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_itoa:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 16
	add  $a0, $fp, -16
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	slt  $a0, $t0, $t1
	beqz $a0, if1
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	neg  $a0, $a0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, -16
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	b    if2
if1:
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
if2:
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -12($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 10
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	div  $a0, $t0, $t1
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	j    while4
while3:
	add  $a0, $fp, -16
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -12($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 10
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	div  $a0, $t0, $t1
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
while4:
	lw   $a0, -12($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $a0, $t0, $t1
	bnez $a0, while3
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -16($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	li   $v0, 9
	syscall
	move $a0, $v0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	add  $a0, $fp, -16
	lw   $t0, 0($a0)
	sub  $t0, $t0, 1
	sw   $t0, 0($a0)
	add  $a0, $t0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 1
	add  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	slt  $a0, $t0, $t1
	beqz $a0, if5
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 1
	add  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 45
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	neg  $a0, $a0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
if5:
	j    while7
while6:
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	add  $a0, $fp, -16
	lw   $t0, 0($a0)
	sub  $t0, $t0, 1
	sw   $t0, 0($a0)
	add  $a0, $t0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 1
	add  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 48
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 10
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	rem  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 10
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	div  $a0, $t0, $t1
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
while7:
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 9
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sgt  $a0, $t0, $t1
	bnez $a0, while6
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -16($fp)
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 1
	add  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 48
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 10
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	rem  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sw   $a0, 8($fp)
	j    f_end_itoa
f_end_itoa:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
	.align 2
newline:
	.asciiz "\n"

