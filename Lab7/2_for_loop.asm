.text 
.globl main

main:	addi 	$s1, $zero, 0 	# initialize sum
	addi 	$s0, $zero, 0	# initialize i
	addi 	$t1, $zero, 10 	# initialize temp 10
	
for:	bge	$s0, $t1, e_for
	add	$s1, $s1, $s0
	addi	$s0, $s0, 1
	j	for
	
e_for:	li $v0, 10 		# Setup Exit Syscall
	syscall			# Execute syscall