#Julia Putko
#V00889506
# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
BOX_ROW:
	.word	0x0
BOX_COLUMN:
	.word	0x0

	.eqv LETTER_a 97  	#move left one pixel
	.eqv LETTER_d 100	#move right one pixel
	.eqv LETTER_w 119	#move up one pixel
	.eqv LETTER_x 120	#move down one pixel
	.eqv BOX_COLOUR 0x0099ff33
	.eqv BOX_COLOUR_BLACK 0x00000000
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# initialize variables
	# $a0: the box row 
	# $a1: the box column coordinate 
	
	la $s5, BOX_ROW
	la $s6, BOX_COLUMN
	lw $a0, 0($s5)
	lw $a1, 0($s6)
	addi $a2, $zero, BOX_COLOUR
	jal draw_bitmap_box
	
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
	
#jump to what the move is 	
	beq $s1, LETTER_a, move_left   	#move left one pixel
	beq $s1, LETTER_d, move_right	#move right one pixel
	beq $s1, LETTER_w, move_up	#move up one pixel
	beq $s1, LETTER_x, move_down	#move down one pixel

check2:
	la $s0, KEYBOARD_EVENT_PENDING
	li $s1, 0
	sw $s1, 0($s0)
	beq $zero, $zero, check_for_event

move_left:	
	jal erase 		#first erase
	addi $a0, $a0, -1 	#redraw with row 1 pixel to the left
  	addi $a2, $zero, BOX_COLOUR
	jal draw_bitmap_box
	addi $s1, $zero, 0
	beq $zero, $zero, check2	#go back to checking pending keyboard
	
move_right: #d press
	jal erase 		
	addi $a0, $a0, 1 		#redraw with row 1 pixel to the right 
	addi $a2, $zero, BOX_COLOUR
	jal draw_bitmap_box
	addi $s1, $zero, 0
	beq $zero, $zero, check2
move_up:
	jal erase
	addi $a0, $a0, -16 		#redraw with row 1 pixel up
	addi $a2, $zero, BOX_COLOUR
	jal draw_bitmap_box
	addi $s1, $zero, 0
	beq $zero, $zero, check2
	
move_down:
	jal erase
	addi $a0, $a0, 16 		#redraw with row 1 pixel down
	addi $a2, $zero, BOX_COLOUR
	jal draw_bitmap_box
	addi $s1, $zero, 0
	beq $zero, $zero, check2
erase: 
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $a2, $zero, BOX_COLOUR_BLACK
	jal draw_bitmap_box
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra    		#goes back to pending keyboard interrupt 
	
	
	# Should never, *ever* arrive at this point
	# in the code.	

	addi $v0, $zero, 10

.data
    .eqv BOX_COLOUR_BLACK 0x00000000
.text

	addi $v0, $zero, BOX_COLOUR_BLACK
	syscall

# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

draw_bitmap_box:
#
# You can copy-and-paste some of your code from part (c)
# to provide the procedure body.
#	
	la $s0, 0x10010000
	
	mul $s2, $a0, 4 	#multiply row num by 4 
	mul $s3, $a1, 64 	#multiply column num by 64 
	add $s4, $s2, $s3 	#add products together to get the position of starting block 
	add $s0, $s0, $s4
	sw $a2, 0($s0)
	
	add $t5, $zero, $s0 	#this will be row starting pos 
	add $t6, $zero, $s0	#this will be column starting pos 

	li $t0, 3 		#preset count for row 
	li $t1, 4 		#preset count for column
	
row_loop:
	sw $a2, 0($t5)
	addi $t5, $t5, 4
	sw $a2, 0($t5)
	sub $t0, $t0, 1		#decrement count for row
	bne $t0, $zero, row_loop
next_column:
	addi $t6, $t6, 64 	#go to next column
	move $t5, $t6
	li $t0, 3		#reset count for row_loop
	sub $t1, $t1, 1		#decrement count for column
	bne $t1, $zero, row_loop 

	jr $ra

	.kdata

	.ktext 0x80000180
#
# You can copy-and-paste some of your code from part (a)
# to provide elements of the interrupt handler.
#
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
	sw $k1, 0($k0)	  		#set pending to 1
	
__exit_exception:
	eret


.data

# Any additional .text area "variables" that you need can
# be added in this spot. The assembler will ensure that whatever
# directives appear here will be placed in memory following the
# data items at the top of this file.

	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


.eqv BOX_COLOUR_WHITE 0x00FFFFFF
