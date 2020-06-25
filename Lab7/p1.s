.text

##// Sets the values of the array to the corresponding values in the request
##void decode_request(unsigned long int request, int* array) { 
##  // The hi and lo values are already given to you, so you don't have to
##  // perform these shifting operations. They are included so that this
##  // code functions in C. The lo value is $a0 and the hi value is $a1.
##  unsigned lo = (unsigned)((request << 32) >> 32);
##  unsigned hi = (unsigned)(request >> 32);
##
##  for (int i = 0; i < 6; ++i) {
##    array[i] = lo & 0x0000001f;
##    lo = lo >> 5;
##  }
##  unsigned upper_three_bits = (hi << 2) & 0x0000001f;
##  array[6] = upper_three_bits | lo;
##  hi = hi >> 3;
##  for (int i = 7; i < 11; ++i) {
##    array[i] = hi & 0x0000001f;
##    hi = hi >> 5;
##  }
##}

.globl decode_request
decode_request:

	li $t0, 0 
 loop : bge $t0, 6, next	#if i >= 6 jump
	mul $t1, $t0, 4	
	add $t1, $a2, $t1	#array[i]
	and $t2, $a0, 0x1f	#lo & 0x0000001f
	sw $t2, 0($t1)		#store
	srl $a0, $a0, 5		#lo = lo >> 5
	add $t0, $t0,1
	j loop			#forloop

  next: sll $t0, $a1, 2		#hi << 2
	and $t0, $t0, 0x1f
	or $t0, $t0, $a0	#lo & 0x0000001f
	sw $t0, 24($a2)		#store 
	srl $a1, $a1, 3		#hi = hi >> 3
	
	li $t0, 7
loop2 : bge $t0, 11, end
	mul $t1, $t0, 4
	add $t1, $t1, $a2
	and $t2, $a1, 0x1f
	sw $t2, 0($t1)
	srl $a1, $a1, 5
	addi $t0, $t0,1
	j loop2
end:    jr	$ra
