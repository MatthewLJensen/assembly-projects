.data
prompt: .asciiz "Enter an integer to be converted to hexadecimal: "
pre: 	.asciiz "0x"

digit_to_hex:	.byte	'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

.text 
.globl main
	
main: 		la   	$a0, prompt		# load address of prompt1 for syscall
		li   	$v0, 4			# specify Print String service
		syscall				# print the prompt string
	
		li   	$v0, 5			# specify Read Integer service
		syscall				# Read the number. After this instruction, the number read is in $v0.
	
		move 	$a0, $v0		# move the read int to the argument
		jal 	print_hex		# Call print_hex


		li 	$v0, 10		 	# Setup Exit Syscall
		syscall				# Execute syscall
	
print_hex:	move	$t0, $a0
		li	$t1, 32			# value to srl
		la	$t2, digit_to_hex	# ptr to lookup table

		
		# Prints 0x
		la   	$a0, pre		# load address of pre for syscall
		li   	$v0, 4			# specify Print String service
		syscall	
		
		# Prints the rest of the chars
loop:		addi	$t1, $t1, -4		# decrement srl value by 4
		srlv	$t3, $t0, $t1		# first time this SRLVs 28, then 24, then 20, 16, 12, 8, 4, 0
		andi	$t4, $t3, 0xF		# extract digit. This ANDs the integer byte with all ones, in order to copy it to $t4
		add	$t4, $t4, $t2		# Adds output to the address in the map
		lbu	$t4, 0($t4)

		
		add   	$a0, $t4, $zero		# load desired char into $a0
		li   	$v0, 11			# specify Print String service
		syscall	
		
		bne	$t1, $zero,loop		# has the loop looped while srl has been 0? If not, then loop again. Otherwise, return.
		
		jr	$ra