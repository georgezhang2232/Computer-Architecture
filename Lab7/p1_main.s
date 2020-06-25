.data

# syscall constants
PRINT_INT = 1
PRINT_CHAR = 11

request_array: .word 0:11

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
	
	
	li	$a0, 0x57046d73		# test decode_request
	li  $a1, 0xe19c115c
	la  $a2, request_array
	jal	decode_request
	
	la  $t0, request_array
	lw	$a0, 0($t0)
	jal	print_int_and_space	# this should print 19
	lw	$a0, 36($t0)
	jal	print_int_and_space	# this should print 0
	lw	$a0, 24($t0)
	jal	print_int_and_space	# this should print 17


	li	$a0, 0x655cebe7		# test decode_request
	li  $a1, 0x7d2bd965
	la  $a2, request_array
	jal	decode_request
	
	la  $t0, request_array
	lw	$a0, 0($t0)
	jal	print_int_and_space	# this should print 7
	lw	$a0, 36($t0)
	jal	print_int_and_space	# this should print 30
	lw	$a0, 24($t0)
	jal	print_int_and_space	# this should print 21


	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
