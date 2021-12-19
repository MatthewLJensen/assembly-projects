# Sample Data Memory Initialization
# Lab 3.3

	# Data Memory Section
	.data
value1: .word 5
value2: .word 89
	.align 2

	# Program Memory Section
	.text
	.globl main

main:
	#First line of code here
	lw $t0, value1
	lw $t1, value2
	sub $s0, $t0, $t1
	li $v0, 10
	syscall