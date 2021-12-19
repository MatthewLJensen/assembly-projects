.data
test: .asciiz "123456789"

.text 
.globl main
	
main: 		la	$a0, test		# move the test char pointer to $a0
		jal 	string_length		# Call swap_mem

		move	$a0, $v0		# load returned length value into $a0
		li	$v0, 1			# specify Print int service
		syscall				# print the prompt string

		li 	$v0, 10		 	# Setup Exit Syscall
		syscall				# Execute syscall
	
string_length:	move	$t0, $a0		# char pointer
		li	$t1, 0			# Set i to 0
		
loop:		add	$t2, $t0, $t1		# Adds the char pointer to the index
		lbu	$t3, 0($t2)		# gets the ascii value of char into $t3
		
		beq	$t3, $zero, end		# jump to end if string hits null terminated value
		addi	$t1, $t1, 1
		j	loop


end:		move 	$v0, $t1
		jr $ra
		