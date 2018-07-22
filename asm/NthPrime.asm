#------- Data Segment ----------
.data
# Define the string messages and the primes array
mesg1:		.asciiz "Please enter an integer number(range: 1~100, enter 0 to end the program):"
mesg2:		.asciiz "-th prime is:"
mesg3: 		.asciiz "Sorry, input range should be 1~100.\n"
newline:	.asciiz "\n"

primes: 	.word 0:100
	
#------- Text Segment ----------
.text 
.globl main
main:
	# Put 2 as the 1st element in primes array
	addi	$t1, $zero, 2
	la	$t2, primes
	sw	$t1, 0($t2) 
	
ask_input:
	# Print starting message to ask input
	la 	$a0 mesg1						
	li 	$v0 4
	syscall					

	# $s0 stores the input integer
	li 	$v0, 5
	syscall	
	addi 	$s0, $v0, 0					

	# if input integer is 0, then end the program
	beq 	$s0, $zero, endmain
	
	# if input integer is larger than 100, then ask another input
	addi	$t1, $zero, 101
	slt 	$t2, $s0, $t1
	bne	$t2, $zero, start
	la 	$a0 mesg3						
	li 	$v0 4
	syscall	
	j	ask_input
		
start:	  
	# Otherwise, call nth_prime procedure to calculate n-th prime, $a0=n
	addi 	$a0, $s0, 0
	jal 	FindNthPrime	# FindNthPrime is what you should implement	  
	# $t0 stores the calculated n-th prime   
	addi 	$t0, $v0, 0  

	# Print result message and result of n-th prime
	addi 	$a0, $s0, 0
	li 	$v0, 1
	syscall	 
	la 	$a0, mesg2 
	li 	$v0, 4
	syscall				
	addi 	$a0, $t0, 0
	li 	$v0, 1
	syscall				
	la 	$a0, newline
	li 	$v0, 4
	syscall	

	# Another loop 
	j 	ask_input

# Terminate the program
endmain:
	li    	$v0, 10     	
	syscall 

# Implement function FindNthPrime
# What FindNthPrime should do: calculate n-th prime, $a0=n, return n-th prime in $v0	
FindNthPrime:
# TODO below 
        addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	# num - 1
	addi    $t0, $a0, -1
	# t5 = num
	addi    $t5, $a0, 0
	sll     $t1, $t0, 2
	la	$t2, primes
	add     $t3, $t2, $t1
	lw	$t1, 0($t3)
	bnez    $t1, found
	# not found
	# start from the 2nd
	#addi    $t0, $zero, 0
	# find the last prime
	addi    $t0, $zero, 0
	
	loop_search:
	sll     $t1, $t0, 2
	add     $t3, $t2, $t1
	lw	$t1, 0($t3)
	bnez    $t1, none_zero
	# zero 
	add     $t1, $t4, 0
	loop_search_prime:
	add     $t1, $t1, 1
	addi    $a0, $t1, 0
	jal     is_prime
	beqz    $v0, loop_search_prime
	# save into prime
	
	sw      $t1, 0($t3)
	
	none_zero:
	addi    $t4, $t1, 0
	addi    $t0, $t0, 1
	blt     $t0, $t5, loop_search
	found:
	addi $v0, $t1, 0
	
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

			
						
												
# TODO above


# Implement function is_prime, which would be used in FindNthPrime function
# What is_prime should do: Given a value in $a0, check whether it is a prime
# if $a0 is prime, then return $v0=1, otherwise, return $v0=0
is_prime:
# TODO below
        addi	$sp, $sp, -4
	sw	$ra, 0($sp)
       	addi	$t7, $zero, 2
       	
       	# int half_i = (int)(i/2)+1;
       	div $t8, $a0, $t7
       	addi $t8, $t8, 1
       	
       	addi $a1, $a0, 0
       	# rtn
       	add $t9, $zero, 0
       	loop:
       	addi $a2, $t7, 0
       	jal Remainder
       	beqz $v1, no_prime
       	addi $t7, $t7, 1
       	blt $t7, $t8, loop
       	
       	add $t9, $zero, 1
       	no_prime:
       	addi $v0, $t9, 0
       	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
       	
	
	
# TODO above



# Given value in $a1 and $a2, this function calculate the remainder of $a1 / $a2
# return remainder($a1 % $a2) in $v1  
Remainder: 
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	div	$a1, $a2
	mfhi	$v1
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
