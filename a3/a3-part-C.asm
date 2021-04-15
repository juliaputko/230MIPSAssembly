# UVic CSC 230, Fall 2020
# Assignment #1, part C

# Student name: Keanu Reeves
# Student number: V1234576


# Compute M / N, where M must be in $8, N must be in $9,
# and M / N must be in $15.
# N will never be 0


.text
start:

	# $8 - first testcase
	# $9 - second testcase
	# $11 - stores 1 or 0 after < comparison
	# $15 - result after divison
	lw $8, testcase2_M
	lw $9, testcase2_N


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	addi $15, $15, 0  	# set $15 to 0
	li $11, 0		# set $11 to 0

	slt $11, $8, $9  	#check if 8<9, then put 1 in R11, 0 otherwise
	beq $11, 1, exit
	
loop: 
	sub $10, $8, $9  	#m-n stored in R10
	add $8, $10, 0 		#quotient is now the dividend
	addi $15, $15, 1 	#increment R15 by 1 everything we do a division 
	slt $11, $8, $9  	#check if 8<9, then put 1 in R11, 0 otherwise
	beq $11, 0, loop 	#branch to loop if 0 is in $11 bc that means 8 is not < 9 and subtraction wont be negative
	
	#nop
	#addi $15, $0, -10

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

exit:
	add $2, $0, 10
	syscall
		

.data

# testcase1: 370 / 120 = 3
#
testcase1_M:
	.word	370
testcase1_N:
	.word 	120
	
# testcase2: 24156 / 77 = 313
#
testcase2_M:
	.word	24156
testcase2_N:
	.word 	77
	
# testcase3: 33 / 120 = 0
#
testcase3_M:
	.word	33
testcase3_N:
	.word 	120
