.data
	str1:	.asciiz "*"  
	str2:	.asciiz " "
	str3:	.asciiz "\n"
	
	input_msg1:	.asciiz "Please enter option (1: triangle, 2: inverted triangle): "
	input_msg2:	.asciiz "Please input a triangle size: "
 
.text
.globl main 

main:
	li      $v0, 4			# call system call: print string
	la      $a0, input_msg1		# load address of string into $a0
	syscall 			# run the syscall
	
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $s0, $v0      		# store input in $s0 (option)
	
	li      $v0, 4			# call system call: print string
	la      $a0, input_msg2		# load address of string into $a0
	syscall 			# run the syscall
	
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $a0, $v0      		# store input in $a0 (size = n)
	
	slt	$t0, $a0, $zero		
	bne	$t0, $zero, main	# n < 0, illegal input 
	
	add	$a1, $zero, $zero	# $a1 = 0 (index i)
	addi	$s1, $zero, 1		# $s1 = 1
	addi	$s2, $zero, 2		# $s2 = 2
	
	beq	$s0, $s1, L1		# option = 1:  triangle
	beq	$s0, $s2, L4		# option = 2:  inverted triangle
	j	main			# option = unknown

# triangle	
L1:
	slt	$t0, $a1, $a0
	beq	$t0, $zero, END		# i >= n exit loop
	
	jal	print_layer1
	
	addi	$a1, $a1, 1
	j	L1

# inverted triangle	
L4:
	slt	$t0, $a1, $a0
	beq	$t0, $zero, END		# i >= n exit loop
	
	jal	print_layer2
	
	addi	$a1, $a1, 1
	j	L4
	
END:
# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall
	
		
#------------------------- procedure print_layer -----------------------------
# load argument n in $a0, l in $a1, return value in $v0. 
.text
print_layer1:
	addi 	$sp, $sp, -8		# adjust stack for 2 items
	sw 		$a0, 4($sp)			# save the argument n
	sw 		$a1, 0($sp)			# save the argument l
	
	addi	$t1, $zero, 1		# $t1 = 1 (index j)
	sub	$t2, $a0, $a1		# $t2 = n - l
	add	$t3, $a0, $a1		# $t3 = n + l

# j = 1 to n-l
L2:
	slt	$t0, $t1, $t2
	beq	$t0, $zero, L3		# j >= n - l exit loop
	
	li      $v0, 4			# call system call: print string
	la      $a0, str2		# load address of string into $a0
	syscall
	
	addi	$t1, $t1, 1
	j	L2

# j  = n - l to n + l
L3:
	slt	$t0, $t3, $t1
	bne	$t0, $zero, EXIT1	# j > n + l exit loop
	
	li      $v0, 4			# call system call: print string
	la      $a0, str1		# load address of string into $a0
	syscall
	
	addi	$t1, $t1, 1
	j	L3

EXIT1:
	li      $v0, 4			# call system call: print string
	la      $a0, str3		# load address of string into $a0
	syscall
	
	lw 		$a1, 0($sp)			# restore argument l
	lw 		$a0, 4($sp)			# restore argument n
	addi 	$sp, $sp, 8		# adjust stack pointer to pop 2 items
	jr	$ra

print_layer2:
	addi 	$sp, $sp, -8		# adjust stack for 2 items
	sw 		$a0, 4($sp)			# save the argument n
	sw 		$a1, 0($sp)			# save the argument l
	
	addi	$t1, $zero, 1		# $t1 = 1 (index j)
	sub	$a1, $a0, $a1		
	subi	$a1, $a1, 1		# l = n - i -1
	sub	$t2, $a0, $a1		# $t2 = n - l
	add	$t3, $a0, $a1		# $t3 = n + l

# j = 1 to n-l
L5:
	slt	$t0, $t1, $t2
	beq	$t0, $zero, L6		# j >= n - l exit loop
	
	li      $v0, 4			# call system call: print string
	la      $a0, str2		# load address of string into $a0
	syscall
	
	addi	$t1, $t1, 1
	j	L5

# j  = n - l to n + l
L6:
	slt	$t0, $t3, $t1
	bne	$t0, $zero, EXIT2	# j > n + l exit loop
	
	li      $v0, 4			# call system call: print string
	la      $a0, str1		# load address of string into $a0
	syscall
	
	addi	$t1, $t1, 1
	j	L6

EXIT2:
	li      $v0, 4			# call system call: print string
	la      $a0, str3		# load address of string into $a0
	syscall
	
	lw 		$a1, 0($sp)			# restore argument l
	lw 		$a0, 4($sp)			# restore argument n
	addi 	$sp, $sp, 8		# adjust stack pointer to pop 2 items
	jr	$ra
