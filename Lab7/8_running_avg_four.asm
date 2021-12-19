.data
arr: .word 0, 0, 0, 4, 2, 8, 3, 1, 9, 10, 11, 13, 14, 15, 18, 27, 4, 9, 1, 19


.text 
.globl main
	
main:		la 	$s3, arr
		
		# print original array
		move	$a0, $s3
		addi	$a1, $zero, 20
		jal 	print_arr
	
		# alter array to running average
		move	$a0, $s3
		addi	$a1, $zero, 20
		jal	running_avg_4
		
		# print running_avg_array
		move	$a0, $s3
		addi	$a1, $zero, 20
		jal 	print_arr
		

		

end_main:	li 	$v0, 10 		# Setup Exit Syscall
		syscall				# Execute syscall
		


running_avg_4:	move	$t0, $a0		# set t0 to pointer to array
		move	$t1, $a1		# set t1 to length of array 
		add	$t2, $zero, $t1		# set t2 to i, init with 3
		addi	$t2, $t2, -1		# subtract 1 from i
		
for:		blt	$t2, $zero, end		# if i is equal to length of array, end
		addi 	$t4, $zero, 0		# set t4 to total, init with 0
		
		sll	$t3, $t2, 2		# t3 = i * 4
		
		add	$t5, $t3, $t0		# t5 = i + address
		lw	$t6, 0($t5)		# t6 = value of t5
		add	$t4, $t4, $t6		# Add this to total
		
		lw	$t6, -4($t5)		# t6 = value of t5 - 4
		add	$t4, $t4, $t6		# Add this to total
		
		lw	$t6, -8($t5)		# t6 = value of t5 - 8
		add	$t4, $t4, $t6		# Add this to total
		
		lw	$t6, -12($t5)		# t6 = value of t5 - 12
		add	$t4, $t4, $t6		# Add this to total
		
		
avg:		srl	$t7, $t4, 2		# set s1 (avg) to $t4 (total) / 4
		add	$t3, $t3, $t0
		sw	$t7, 0($t3)		# set this address to the averaged value
		
		
		addi	$t2, $t2, -1		#decrement i
		j	for

		
end:		jr	$ra		# Return count


# Print Function
print_arr:	addi	$s0, $zero, 0		# initialise s0 to 0
		addi	$s1, $a0, 0
		
for_main:	bge	$s0, $a1, end_print	# if s0 is greater than or equal to the length of the array, end
		sll 	$s7, $s0, 2 
		add	$s5, $s1, $s7
		lw 	$s6, 0($s5)
		
		li   	$v0, 1			# Setup print int syscall 
		add 	$a0, $zero, $s6		# Load ascii char into a0
		syscall				# execute syscall
		
		li   	$v0, 11			# Setup print char syscall 
		li 	$a0, 0x20	 	# Load ascii char into a0
		syscall				# execute syscall
		
		addi 	$s0, $s0, 1		#increment s0 by 1
		j	for_main

end_print:	li   	$v0, 11			# Setup print char syscall 
		addi 	$a0, $zero, 10		# Load newline ascii char
		syscall				# execute syscall
		jr	$ra
