#Julia Putko
#V00889506
	.data
ARRAY_A:
	.word	21, 210, 49, 4
ARRAY_B:
	.word	21, -314159, 0x1000, 0x7fffffff, 3, 1, 4, 1, 5, 9, 2
ARRAY_Z:
	.space	28
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
		
	
	.text  
main:	
	la $a0, ARRAY_A
	addi $a1, $zero, 4
	jal dump_array
	#output for this would be 
	#21, 210, 49, 4
	
	la $a0, ARRAY_B
	addi $a1, $zero, 11
	jal dump_array
	
	la $a0, ARRAY_Z
	lw $t0, 0($a0)   
	addi $t0, $t0, 1    
	sw $t0, 0($a0)    
	addi $a1, $zero, 9  
	jal dump_array
		
	addi $v0, $zero, 10
	syscall

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	

dump_array:

#write this procedure 
#	$a0: holds address of first integer in an array of integers
#	$a1: holds the number of integers to be output on the consle in a single line 
#	return value: none
#	
#	system call 1: is used to print an integer on teh console; the integer to be printed is sotred in $a0 while the value 1 is 
#	stored in $v0
#	system call 4: is ued to print a null terminated string on the console; the address of the string to be printed is storedin $a0
#	while value 4 is stored in $v0

	move $t2, $a0
loop:

	lbu $a0, 0($t2)
	addi $v0, $zero, 1
	syscall
	
	la $a0, SPACE
	addi $v0, $zero, 4
	syscall
	
	addi $t2, $t2, 4
	lbu $a0, 0($t2)
	addi $a1, $a1, -1 
	bne $a1, $zero, loop
	
	la $a0, NEWLINE
	addi $v0, $zero, 4
	syscall
	#jr $ra
	

	
	
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
