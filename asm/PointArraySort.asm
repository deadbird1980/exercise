#------- Data Segment ----------
.data
# Define the string messages and the array
msg1:           .asciiz "The original list of random points are "
msg2:		.asciiz "\nThe ascending sorted point array are  "
space:		.asciiz " "
newline:	.asciiz "\n" 
leftbracket:	.asciiz "("
rightbracket: 	.asciiz ")"

#                      x  y
# point:  	.word 20 20

#                       x_1 y_1 x_2 y_2 x_3 y_3 x_4 y_4  x_5 y_5  x_6 y_6  x_7 y_7 x_8 y_8  x_9 y_9 x_10  y_10
# point_array:   .word   20  3  35  173  0  68   0   0   650 456  124 124  16  45  23  14   16  15   20    1
point_array:    .word 0:20

#------- Text Segment ----------
.text
.globl main
main:

	# $s1 is the array size
	addi 	$s1,$zero,20

	# set random seed
	li 	$v0, 30
	syscall            
	addi 	$a1, $a0, 0
	li 	$a0, 0
	li 	$v0, 40
	syscall

	# load the starting address of the pointarray to $s0
	la 	$s0, point_array
	addi 	$t0, $zero, 0
	
# fill the array with $s1 random elements within range [1, 100]
array_filling:	
	jal 	random_number_generate	
	sll 	$t1, $t0, 2
	add 	$t1, $s0, $t1
	sw 	$v1, 0($t1)
	addi	$t0, $t0, 1 
	bne 	$t0, $s1, array_filling
	
	# Print the original array
 	jal 	printoriginal
	
	# Sort array	
	jal 	sortarray	# sortarry function is what you should implement
	
	# Print the sorted array
	jal 	printresult
 	
	# Terminate the program
	li 	$v0, 10 
	syscall

# Implement sortarray function 
# What sortarray should do: Sort the point_array
# $s1 stores the array size
# $s0 stores the starting address of the point_array
sortarray:
	# t0 = i t1 = j
	addi 	$t0, $zero, 0
	# t2 = n - 2
	addi $t2, $s1, -2
	loop1:
	# j = 0
	addi 	$t1, $zero, 0
	# t3 = n - i - 2
	sub 	$t3, $t2, $t0
	loop2:
	sll 	$t4, $t1, 2
	add 	$t4, $s0, $t4
	# j
	lw  	$t5, 0($t4)
	# j + 2
	lw  	$t6, 8($t4)
	blt     $t6, $t5, swap
	bgt     $t6, $t5, noswap
	# j
	lw  	$t5, 4($t4)
	# j + 2
	lw  	$t6, 12($t4)
	blt     $t6, $t5, swap
	j 	noswap
	swap:
	# 0 <-> 2
	lw  	$t5, 0($t4)
	lw  	$t6, 8($t4)
	sw      $t5, 8($t4)
	sw      $t6, 0($t4)
	# 1 <-> 3
	lw  	$t5, 4($t4)
	lw  	$t6, 12($t4)
	sw      $t5, 12($t4)
	sw      $t6, 4($t4)
	
	noswap:
	addi 	$t1, $t1, 2
	blt 	$t1, $t3, loop2
	# i = i + 2
	addi 	$t0, $t0, 2
	blt 	$t0, $t2, loop1
	jr 	$ra
								
															
# TODO above

# print original array
printoriginal:
	addi 	$sp, $sp, -4
	sw 	$ra, 0($sp)
	
	la 	$a0, msg1
	li 	$v0, 4
	syscall
	
        jal 	printmain
        
        lw 	$ra, 0($sp)
        addi 	$sp, $sp, 4
        jr 	$ra
        
         
#print the sorted array
printresult:
	addi 	$sp, $sp, -4
	sw 	$ra, 0($sp)

	la 	$a0, msg2
	li 	$v0, 4
	syscall
	
        jal 	printmain
        
        lw 	$ra, 0($sp)
        addi 	$sp, $sp, 4
        jr 	$ra

# print array     
printmain:
	addi 	$sp, $sp, -4
	sw 	$ra, 0($sp)

	#Print a new line
	la 	$a0, newline
	li 	$v0, 4
	syscall
	
        addi	$t1, $zero, 0  			#$t1 is the index for printing sorted A[i]
        
printloop:
        slt  	$t0, $t1, $s1     		#check to see if $t1 (i) is still within the correct range 
        
        beq  	$t0, $zero, endprintloop 	#if i>=20 end print numbers
        
        addi	$t2, $zero, 2
        div	$t1, $t2					
	mfhi	$t3
	bne	$t3, $zero, printY	
	
	printX:
	la 	$a0, leftbracket
	li 	$v0, 4
	syscall
	
	sll  	$t2, $t1, 2       		#$t1*4 to get the byte offset
	add  	$t3, $s0, $t2     		#base+byte offset to get address of A[i]
	lw   	$a0, 0($t3)
	li   	$v0, 1
	syscall
	j 	printSpace
	
	printY:
	sll  	$t2, $t1, 2       		#$t1*4 to get the byte offset
	add  	$t3, $s0, $t2    		#base+byte offset to get address of A[i]
	lw   	$a0, 0($t3)
	li   	$v0, 1
	syscall
	
	la 	$a0, rightbracket
	li 	$v0, 4
	syscall
	
	#Print a space to separate the numbers
	printSpace:
	la 	$a0, space
	li 	$v0, 4
	syscall
	
	#i=i+1 and start another iteration of the loop	
	addi 	$t1,$t1,1      
	j 	printloop

endprintloop:	
#Print a new line
	la 	$a0, newline
	li 	$v0, 4
	syscall
	lw 	$ra, 0($sp)
        addi 	$sp, $sp, 4
        jr 	$ra

#no input paramter
#output result in $v0
random_number_generate:
	addi  	$sp, $sp, -8
	sw    	$ra, 0($sp)
	sw    	$a0, 4($sp)
	
	addi 	$a1, $zero, 100  #set upper bound to be 100	
	li 	$a0, 0
	li 	$v0, 42
	syscall
	
	addi 	$v1, $a0, 1	
	
	lw 	$a0, 4($sp)
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, 8
	jr 	$ra		


