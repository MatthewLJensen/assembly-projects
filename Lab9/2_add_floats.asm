.data
prompt1: .asciiz "Enter the first floating point number: "
prompt2: .asciiz "Enter the second floating point number: "
pre: 	.asciiz "0x"

.text 
.globl main
	
main: 		la   	$a0, prompt1		# load address of prompt1 for syscall
		li   	$v0, 4			# specify Print String service
		syscall				# print the prompt string
	
		li   	$v0, 6			# specify Read float service
		syscall				# Read the number. After this instruction, the number read is in $v0.
		

		addi	$sp, $sp, 4
		swc1	$f0, 4($sp)		# move result from $f0 into stack
		lw	$s0, 4($sp)		# then back into $s0
		
		
		la   	$a0, prompt2		# load address of prompt1 for syscall
		li   	$v0, 4			# specify Print String service
		syscall				# print the prompt string
	
		li   	$v0, 6			# specify Read float service
		syscall				# Read the number. After this instruction, the number read is in $v0.
		
		addi	$sp, $sp, 4
		swc1	$f0, 4($sp)		# move result from $f0 into stack
		lw	$s1, 4($sp)		# then back into $s1
	
	
		move 	$a0, $s0		# move the first read float into $a0
		move	$a1, $s1		# move the second read float into $a1
		jal	add_floats		# Call int_to_float
		
		
		# Print float
		addi	$sp, $sp, 4
		sw	$v0, 4($sp)		# move result from $f0 into stack
		lwc1	$f12, 4($sp)		# then back into $s0
		li 	$v0, 2		 	# Setup print float Syscall
		syscall				# Execute syscall


		li 	$v0, 10		 	# Setup Exit Syscall
		syscall				# Execute syscall
		
add_floats:		
		move 	$t0, $a0		# move $a0, the first float, into $t0
		move	$t1, $a1		# move $a1, the second float, into $t1
		
		bnez	$t0, check_second	# checks if the first float is zero, if so, return the second
		move	$v0, $t1
		jr	$ra

check_second:	bnez	$t1, no_zeros		# checks if the second float is zero, if so, return the first, otherwise, start the program
		move	$v0, $t0
		jr	$ra
		
no_zeros:
		
		# we want to add $t0 with $t1
		# First we get their exponents by themselves
		
		# Get the exponent on the first float
		sll	$t2, $t0, 1		# shift $t0 to the left by 1
		srl	$t2, $t2, 24		# shift $t2 to the right by 24

		# Get the exponent on the second float
		sll	$t3, $t1, 1		# shift $t0 to the left by 1
		srl	$t3, $t3, 24		# shift $t2 to the right by 24
		
		# get the significand of the first float	
		sll	$t4, $t0, 9		# shift significand all the way to the left
		srl	$t4, $t4, 9		# this leaves you with just the significand
		#andi	$t4, $t2, 0x807FFFFF	# this gives me the value with the sign bit and the significand
		
		# get the significand of the second float
		sll	$t5, $t1, 9		# shift significand all the way to the left
		srl	$t5, $t5, 9		# this leaves you with just the significand
		#andi	$t5, $t3, 0x807FFFFF	# this gives me the value with the sign bit and the significand

		#Add in the implied 1s in the 24th spot
		addi	$t4, $t4, 0x00800000	# add a 1 to the 24th position for float1
		addi	$t5, $t5, 0x00800000	# add a 1 to the 24th position for float2
		
						
exp_loop:	blt	$t3, $t2, second_smaller	# jump to second_smaller, if the exponent on the second float is smaller
		beq	$t3, $t2, exp_same		# jump to exp_same if the exponents have been equalized
		
		srl	$t4, $t4, 1		# shift the signifand of float 1 to the right
		addi	$t2, $t2, 1		# increment the exponent of float 1
		j	exp_loop

			
		
second_smaller:
		srl	$t5, $t5, 1		# shift the significand of float 1 to the right
		addi	$t3, $t3, 1		# increment the exponenet of float 2
		j 	exp_loop			# Loop again
		
	
exp_same:					
		# First we have to add the sign bits again. But if the number is negative, we need to subtract it from 0, rather than adding the 1
		andi 	$t7, $t0, 0x80000000	# set $t7 to the sign bit of float 1
		beqz	$t7, check_next		# if the sign is a zero, we will skip the subrtaction
		subu	$t4, $zero, $t4		# subtract float1 from 0 to make it negative

check_next:	
		andi 	$t7, $t1, 0x80000000	# set $t7 to the sign bit of float 2
		beqz	$t7, sign_finished	# if the sign is a zero, we will skip the subrtaction
		subu	$t5, $zero, $t5		# subtract float2 from 0 to make it negative
		
sign_finished:
		
		# Now we add the significands
		add 	$t6, $t5, $t4		# $t6 now holds the added value, without the exponent, and with the extra implied 1
		
		# if this is less than zero, we should be able to make it positive, and remember that it was negative
		andi	$t4, $t6, 0x80000000	# set $t4 to the sign bit of the added value
		bgez	$t6, normalize		# skip the sign conversion
		sub	$t6, $zero, $t6		# switch the sum to positive
						# remember that is was negative
		

normalize:	bnez	$t6, normalize_no_z	# checks if the second float is zero, if so, return the first, otherwise, start the program
		move	$v0, $t6
		jr	$ra
		
normalize_no_z:	li	$t7, 24			# Find the first significand bit, should never be further left than 24. I will decrement it and shift right through the integer, when I get a 1, then ($t7 - 24) + 1 is how many times I need to shift right
normalize_loop:	srlv	$t5, $t6, $t7		# shift right all the way, then decrement until you hit a 1. We overwrite t5, as it is no longer necessary
		andi	$t5, $t5, 1		# get the value of the lowest bit after shifting right
		beq	$t5, 1,	shift_norm	# If the value is a 1, then you have the exponent
		addi	$t7, $t7, -1		# decrement from exponent value
		j	normalize_loop		# jump to the beginning of the expnonent 		
shift_norm:
		addi 	$t5, $t7, -23		# calculate ammount to shift right
		#andi	$t4, $t6, 0x80000000	# set $t4 to the sign bit of the added value
		
		# if $t5 is negative, shift left by that value +1, otherwise, shift right by that value
		bltz	$t5, shift_left
		srlv	$t6, $t6, $t5		# shift right the correct number of times
		add	$t2, $t2, $t5		# add the number of right shifts to the exponent
		andi	$t6, $t6, 0x007FFFFF	# delete all but significand
		j	add

shift_left:
		subu	$t5, $zero, $t5		# make $t5 positive
		#addi	$t5, $t5, 1		# add 1 to $t5
		sllv	$t6, $t6, $t5		# shift left the correct number of times
		sub	$t2, $t2, $t5		# subtract the number of left shifts from the exponent
		andi	$t6, $t6, 0x007FFFFF	# delete all but significand

add:		
		# Add in the exponent and sign
		add	$t6, $t6, $t4		# add the sign
		sll	$t2, $t2, 23		# shift exponenet to the left the proper number of times
		add	$t6, $t6, $t2		# add the exponent
		
		move	$v0, $t6
		jr	$ra
