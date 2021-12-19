# Compute several Fibonacci numbers and put in array, then print
.data
prompt1: .asciiz "Enter Number 1: "
prompt2: .asciiz "Enter Number 2: "
answer: .asciiz "Answer: "
separator: .asciiz "-------------------------------"

	# Program Memory Section
	.text
	.globl main

main:

	la   $a0, separator	# load address of prompt1 for syscall
	li   $v0, 4		# specify Print String service
	syscall			# print the prompt string

	li   $v0, 11		# Setup print char syscall 
	addi $a0, $zero, 10	# Load newline ascii char
	syscall			# execute syscall

	la   $a0, prompt1	# load address of prompt1 for syscall
	li   $v0, 4		# specify Print String service
	syscall			# print the prompt string
	
	li   $v0, 5		# specify Read Integer service
	syscall			# Read the number. After this instruction, the number read is in $v0.

	add $t0, $v0, $zero	# Move read integer to $t0
	
	li   $v0, 11		# Setup print car syscall 
	addi $a0, $zero, 10	# Load newline ascii char
	syscall			# execute syscall
	
	la   $a0, prompt2	# load address of prompt2 for syscall
	li   $v0, 4		# specify Print String service
	syscall			# print the prompt string

		
	li   $v0, 5		# specify Read Integer service
	syscall			# Read the number. After this instruction, the number read is in $v0.

	add $t1, $v0, $zero	# Move read integer to $t1
	
	add $t2, $t1, $t0	# Perform the addition and put result in $t2
	
	li   $v0, 11		# Setup print char syscall 
	addi $a0, $zero, 10	# Load newline ascii char
	syscall			# execute syscall
	
	#Print Answer
	la   $a0, answer	# load address of answer for syscall
	li   $v0, 4		# specify Print String service
	syscall			# print the prompt string
	
	#Print value1
	li   $v0, 1     	# Load print int for syscall 
	add $a0, $zero, $t0	# Load argument for print int
	syscall			# Execute print int
	

	#Print Space
	li   $v0, 11		# Load print char for syscall
	addi $a0, $zero, 32	# Load ascii char for space (32) into argument
	syscall			# execute syscall
	
	#Print +
	li   $v0, 11		# Load print char for syscall
	addi $a0, $zero, 43	# Load ASCII char for + (43) into argument
	syscall			# Execute syscall
	
	#Print Space
	li   $v0, 11		# Load print char for syscall
	addi $a0, $zero, 32	# Load ascii char for space (32) into argument
	syscall			# execute 
	
	li   $v0, 1     	# Load print int for syscall 
	add $a0, $zero, $t1	# Load argument for print int
	syscall			# Execute print int
	
	#Print Space
	li   $v0, 11		# Load print char for syscall
	addi $a0, $zero, 32	# Load ascii char for space (32) into argument
	syscall			# execute syscall
	
	#Print =
	li   $v0, 11		# Load print char for syscall
	addi $a0, $zero, 61	# Load ASCII char for = (61) into argument
	syscall			# Execute syscall
	
	#Print Space
	li   $v0, 11		# Load print char for syscall
	addi $a0, $zero, 32	# Load ascii char for space (32) into argument
	syscall			# execute syscall
	
	li   $v0, 1    		# Load print int for syscall
	add $a0, $zero, $t2	# Load int into argumen	t
	syscall			# Execute syscall
	
	li   $v0, 11		# Setup print char syscall 
	addi $a0, $zero, 10	# Load newline ascii char
	syscall			# execute syscall
	
	j main			# Jump to beginning
	
	li $v0, 10 		# Setup Exit Syscall (Should never run)
	syscall			# Execute syscall (Should never run)
