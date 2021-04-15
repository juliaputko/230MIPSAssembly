#Julia Putko
#V00889506
	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	
	.eqv 	LETTER_a 97
	.eqv	LETTER_b 98
	.eqv	LETTER_c 99
	.eqv 	LETTER_D 100
	.eqv 	LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

#	write interrupt handler 
#transfer pressed key's value into data memory 
#indicate that a ketboard event is "pending" -- code based on the key pressed
#must still be executed
#(code outside of ktext) .text (instructions in an infinite loop_
#keep track how many times the a b c and d keys have been pressed
#counts are output on mars messages if the space key is pressed
#ignore all other keypresses
#after finishing all rocessing for a keypress the program must now indicate there is 
#no longer a pending keyboard event 

#-interrupt handler cannot use syscall or calls functions that call syscall 
#- interrupt handler cannot call any functions at all 

#.ktext(code to dispatch to the correct handler)


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
#in .text
#enable keyboard mmmio to give you an interrupt when a key is pressed 
#make a forever loop that checks for the keyboard raiding an interrupt 
#if key is pressed 
#kernel is called and jumps to .ktext
#ktext
#wcheck what happened in the coproc registers 

#look at the cause register bits 8-15 
#if bit 8 is set then it's a keyboard mmio interrupt (instead of eg the digital lab sim interrupt which sets bit 15)
#then depending on what the interrupt was .ktext executes a different set of code and then returns control to .text 


	la $s0, 0xffff0000	# control register for MMIO Simulator "Receiver"
	lb $s1, 0($s0)
	ori $s1, $s1, 0x02	# Set bit 1 to enable "Receiver" interrupts (i.e., keyboard)
	sb $s1, 0($s0)
check_for_event: 
	la $s0, KEYBOARD_EVENT_PENDING		
	lw $s1, 0($s0)			# will only exit loop if pending is not 0 
	beq $s1, $zero, check_for_event	
	
	la $s0, KEYBOARD_EVENT			
	lw $s1, 0($s0)
	beq $s1, LETTER_a, add_counts		#if key is abcd, count will be updates, nothing otherwise
	beq $s1, LETTER_b, add_counts
	beq $s1, LETTER_c, add_counts
	beq $s1, LETTER_D, add_counts
	beq $s1, LETTER_space, print_counts	#if space, output counts
check2:
	
	la $s0, KEYBOARD_EVENT_PENDING
	li $s1, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event
	
add_counts: 
	add $s2, $s1, -97		#97 substracted from value of keypress eg a-97 == 0 == first position 
	mul $s2, $s2, 4			#multiply by 4 to get offset eg a: 0*4 == 1 == offset of 1 b: 1*4 = 4 = offset 4			
	la $s0, KEYBOARD_COUNTS($s2)	#load address with offset 
	lw $s3, 0($s0)			#get number
	addi $s3, $s3, 1		#increment the number
	sw $s3, 0($s0)			#put it back into KEYBOARD COUNTS
	j check2
	
print_counts:	
	li $s1, 0
loop:
	la $s0, KEYBOARD_COUNTS($s1)	#each number, by offset of a word, looped through to print all 4 
	lw $a0, 0($s0)			#get the number stored in keyboard counts 
	addi $v0, $zero, 1
	syscall
	
	addi $s1, $s1, 4		#offset by a word
	beq $s1, 16, print_newline	#all counts have been printed 
	la $a0, SPACE			#print a space
	addi $v0, $zero, 4
	syscall
	beq $zero, $zero, loop
print_newline:
	la $a0, NEWLINE			#print newline
	addi, $v0, $zero, 4
	syscall
	j check2	
	
	.kdata

	.ktext 0x80000180
__kernel_entry:
	mfc0 $k0, $13
	andi $k1, $k0, 0x7c
	srl  $k1, $k1, 2
	beq $zero, $k1, __is_interrupt
	
__is_interrupt:
	andi $k1, $k0, 0x0100
	bne $k1, $zero, __is_keyboard_interrupt
	beq $zero, $zero, __exit_exception
	
__is_keyboard_interrupt:
	la $k0, 0xffff0004		#address of key press
	lw $k1, 0($k0)			#get key press
	la $k0, KEYBOARD_EVENT		#address of KEYBOARD_EVENT
	sw $k1, 0($k0)			#store value of key pressed in KEY_BOARD_EVENT
	la $k0, KEYBOARD_EVENT_PENDING		
	li $k1, 1
	sw $k1, 0($k0)	  # set pending to 1
	
	
	
__exit_exception:
	eret
	

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
