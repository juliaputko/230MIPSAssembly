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

#	$a0: holds the row # of the upper left corner of the box
#	$a1: holds the colums # of the upper left corner of the box 
#	$a2: holds the colour of the box
#	return value: none 	

#take the parameters and draw a four by four pixel box where the row/column
#location of the upper-left hand corner of the upper-left hand corner of that box is given as the first two paramteters 

 #assume row 0, column 0 is the upper left corner 
 #roq 15, column 15 is the lower right corner of the complete display  


	.include "bitmap-routines.asm" 
	#bitmap 

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
	
	.globl main
	.text	
main:
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0x00ff0000
	jal draw_bitmap_box
	
	addi $a0, $zero, 11
	addi $a1, $zero, 6
	addi $a2, $zero, 0x00ffff00
	jal draw_bitmap_box
	
	addi $a0, $zero, 8
	addi $a1, $zero, 8
	addi $a2, $zero, 0x0099ff33
	jal draw_bitmap_box
	
	addi $a0, $zero, 2
	addi $a1, $zero, 3
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box

	addi $v0, $zero, 10
	syscall
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box


draw_bitmap_box:

	

	#get a0 value, colour in that spot and 3 to the right 
	#get a1 value, colour in that spot and 3 down 
		#for every colun, colour in 3 to right 
		#column value starting at row, colour in 3 to
#	- - - -
#	-     -
#	-     -
#	- - - -	
	la $s0, 0x10010000
	
	mul $s2, $a0, 4 	#multiply row num by 4 
	mul $s3, $a1, 64 	#multiply column num by 64 
	add $s4, $s2, $s3 	#add products together to get the position of starting block 
	add $s0, $s0, $s4  
	#add      
	sw $a2, 0($s0)
	
	add $t5, $zero, $s0   #this will be row starting pos 
	add $t6, $zero, $s0   #this will be column starting pos 

	li $t0, 3 #count for row 
	li $t1, 4 #count for column
	

row_loop:
	sw $a2, 0($t5)
	addi $t5, $t5, 4
	sw $a2, 0($t5)
	sub $t0, $t0, 1
	bne $t0, $zero, row_loop
next_column:
	addi $t6, $t6, 64
	move $t5, $t6
	li $t0, 3
	sub $t1, $t1, 1
	bne $t1, $zero, row_loop 

	jr $ra

	addi $v0, $zero, 10
	syscall
	#jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
