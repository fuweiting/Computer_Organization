.data
	input_msg1:	.asciiz "Please enter option (1: add, 2: sub, 3: mul): "
	input_msg2:	.asciiz "Please enter the first number: "
	input_msg3:	.asciiz "Please enter the second number: "
	output_msg:	.asciiz "The calculation result is: "

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg1 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg1		# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0 (option)
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $s0, $v0      		# store input in $s0 (option)

# print input_msg2 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg2		# load address of string into $a0
	syscall                 	# run the syscall

# read the input integer in $v0 (1st number)
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $s1, $v0      		# store input in $s1 (1st number)

# print input_msg3 on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg3		# load address of string into $a0
	syscall                 	# run the syscall

# read the input integer in $v0 (2nd number)
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $s2, $v0      		# store input in $s2 (2nd number)

	addi	$t1, $zero, 1		# $t1 = 1
	addi	$t2, $zero, 2		# $t2 = 2
	addi	$t3, $zero, 3		# $t3 = 3
	
	beq	$s0, $t1, L1		# option = add
	beq	$s0, $t2, L2		# option = sub
	beq	$s0, $t3, L3		# option = mul
	j 	main			# option = unknow
L1:
	add	$s3, $s1, $s2		
	j	EXIT	
L2:
	sub	$s3, $s1, $s2		
	j	EXIT
L3:
	mul	$s3, $s1, $s2		# option = mul

EXIT:
# print output_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg		# load address of string into $a0
	syscall                 	# run the syscall


# print the result on the console interface
	move 	$a0, $s3			
	li 		$v0, 1				
	syscall 

# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall


.text
