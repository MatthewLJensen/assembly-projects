.data
prompt: .asciiz "\nEnter an integer to be converted to floating point hexadecimal format: "
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
		jal	int_to_float		# Call int_to_float
		
		move	$a0, $v0		# move the result from int_to_float into the argument for print hex
		jal 	print_hex		# Call print_hex

		j 	main

		li 	$v0, 10		 	# Setup Exit Syscall
		syscall				# Execute syscall
	
int_to_float:
		move	$t0, $a0		# Store the user inputted int value in $t0
		bnez	$t0, check_sign
		addi	$v0, $zero, 0
		jr 	$ra
		
check_sign:		
		bltz	$t0, negative_sign	# check if the value is negative
		li	$t1, 0			# if the value is positive, $t1 is 0
		j	check_exponent
		
negative_sign: 	li	$t1, 1			# otherwise it is a 1
		xori	$t0, $t0, 0xFFFFFFFF	# Now we want to flip bits
		addi	$t0, $t0, 1		# Add 1

check_exponent:	li	$t2, 31			# $t2 is set to 31, I will decrement it and shift right through the integer, when I get a 1, then $t7 is my exponenet value
exponent_loop:	srlv	$t7, $t0, $t2		# shift right all the way, then decrement until you hit a 1
		andi	$t7, $t7, 1		# get the value of the lowest bit after shifting right
		beq	$t7, 1,	add_127		# If the value is a 1, then you have the exponent
		addi	$t2, $t2, -1		# decrement from exponent value
		j	exponent_loop		# jump to the beginning of the expnonent loop

add_127:	li	$t6, 32			# set $t6 to 32
		sub	$t6, $t6, $t2		# get the value 32-exponent, to be used later
		addi	$t2, $t2, 127		# add 127 to the exponent value, to get the proper format

combine:	sllv	$t0, $t0, $t6		# shift the main part of the number to the left 32-exponent times.
		srl	$t0, $t0, 9		# Shift the main part to the right 9 times
		
		sll	$t1, $t1, 31		#shifts the sign bit to the left by 31
		sll	$t2, $t2, 23		# Shifts the exponent to the left by 23
		
		add	$t3, $t2, $t1		# add together the sign and the exponent
		add	$t3, $t3, $t0		# add the (sign + exponent) with mattise
		
		move	$v0, $t3
		jr	$ra
		
		
	
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
