.text

##int 
##dfs(int target, int i, int* tree) {
##	if (i >= 127) {
##		return -1;
##	}
##	if (target == tree[i]) {
##		return 0;
##	}
##
##	int ret = dfs(target, 2 * i, tree);
##	if (ret >= 0) {
##		return ret + 1;
##	}
##	ret = dfs(target, 2 * i + 1, tree);
##	if (ret >= 0) {
##		return ret + 1;
##	}
##	return ret;
##}

.globl dfs
dfs:
	sub $sp, $sp, 8
	sw $ra, 0($sp)			#sw ra
	sw $s0, 4($sp)
	move $s0, $a1
	li $v0, -1
	bge $s0, 127, done 		#out of bound
	
	mul $s1, $s0, 4			#$s1 = i
	add $s1, $a2, $s1 		#$s1 = tree[i]
	lw  $s1, 0($s1)
	li $v0, 0
	beq $a0, $s1, done		#found

	mul $a1, $s0, 2			#2 * i
	jal dfs				
	move $s3, $v0			#ret	
	add $v0, $v0,1
	bge $s3, 0, done		#left child

	mul $a1, $s0, 2
	add $a1, $a1, 1			#2 * 1 + 1
	jal dfs				
	move $s4, $v0;			#ret
	add $v0, $v0,1
	bge $s4, 0, done		#left child
	sub $v0, $v0, 1

done:	lw $ra, 0($sp)
	lw $s0, 4($sp)
	add $sp, $sp, 8
	jr $ra
