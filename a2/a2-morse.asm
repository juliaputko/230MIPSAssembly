.text


main:	



# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	## Test code that calls procedure for part A
	#jal save_our_souls

	## morse_flash test for part B
	 #addi $a0, $zero, 0x42   # dot dot dash dot
	 #jal morse_flash
	
	## morse_flash test for part B
	# addi $a0, $zero, 0x37   # dash dash dash
	# jal morse_flash
		
	## morse_flash test for part B
	# addi $a0, $zero, 0x00  	# dot dash dot
	# jal morse_flash
			
	## morse_flash test for part B
	 #addi $a0, $zero, 0x11   # dash
	 #jal morse_flash	
	
	# flash_message test for part C
	# la $a0, test_buffer
	# jal flash_message
	
	# letter_to_code test for part D
	# the letter 'P' is properly encoded as 0x46.
	# addi $a0, $zero, 'P'
	 #jal letter_to_code
	
	# letter_to_code test for part D
	# the letter 'A' is properly encoded as 0x21
	 #addi $a0, $zero, 'A'
	 #jal letter_to_code
	
	# letter_to_code test for part D
	# the space' is properly encoded as 0xff
	# addi $a0, $zero, ' '
	# jal letter_to_code
	
	# encode_message test for part E
	# The outcome of the procedure is here
	# immediately used by flash_message
	 la $a0, message01
	 la $a1, buffer01
	 jal encode_message
	 la $a0, buffer01
	 jal flash_message
	#
	
	# Proper exit from the program.
	addi $v0, $zero, 10
	syscall

	
	
###########
# PROCEDURE
save_our_souls:
#dot dot dot dash dash dash dot dot dot
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra


# PROCEDURE
#	$a0 - the dot dash sequency
#	$t3 - copy of a0 
#	$t5 - length of the sequency 
#	$t6 - current bit to check 
#	$t7 - mask 
#	$t8 - load value 4
#	$t9 - shift amount for mask

#stack 
#--------
# $ra 4
# 

morse_flash:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	
	or $t3, $zero, $s0
	beq $t3, 0xff, space
	beq $t3, 0x00, space
	andi $t5, $t3, 0xF0 	#0b11110000 
	srl $t5, $t5, 4		#isolate length
	
	li $t8, 4
	sub $t9, $t8, $t5  	# 4-4 == 0, 4-3, ==1, shift amount for bit masking!
	li $t7, 0x8 		#1000 
	srlv $t7, $t7, $t9 	#shift accordingly: 1000, 100, 10, 1 
loop:
	 
	and $t6, $t3, $t7 	#and with mask 
	beq $t6, 1, dash
	beq $t6, 0, dot
dash:
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	srl $t7, $t7, 1  	#shift mask to the right
	addi $t5, $t5, -1  	#deincrement length 
	bne $t5, $zero, loop 	#if not 0, keep looping
	j end
dot:
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	srl $t7, $t7, 1  	#shift mask to the right
	addi $t5, $t5, -1
	bne, $t5, $zero, loop
	j end	
space:
	jal seven_segment_off
	jal delay_long
	jal seven_segment_off
	jal delay_long
	jal seven_segment_off
	jal delay_long
	
end: 
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	andi $t5, $t3, 0xF0 	#0b11110000 
	srl $t5, $t5, 4
	jr $ra  #this ra should go back to flash message procedure --> goes to ra after first call of flash message



###########
# PROCEDURE

flash_message:
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
go:	
	lbu $s0, 0($a0)   
	beq $s0, $zero, stop  
	jal morse_flash 
	addi $a0, $a0, 1
	j go
	
stop:

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	##############

	
	
	

	
	
###########
# PROCEDURE
#	$a0 - data memory address
#	$t1 - location of address of "codes"
#	$t3 - address of the current thing we are looking at
#	$t5 - 26 (number of letters in alphabet)
#	$t6 - length of our sequence 
#	$t7 - stored dot or dash or 0
#	$s0 - one byte equivalent of morse code of letter

# stack frame:
# +-------+
# | $ra   |0<-sp
letter_to_code:
	addi $sp, $sp, -4
	sw $ra, 0($sp) #load return address  
	
	#addi $a0, $zero, 'P'
	# jal letter_to_code
	li $s0, 0
	#li $t7, 0
	la $t1, codes 	#load address of codes into t1
	li $t5, 26 # cycle thorugh letters  
	li $t6, 0 #length of sequence 
	lbu $t3, 0($t1)   #store address  #the current thing in the string we are looking at is in t3
	beq $a0, 32, addspace #is it a space?
	beq $a0, $t3, foundit
	
	
nextletter: 
	lbu $t3, 0($t1)  
	beq $a0, $t3, foundit  #if we found the letter that matches
	beq $t5, $zero, endofsearch #if there are no more letters to look for 
	#bne $t3, $t4, nextletter  #if we still havnt found the letter we are looking for, look again '
	
	addi $t1, $t1, 8 #increment the addres 8 spaces, to look at next letter
	#addi $t4, $t4, 1 #next letter to compare our address to 
	addi $t5, $t5, -1
	j nextletter
	
#while memory address is the letter that we are looking for 
foundit: 	#found it 
	#if we do find the letter, go through that address and do things 
	addi $t1, $t1, 1 #add one to address
	#check if memory is not 0
	lbu $t3, 0($t1)   #store address 1 byte next (eg after the letter when the dashes and dots start 
	beq $t3, $zero, endofsearch
	sll $t7, $t7, 1	#shift to the left, making room for next
	bne $t3, 46, skip1 #'.' == 46
	jal dotstuff
skip1:
	bne $t3, 45, skip2 #'-' == 45
	jal dashstuff
skip2:
	j foundit 

addspace:
	addi $s0, $s0, 0xff
	j skip3
	
endofsearch:

	sll $t6, $t6, 4 #move it over  
	or $s0, $t7, $t6 #or them together to get the final result in $a2
skip3:
	lw $ra, 0($sp)
	addi $sp, $sp, 4 
	jr $ra	#call address to go back to start 
	
	
#stack frame
# +-------+
# | $ra   |0<-sp
dotstuff: 
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t6, $t6, 1 #add 1 to count 
	or $t7, $t7, 0 #store a dot 
	#sll $t7, $t7, 1 #shift to the left, making room for next 
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#stack frame
# +-------+
# | $ra   |0<-sp
dashstuff:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t6, $t6, 1  #increment a count by 1, indicating the length of the sequence 
	or $t7, $t7, 1 #add 1 indicating dash, 
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra 
	

###########
# PROCEDURE
# la $a0, message01
 #la $a1, buffer01
 #jal encode_message
# la $a0, buffer01    <-- jr ra back here 
# jal flash_message   <-- will do this, will jr ra back to this 

#stack frame
# +-------+
# | $ra   |4<-sp
# | $a0   |0<-sp

#	$a0 - word address
#	$a1 - buffer
#	$s0 - result of letter to code 
encode_message:

	addi $sp, $sp, -12
	sw $ra, 4($sp)
	sw $a0, 0($sp) #the word addresses make sure im restoring and incrmenting this 
	#save a1 as well 
	sw $a1, 8($sp)
	
	
	#message in $a0
	#buffer in $a1
	
	lbu $a0, 0($a0)

encodeloop:
	#the word addresses make sure im restoring and incrmenting this 
	beq $a0, 0, encodeskip #check if not 0
	jal letter_to_code
	sb $s0, 0($a1) #result of letter to code is in s0put into buffer
	lw $a0, 0($sp) #restore a0 
	addi $a0, $a0, 1 #increment word address
	sw $a0, 0($sp) #store it back in the stack after incrementing 
	addi $a1, $a1, 1 #increment buff
	lbu $a0, 0($a0) #load that byte into a0
	j encodeloop
	
encodeskip:
	lw $a1, 8($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 12
	jr $ra 


# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $ra

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $ra




#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "A A A"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128 
test_buffer:	.byte 0x30 0x37 0x30 0x00     # This is SOS
