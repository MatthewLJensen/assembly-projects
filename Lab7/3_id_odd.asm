.data
prompt: .asciiz "Enter number for evaluation: "

.text 
.globl main
main: 	la   	$a0, prompt	# load address of prompt1 for syscall
	li   	$v0, 4		# specify Print String service
	syscall			# print the prompt string
	
	li   	$v0, 5		# specify Read Integer service
	syscall			# Read the number. After this instruction, the number read is in $v0.
	
	move 	$a0, $v0	# move the read int to the argument
	jal 	is_odd		# Call is_odd function
	move 	$s0, $v0
	
	li   	$v0, 1     	# Load print int for syscall 
	add 	$a0, $zero, $s0	# Load argument for print int
	syscall			# Execute print int
	
	li   	$v0, 11		# Setup print char syscall 
	addi 	$a0, $zero, 10	# Load newline ascii char
	syscall			# execute syscall
	
	j 	main

is_odd:	andi 	$v0, $a0, 1 	# initialize sum
end: 	jr	$ra