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
	sub  $sp, $sp, 4
	la   $a0, str_0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_append
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_endline
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sub  $sp, $sp, 4
	la   $a0, str_2
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_3
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_append
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_endline
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sub  $sp, $sp, 4
	la   $a0, str_4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	la   $a0, str_5
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_6
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_append
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_append
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
	j    while8
while7:
	lw   $a0, -8($fp)
	li   $v0, 11
	syscall
while8:
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
	bnez $a0, while7
f_end_print_string:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_append:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 16
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_strlen
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_strlen
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	add  $a0, $t0, $t1
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	add  $a0, $fp, -16
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -12($fp)
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
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	j    while4
while3:
	lw   $a0, -16($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	add  $a0, $fp, -12
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 1
	add  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -8($fp)
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
while4:
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	add  $a0, $fp, 8
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	lb   $a0, 0($a0)
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
	bnez $a0, while3
	j    while6
while5:
	lw   $a0, -16($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	add  $a0, $fp, -12
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	mul  $t1, $t1, 1
	add  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -8($fp)
	lw   $a1, 0($sp)
	sb   $a0, 0($a1)
	add  $sp, $sp, 4
while6:
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
	bnez $a0, while5
	lw   $a0, -16($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, -12($fp)
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
	lw   $a0, -16($fp)
	sw   $a0, 12($fp)
	j    f_end_append
f_end_append:
	add  $sp, $fp, 12
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_strlen:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 8
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	j    while2
while1:
	add  $a0, $fp, -8
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
while2:
	add  $a0, $fp, 4
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	lb   $a0, 0($a0)
	bnez $a0, while1
	lw   $a0, -8($fp)
	sw   $a0, 8($fp)
	j    f_end_strlen
f_end_strlen:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
str_5:
	.asciiz "que cela "
str_3:
	.asciiz " world"
str_6:
	.asciiz "fonctionne"
str_4:
	.asciiz "il semble "
str_0:
	.asciiz "foo"
str_1:
	.asciiz "bar"
str_2:
	.asciiz "hello"
newline:
	.asciiz "\n"

