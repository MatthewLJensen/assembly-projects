.text 
.globl main


main:	addi 	$s1, $zero, 0 	# initialize sum
	addi 	$s0, $zero, 0	# initialize i
	addi 	$s5, $zero, 10 	# initialize temp 10
	
for:	bge	$s0, $s5, e_for	# branch if i >= 10
	
	move 	$a0, $s0	# move i into argument
	jal 	is_odd		# Call is_odd function
	move 	$s2, $v0	# load response from is_odd into $s1
	
	addi 	$s3, $zero, 1		# initialize $s2 to 1
	blt	$s2, $s3, repeat	# If remainder is less than 1, it's even, so go to repeat	
	
	add	$s1, $s1, $s0	# sum += i
	
repeat:	addi	$s0, $s0, 1	# add 1 to i
	j	for
	
e_for:	li $v0, 10 		# Setup Exit Syscall
	syscall			# Execute syscall
	
	
is_odd:	andi 	$v0, $a0, 1 	# initialize sum
end: 	jr	$ra