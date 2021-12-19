.data
test: .asciiz "The quick brown fox jumps over the lazy dog."
#test: .asciiz "EDCBA"

.text 
.globl main
	
main: 		la	$a0, test		# load address of the original test for syscall
		li	$v0, 4			# specify Print String service
		syscall				# print the prompt string
		
		li   	$v0, 11			# Setup print char syscall 
		addi 	$a0, $zero, 10		# Load newline ascii char
		syscall				# execute syscall
	
		la	$a0, test		# move the test char pointer to $a0
		jal 	s_sort			# Call s_sort

		la	$a0, test		# load address of the sorted test for syscall	
		li	$v0, 4			# specify Print String service
		syscall				# print the prompt string


		li 	$v0, 10		 	# Setup Exit Syscall
		syscall				# Execute syscall

	

s_sort:		move	$t0, $a0		# Char pointer is stored in $t0
		
		# CALL STRING_LENGTH
		addi	$sp, $sp, 8
		sw	$ra, 8($sp)
		sw	$t0, 4($sp)
		
		jal	string_length
		
		lw	$t0, 4($sp)
		lw	$ra, 8($sp)
		move	$t1, $v0		# $t1 will be length, retrieved from string_length function
		# END CALL STRING_LENGTH
		
		addi	$t2, $zero, 0		# Initialize i to 0, within $t2

for_1:		bge	$t2, $t1, end_for_1	# If i is greater than or equal to length, then end
		
		add	$t3, $t2, $zero		# set index_of_min to i, stored within $t3
		
		add	$t4, $zero, $t2		# Set j equal to i, stored within $t4

for_2:		bge	$t4, $t1, end_for_2	
		
		add	$t5, $t0, $t3		# Get's address of message[index_of_min]
		lbu	$t5, 0($t5)		# get value at message[index_of_min]
		add	$t6, $t0, $t4		# Get's address of message[j]
		lbu	$t6, 0($t6)		# get value at message[j]
		
		ble	$t5, $t6, end_if
		add	$t3, $zero, $t4
		
end_if:		
		addi	$t4, $t4, 1
		j	for_2
end_for_2:

		# CALL SWAP
		addi	$sp, $sp, 32
		sw	$ra, 32($sp)
		sw	$t0, 28($sp)
		sw	$t1, 24($sp)
		sw	$t2, 20($sp)
		sw	$t3, 16($sp)
		sw	$t4, 12($sp)
		sw	$t5, 8($sp)
		sw	$t6, 4($sp)
		
		move	$a0, $t0
		move	$a1, $t2
		move	$a2, $t3
		jal	swap_mem
		
		lw	$t6, 4($sp)
		lw	$t5, 8($sp)
		lw	$t4, 12($sp)
		lw	$t3, 16($sp)
		lw	$t2, 20($sp)
		lw	$t1, 24($sp)
		lw	$t0, 28($sp)
		lw	$ra, 32($sp)
		# END CALL SWAP

		addi	$t2, $t2, 1
		j	for_1
end_for_1:	jr	$ra




swap_mem:	move	$t0, $a0		# char pointer
		move	$t1, $a1		# Index 1
		move	$t2, $a2		# Index 2

		add	$t3, $t0, $t1		# Address of char at index 1
		add	$t4, $t0, $t2		# Address of char at index 2
		
		lb	$t5, 0($t3)		# Char at index 1
		lb	$t6, 0($t4)		# Char at index 2
		
		sb	$t5, 0($t4)
		sb	$t6, 0($t3)
		
		jr	$ra


	

string_length:	move	$t0, $a0		# char pointer
		li	$t1, 0			# Set i to 0
		
loop:		add	$t2, $t0, $t1		# Adds the char pointer to the index
		lbu	$t3, 0($t2)		# gets the ascii value of char into $t3
		
		beq	$t3, $zero, end		# jump to end if string hits null terminated value
		addi	$t1, $t1, 1
		j	loop


end:		move 	$v0, $t1
		jr $ra
		