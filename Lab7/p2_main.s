.data

# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11

request: .word 11 1 10 2 31 3 19 4 7 5 0 6 6 7 12 8 12 9 10 10 9 11 1

kitchen: 
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 6
.word 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0
.word 0 0 0 0 0 0 0 0 0 0 5 0 0 0 0
.word 0 11 0 0 0 0 0 0 0 0 0 0 0 0 0
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.word 0 0 0 10 0 0 0 0 0 0 0 0 0 0 0
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.word 0 0 0 0 0 0 0 0 0 0 9 0 0 0 0
.word 0 0 0 0 4 0 0 0 0 0 0 0 0 0 7
.word 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
.word 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
.word 0 2 0 0 0 0 0 0 0 0 0 0 0 0 0

starting_point: .word 7 7

.text

# print int and space ##################################################
#
# argument $a0: number to print

print_int_and_space:
	li	$v0, PRINT_INT	# load the syscall option for printing ints
	syscall			# print the number

	li   	$a0, ' '       	# print a black space
	li	$v0, PRINT_CHAR	# load the syscall option for printing chars
	syscall			# print the char
	
	jr	$ra		# return to the calling procedure

# main function ########################################################
#
#  this is a function that will test board_done and print_board
#

.globl main
main:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)		# save $ra on stack


	la	$a0, request		# test bubble_sort
	la	$a1, compare_ingredients
	jal	bubble_sort
	
	la		$a0, request
	lw		$a0, 4($a0)
	jal	print_int_and_space	# this should print 5
	

	la		$a0, request
	lw		$a0, 28($a0)
	jal	print_int_and_space	# this should print 4
	
	la		$a0, request
	lw		$a0, 60($a0)
	jal	print_int_and_space	# this should print 8
	
	la		$a0, request
	lw		$a0, 84($a0)
	jal	print_int_and_space	# this should print 2


	li	$v0, PRINT_CHAR		# print a newline
	li	$a0, '\n'
	syscall	


	la	$a0, kitchen		# test euclidean_squared
	la	$a1, starting_point
	li	$a2, 11
	jal	euclidean_squared 
	move $a0, $v0
	jal	print_int_and_space	# this should print 52

	la	$a0, kitchen		# test euclidean_squared
	la	$a1, starting_point
	li	$a2, 6
	jal	euclidean_squared 
	move $a0, $v0
	jal	print_int_and_space	# this should print 98

	la	$a0, kitchen		# test euclidean_squared
	la	$a1, starting_point
	li	$a2, 9
	jal	euclidean_squared 
	move $a0, $v0
	jal	print_int_and_space	# this should print 9

	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
