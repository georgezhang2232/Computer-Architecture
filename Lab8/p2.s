.text

##struct Puzzle {
##    int NUM_ROWS;
##    int NUM_COLS;
##    char** board;
##};
##
##
##char floodfill (Puzzle* puzzle, char marker, int row, int col) {
##    if (row < 0 || col < 0) {
##        return marker;
##    }
##
##    if (row >= puzzle->NUM_ROWS || col >= puzzle->NUM_COLS) {
##        return marker;
##    }
##
##    char ** board = puzzle->board;
##    
##    if (board[row][col] != '#') {
##        return marker;
##    }
##
##    board[row][col] = marker;
##
##    floodfill(puzzle, marker, row + 1, col + 1);
##    floodfill(puzzle, marker, row + 1, col + 0);
##    floodfill(puzzle, marker, row + 1, col - 1);
##
##    floodfill(puzzle, marker, row, col + 1);
##    floodfill(puzzle, marker, row, col - 1);
##
##    floodfill(puzzle, marker, row - 1, col + 1);
##    floodfill(puzzle, marker, row - 1, col + 0);
##    floodfill(puzzle, marker, row - 1, col - 1);
##
##    return marker + 1;
##}

.globl floodfill
floodfill:
	sub $sp, $sp, 12
	sw $ra, 0($sp)
	sw $a2, 4($sp)
	sw $a3, 8($sp)		#sw
	blt $a2, 0, mark	
	blt $a3, 0, mark 	#if1

	lw $t0, 0($a0)
	lw $t1, 4($a0)
	bge $a2, $t0, mark	
	bge $a3, $t1, mark	#if2
	
	lw  $t0, 8($a0)
	mul $t1, $a2, 4
	add $t2, $t1, $t0
	lw  $t3, 0($t2)
	add $t3, $t3, $a3
	lb  $t4, 0($t3)
	li  $t5, '#'
	bne $t4, $t5, mark
	
	sb  $a1, 0($t3)		#board[row][col] = marker

	sw $a2, 4($sp)
	sw $a3, 8($sp)
	add $a2, $a2, 1
	add $a3, $a3, 1
	jal floodfill
	lw $a2, 4($sp)
	lw $a3, 8($sp)

	sw $a2, 4($sp)
	sw $a3, 8($sp)
	add $a2, $a2, 1
	jal floodfill
	lw $a2, 4($sp)
	lw $a3, 8($sp)

	sw $a2, 4($sp)
	sw $a3, 8($sp)
	add $a2, $a2, 1
	sub $a3, $a3, 1
	jal floodfill
	lw $a2, 4($sp)
	lw $a3, 8($sp)

	sw $a2, 4($sp)
	sw $a3, 8($sp)
	add $a3, $a3, 1
	jal floodfill
	lw $a2, 4($sp)
	lw $a3, 8($sp)
	
	sw $a2, 4($sp)
	sw $a3, 8($sp)
	sub $a3, $a3, 1
	jal floodfill
	lw $a2, 4($sp)
	lw $a3, 8($sp)
	
	sw $a2, 4($sp)
	sw $a3, 8($sp)
	sub $a2, $a2, 1
	add $a3, $a3, 1
	jal floodfill
	lw $a2, 4($sp)
	lw $a3, 8($sp)
	
	sw $a2, 4($sp)
	sw $a3, 8($sp)
	sub $a2, $a2, 1
	jal floodfill
	lw $a2, 4($sp)
	lw $a3, 8($sp)
	
	sw $a2, 4($sp)
	sw $a3, 8($sp)
	sub $a2, $a2, 1
	sub $a3, $a3, 1
	jal floodfill
	lw $a2, 4($sp)
	lw $a3, 8($sp)
	
	move $v0, $a1
	add $v0, $v0,1
	j end

mark:	move $v0, $a1
	j end

end:	lw $ra, 0($sp)
	lw $a2, 4($sp)
	lw $a3, 8($sp)
	add $sp, $sp, 12
	jr	$ra


	
	
	
	
##void 
##floyd_warshall (int graph[6][6], int shortest_distance[6][6]) { 
##    for (int i = 0; i < 6; ++i) {
##        for (int j = 0; j < 6; ++j) {
##			if (i == j) {
##				shortest_distance[i][j] = 0;
##			} else {
##				shortest_distance[i][j] = graph[i][j]; 
##			}
##		}
##	}
##    for (int k = 0; k < 6; k++) {
##        for (int i = 0; i < 6; i++) {
##            for (int j = 0; j < 6; j++) {
##				if (shortest_distance[i][k] + shortest_distance[k][j] < shortest_distance[i][j]) {
##					shortest_distance[i][j] = shortest_distance[i][k] + shortest_distance[k][j]; 
##				}
##            } 
##        } 
##    } 
##}

.globl floyd_warshall
floyd_warshall:
	li $t0, 0	#i = 0
loopi:	bge $t0, 6, endi
	li $t1, 0	#j = 0
loopj:	bge $t1, 6, endj

	bne $t0, $t1, else
	mul $t3, $t0, 24
	mul $t4, $t1, 4
	add $t4, $t3, $t4
	add $t4, $a1, $t4	#$t4 = shortest_distance[i][j]
	sw $zero, 0($t4)
	j nextloop

else:	mul $t3, $t0, 24
	mul $t4, $t1, 4
	add $t4, $t4, $t3
	add $t4, $a1, $t4	#$t4 = shortest_distance[i][j]

	mul $t5, $t0, 24
	mul $t6, $t1, 4
	add $t6, $t6, $t5
	add $t6, $a0, $t6	#$t6 = graph[i][j]

	lw $t7, 0($t6)
	sw $t7, 0($t4)

nextloop: add $t1, $t1, 1
	  j loopj

endj:	  add $t0, $t0, 1
	  j loopi
													
endi:				#second forloop
	li $t0, 0		#k = 0
loop1:	bge $t0, 6, done
	li $t1, 0		#i = 0
loop2:	bge $t1, 6, end1
	li $t2, 0		#j = 0
loop3:	bge $t2, 6, end2

	mul $t3, $t1, 24
	mul $t4, $t0, 4
	add $t3, $t3, $t4
	add $t3, $a1, $t3
	lw  $t3, 0($t3)		#[i][k]

	mul $t4, $t0, 24
	mul $t5, $t2, 4
	add $t4, $t5, $t4
	add $t4, $a1, $t4
	lw  $t4, 0($t4)		#[k][j]

	mul $t5, $t1, 24
	mul $t6, $t2, 4
	add $t5, $t5, $t6
	add $t5, $a1, $t5
	lw  $t7, 0($t5)		#[i][j]
	
	add $t6, $t3, $t4	#[i][k] + [k][j]
	bge $t6, $t7, nextloop2
	sw  $t6, 0($t5)		#[i][j] = [i][k] + [k][j]

nextloop2: add $t2, $t2, 1
	   j loop3

end2:	add $t1, $t1, 1
	j loop2

end1:	add $t0, $t0, 1
	j loop1	
done:	jr $ra
