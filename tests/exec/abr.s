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
	sub  $sp, $sp, 4
	li   $a0, 1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_make
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 17
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_insere
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 5
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_insere
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_insere
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_to_string
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_string
	add  $sp, $sp, 4
	li   $a0, 10
	li   $v0, 11
	syscall
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 5
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_contient
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_contient
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	not  $a0, $a0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $t0, $t0, 0
	sne  $t1, $t1, 0
	and  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 17
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_contient
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $t0, $t0, 0
	sne  $t1, $t1, 0
	and  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 3
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_contient
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	not  $a0, $a0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $t0, $t0, 0
	sne  $t1, $t1, 0
	and  $a0, $t0, $t1
	beqz $a0, if28
	sub  $sp, $sp, 4
	la   $a0, str_2
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_string
	add  $sp, $sp, 4
if28:
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 42
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_insere
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 1000
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_insere
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_insere
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_to_string
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_print_string
	add  $sp, $sp, 4
	li   $a0, 10
	li   $v0, 11
	syscall
f_end_main:
	add  $sp, $fp, 4
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_to_string:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 8
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, 4($fp)
	lw   $a0, 4($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $a0, $t0, $t1
	beqz $a0, if26
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	lw   $a0, 4($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_to_string
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_append
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
if26:
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	lw   $a0, 8($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_itoa
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_append
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, 4($fp)
	lw   $a0, 0($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $a0, $t0, $t1
	beqz $a0, if27
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	lw   $a0, 0($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_to_string
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_append
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
if27:
	sub  $sp, $sp, 4
	lw   $a0, -8($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	la   $a0, str_1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_append
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sw   $a0, 8($fp)
	j    f_end_to_string
f_end_to_string:
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
	beqz $a0, if19
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
	b    if20
if19:
	add  $a0, $fp, -12
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
if20:
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
	j    while22
while21:
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
while22:
	lw   $a0, -12($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $a0, $t0, $t1
	bnez $a0, while21
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
	beqz $a0, if23
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
if23:
	j    while25
while24:
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
while25:
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 9
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sgt  $a0, $t0, $t1
	bnez $a0, while24
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
fun_print_string:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 8
	j    while18
while17:
	lw   $a0, -8($fp)
	li   $v0, 11
	syscall
while18:
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
	bnez $a0, while17
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
	j    while14
while13:
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
while14:
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
	bnez $a0, while13
	j    while16
while15:
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
while16:
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
	bnez $a0, while15
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
	j    while12
while11:
	add  $a0, $fp, -8
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
while12:
	add  $a0, $fp, 4
	lw   $t0, 0($a0)
	add  $t0, $t0, 1
	sw   $t0, 0($a0)
	sub  $a0, $t0, 1
	lb   $a0, 0($a0)
	bnez $a0, while11
	lw   $a0, -8($fp)
	sw   $a0, 8($fp)
	j    f_end_strlen
f_end_strlen:
	add  $sp, $fp, 8
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_contient:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 8($fp)
	lw   $a0, 8($a0)
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if8
	li   $a0, 1
	sw   $a0, 12($fp)
	j    f_end_contient
if8:
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 8($fp)
	lw   $a0, 8($a0)
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	slt  $a0, $t0, $t1
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 8($fp)
	lw   $a0, 4($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $a0, $t0, $t1
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $t0, $t0, 0
	sne  $t1, $t1, 0
	and  $a0, $t0, $t1
	beqz $a0, if9
	sub  $sp, $sp, 4
	lw   $a0, 8($fp)
	lw   $a0, 4($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_contient
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sw   $a0, 12($fp)
	j    f_end_contient
if9:
	lw   $a0, 8($fp)
	lw   $a0, 0($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	sne  $a0, $t0, $t1
	beqz $a0, if10
	sub  $sp, $sp, 4
	lw   $a0, 8($fp)
	lw   $a0, 0($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_contient
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	sw   $a0, 12($fp)
	j    f_end_contient
if10:
	li   $a0, 0
	sw   $a0, 12($fp)
	j    f_end_contient
f_end_contient:
	add  $sp, $fp, 12
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_insere:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 8($fp)
	lw   $a0, 8($a0)
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if1
if1:
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 8($fp)
	lw   $a0, 8($a0)
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	slt  $a0, $t0, $t1
	beqz $a0, if2
	lw   $a0, 8($fp)
	lw   $a0, 4($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if4
	lw   $a0, 8($fp)
	add  $a0, $a0, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_make
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	b    if5
if4:
	sub  $sp, $sp, 4
	lw   $a0, 8($fp)
	lw   $a0, 4($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_insere
	add  $sp, $sp, 4
if5:
	b    if3
if2:
	lw   $a0, 8($fp)
	lw   $a0, 0($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	lw   $t0, 0($sp)
	add  $sp, $sp, 4
	move $t1, $a0
	seq  $a0, $t0, $t1
	beqz $a0, if6
	lw   $a0, 8($fp)
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	sub  $sp, $sp, 4
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_make
	sw   $a0, 0($sp)
	add  $sp, $sp, 4
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	b    if7
if6:
	sub  $sp, $sp, 4
	lw   $a0, 8($fp)
	lw   $a0, 0($a0)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	jal  fun_insere
	add  $sp, $sp, 4
if7:
if3:
f_end_insere:
	add  $sp, $fp, 12
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
fun_make:
	sw   $fp, -4($sp)
	sub  $fp, $sp, 4
	sw   $ra, -4($fp)
	sub  $sp, $fp, 8
	add  $a0, $fp, -8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	li   $a0, 12
	li   $v0, 9
	syscall
	move $a0, $v0
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	add  $a0, $a0, 8
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 12($fp)
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	add  $a0, $a0, 4
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 8($fp)
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	add  $a0, $a0, 0
	sub  $sp, $sp, 4
	sw   $a0, 0($sp)
	lw   $a0, 4($fp)
	lw   $a1, 0($sp)
	sw   $a0, 0($a1)
	add  $sp, $sp, 4
	lw   $a0, -8($fp)
	sw   $a0, 16($fp)
	j    f_end_make
f_end_make:
	add  $sp, $fp, 16
	lw   $ra, -4($fp)
	lw   $fp, 0($fp)
	jr   $ra
	.data
str_1:
	.asciiz ")"
str_0:
	.asciiz "("
str_2:
	.asciiz "ok\n"
newline:
	.asciiz "\n"

