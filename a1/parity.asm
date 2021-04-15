# UVic CSC 230, Fall 2020
# Assignment #1, part A

# Student name: Julia Putko
# Student number: V00889506


# Compute odd parity of word that must be in register $8
# Value of odd parity (0 or 1) must be in register $15


.text

 
	

start:
	# $8 - word to compute the parity of
	# $9 - decrement from 32 counter 
	# $11 - mask result storage 
	# $12 - mask with 1
	# $13 - increment counter of set bits
	# $14 - final set bit count + 1 in order to find final parity value 
	# $15 - value of odd parity (0 or 1) 

	lw $8, testcase1 	# STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	li $12, 0 		# set $12 to 0
	li $13, 0 		# set $13 to 0
	li $14, 0		# set $14 to 0
	li $15, 0 		# set $15 to 0
	
	addi $9, $9, 32		#store 32 in register 9, because we are going to iterate through 32 bit test cases so need to preform loop 32 time
	addi $12, $12, 1	#reg 12 has the number 1 in it, for bne purposes  #masking with AND gate 
	
loop: 
		
	and $11, $8, 01		# store in $11, ANDi anything with 01 will return a 1 if there is something there in rightmost spot 
	bne $12, $11, skip  	# if register 11 and register 12 (1) are not equal, dont increment 
	addi $13, $13, 1  	#equal to 1 therefore increment by 1 
	
skip:   		
	srl $8, $8, 1 		# shift right logical, result stored back in $8 		
	addi $9, $9, -1  	#deincrement counter in register 9 by 1
	bne $9, 0, loop  	#if $9 != 0, loop,
	addu $14, $13, $12   	# add to $14 what is in register $13(keeping track of set bits) and $12(just 1 ) 
	and $15, $14, 01  	# If set bit+1 && 1 == 1(parity is 1), == 0 (parity is 0) 
	
	#addi $15, $0, -10


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


exit:
	add $2, $0, 10
	syscall
		

.data

testcase1:
	.word	0x00200020    # odd parity is 1

testcase2:
	.word 	0x00300020    # odd parity is 0
	
testcase3:
	.word  0x1234fedc     # odd parity is 0

