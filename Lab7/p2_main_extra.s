.data

# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11

arr:
.word 5 28 0 12 24 9 2 31 14 8 14

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
#  this will test decode_request
#

.globl main
main:
	sub	$sp, $sp, 4
	sw	$ra, 0($sp)		# save $ra on stack
	
	
	la      $a0, arr		# test create_request
	jal     create_request
	
	move	$a0, $v0
	jal	print_int_and_space	# this should print 327549829
	
	move	$a0, $v1
	jal	print_int_and_space	# this should print 3739384

	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
