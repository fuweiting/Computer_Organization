.data
	input_msg:	.asciiz "Please input a number: "
	output_msg1:	.asciiz "It's a prime"
	output_msg2:	.asciiz "It's not a prime"

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg on the console interface
	li      $v0, 4				# call system call: print string
	la      $a0, input_msg		# load address of string into $a0
	syscall                 	# run the syscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $a0, $v0      		# store input in $a0 (set arugument of procedure prime)
	
	slti	$t1, $a0, 1
	bne	$t1, $zero, L4		# input < 1, not a prime
	
# jump to procedure prime
	jal 	prime
	move 	$t0, $v0			# save return value in t0 (because v0 will be used by system call) 

# print output_msg on the console interface
	beq	$t0, $zero, L4			# if return value = 0 go to L4
	li      $v0, 4				# call system call: print string
	la      $a0, output_msg1		# load address of string into $a0
	j	L5				
L4:
	li      $v0, 4
	la      $a0, output_msg2
L5:
	syscall                 	# run the syscall


# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall

#------------------------- procedure prime -----------------------------
# load argument n in $a0, return value in $v0. 
.text
prime:	
	addi 	$sp, $sp, -4		# adiust stack for 1 items
	sw 		$a0, 0($sp)			# save the argument n
	addi	$t0, $zero, 1		# $t0 = 1
	addi 	$t1, $zero, 2		# i = 2
	bne 	$a0, $t0, L2		# if n != 1 go to L2
L1:
	add 	$v0, $zero, $zero		# return 0
	lw 		$a0, 0($sp)			# return from jal, restore argument n
	addi 	$sp, $sp, 4			# pop 1 items off stack
	jr 		$ra					# return to caller
L2:		
	mul 	$t2, $t1, $t1		# $t2 = i*i
	slt	$t3, $a0, $t2		
	bne	$t3, $zero, L3		# if i*i > n go to L3
	rem	$t4, $a0, $t1		# $t4 = n % i
	beq	$t4, $zero, L1		# if $t4 = 0 go to L1
	addi	$t1, $t1, 1		# i = i + 1
	j	L2
L3:
	addi 	$v0, $zero, 1		# return 1
	lw 		$a0, 0($sp)			# return from jal, restore argument n
	addi 	$sp, $sp, 4			# pop 1 items off stack
	jr 		$ra					# return to caller
