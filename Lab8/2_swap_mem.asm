.data
test: .asciiz "ABCDEGFHIJKL"

.text 
.globl main
	
main: 		la	$a0, test		# load address of the original test for syscall
		li	$v0, 4			# specify Print String service
		syscall				# print the prompt string
		
		li   	$v0, 11			# Setup print char syscall 
		addi 	$a0, $zero, 10		# Load newline ascii char
		syscall				# execute syscall
	
		la	$a0, test		# move the test char pointer to $a0
		addi	$a1, $zero, 5		# set first index arg to be 5
		addi	$a2, $zero, 6		# Set second index arg to be 6
		jal 	swap_mem		# Call swap_mem

		la	$a0, test		# load address of the swapped test for syscall	
		li	$v0, 4			# specify Print String service
		syscall				# print the prompt string


		li 	$v0, 10		 	# Setup Exit Syscall
		syscall				# Execute syscall
	
swap_mem:	move	$t0, $a0		# char pointer
		move	$t1, $a1		# Index 1
		move	$t2, $a2		# Index 2

		add	$t3, $t0, $t1		# Address of char at index 1
		add	$t4, $t0, $t2		# Address of char at index 2
		
		lbu	$t5, 0($t3)		# Char at index 1
		lbu	$t6, 0($t4)		# Char at index 2
		
		sb	$t5, 0($t4)
		sb	$t6, 0($t3)
		
		jr	$ra
		