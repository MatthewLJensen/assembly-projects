.data
test1: .asciiz "four"
test12: .asciiz "four score and 7 years ago, our fathers brought forth on this continent a new nation"
test2: .asciiz "conceived in liberty and dedicated to the proposition that all men are created equal"
test3: .asciiz "three words here"
test4: .asciiz "five words in this string"
test5: .asciiz "there are ten words in this test string sample case "


.text 
.globl main
	
main:	
		la		$a0, test5			# load test into argument
		jal		space_count
		add		$s0, $v0, $zero
		
		
		li   	$v0, 1     			# Load print int for syscall 
		add 	$a0, $zero, $s0		# Load argument for print int
		syscall						# Execute print int	
		
		li   	$v0, 11				# Setup print char syscall 
		addi 	$a0, $zero, 10		# Load newline ascii char
		syscall						# execute syscall
		
		li 		$v0, 10 			# Setup Exit Syscall
		syscall						# Execute syscall


space_count:	
		addi 	$t0, $zero, 0		# Initialize count to t0 and 0
		addi 	$t1, $zero, 0		# Initialize i to t1 and 0
		li		$t4, 0x20
		
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