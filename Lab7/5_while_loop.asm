0.text 
.globl main
	
space_count:	
		addi 	$t0, $zero, 0		# Initialize count to t0 and 0
		addi 	$t1, $zero, 0		# Initialize i to t1 and 0
		li		$t4, 0x20			# Load space ASCII value into $t4
		
while:		
		add		$t2, $t1, $a0		# set t2 to new address, since a char is only 1 byte
		lbu 	$t3, 0($t2)			# Set $t3 to new char
		
		beq		$t3, $zero, end		# jump to end if string hits null terminated value
		
		bne		$t3, $t4, increment	# If the char is not a space, increment i and go back to beginning of while otherwise:
		addi	$t0, $t0, 1			# increent counter

increment:	
		addi	$t1, $t1, 1
		j		while
		
end:	
		move	$v0, $t0			# set return value to count
		jr		$ra					# Return count