.data
	input_msg:	.asciiz "Please input a number: "
	output_msg:	.asciiz "The result of fibonacci(n) is "

.text
.globl main
#------------------------- main -----------------------------
main:
# print input_msg on the console interface
	li      $v0, 4			# call system call: print string
	la      $a0, input_msg		# load address of string into $a0
	syscall                 	# run the s	yscall
 
# read the input integer in $v0
	li      $v0, 5          	# call system call: read integer
	syscall                 	# run the syscall
	move    $a0, $v0      		# store input in $a0 (set arugument of procedure fibonacci)

	slt	$t0, $a0, $zero
	bne	$t0, $zero, main	# n < 0, illegal input
	
# jump to procedure fibonacci
	add	$v0, $zero, $zero	# $v0 = 0
	jal 	fibonacci
	move 	$t0, $v0			# save return value in t0 (because v0 will be used by system call) 

# print output_msg on the console interface
	li      $v0, 4			# call system call: print string
	la      $a0, output_msg		# load address of string into $a0
	syscall                 	# run the syscall

# print the result of procedure fibonacci on the console interface
	move 	$a0, $t0			
	li 		$v0, 1				
	syscall 

# exit the program
	li 		$v0, 10				# call system call: exit
	syscall						# run the syscall

#------------------------- procedure fibonacci -----------------------------
# load argument n in $a0, return value in $v0. 
.text
fibonacci:	
	addi 	$sp, $sp, -8		# adjust stack for 2 items
	sw 		$ra, 4($sp)			# save the return address
	sw 		$a0, 0($sp)			# save the argument n
	slti 	$t0, $a0, 2			# test for n < 2
	beq 	$t0, $zero, L1		# if n >= 2 go to L1
	add	$v0, $v0, $a0		# n = 0 or n = 1, return itself
	addi 	$sp, $sp, 8			# pop 2 items off stack
	jr 		$ra					# return to caller
L1:		
	addi 	$a0, $a0, -1		# n >= 1, argument gets (n-1)
	jal 	fibonacci			# call fibonacci with (n-1)

	addi 	$a0, $a0, -1		# argument gets (n-2)
	jal 	fibonacci			# call fibonacci with (n-2)
	
	lw 		$a0, 0($sp)			# return from jal, restore argument n
	lw 		$ra, 4($sp)			# restore the return address
	addi 	$sp, $sp, 8			# adjust stack pointer to pop 2 items
	jr 		$ra					# return to the caller
