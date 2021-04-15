# UVic CSC 230, Fall 2020
# Assignment #1, part B

# Student name: Keanu Reeves
# Student number: V1234576


# Compute the reverse of the input bit sequence that must be stored
# in register $8, and the reverse must be in register $15.



.text
start:

	# $8 - input hex value
	# $11 - 32, decrement counter
	# $13 - result of input masked with 1
	# $15 - register to hold the final reverse value 
	
	lw $8, testcase1   # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	li $11, 0		# set $11 to 0
	li $13, 0 		#set $13 to 0
	li $15, 0		#set $15 to 0
	li $11, 32 		#set $11 to 32: amount of bits to cycle through
	
loop: 				#check if rightmost bit is 0 or 1, add it to a Register, and shift that register over 
				#to prepare for new input  
	andi $13, $8, 1 	# mask with 1,, AND to isolate bit in input (R8) 
	sll $15, $15, 1  	#shift reverse bit memory to the left by 1 bit to make room for next input
	or $15, $15, $13  	#if after masking bit is a 1, will be stored as 1 in R15, else will be stored as a 0
	srl $8, $8, 1  		#shift input number to the right, in order to isolate next bit 
	addi $11, $11, -1  	#decrement loop by 1 
	bne $11, $0, loop 	#if loop is not 0, continue 
	
	
	
	
	#nop
	#add $15, $0, -10

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

exit:
	add $2, $0, 10
	syscall
	
	

.data

testcase1:
	.word	0x00200020    # reverse is 0x04000400

testcase2:
	.word 	0x00300020    # reverse is 0x04000c00
	
testcase3:
	.word	0x1234fedc     # reverse is 0x3b7f2c48
