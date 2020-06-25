.text 

##struct Ingredient {
##  unsigned ing_type;
##  unsigned amount;
##};
##
##struct Request {
##  unsigned length;
##  Ingredient ingredients [11];
##};
##
##//Performs a bubble sort on the given request using the given comparison function
##void bubble_sort(Request* request, int (*cmp_func) (Ingredient*, Ingredient*)) {
##    for (int i = 0; i < request->length; ++i) {
##        for (int j = 0; j < request->length - i - 1; ++j) {
##            if (cmp_func(&request->ingredients[j], &request->ingredients[j + 1]) > 0) {
##                Ingredient temp = request->ingredients[j];
##                request->ingredients[j] = request->ingredients[j + 1];
##                request->ingredients[j + 1] = temp;
##            }
##        }
##    }
##}

.globl bubble_sort
bubble_sort:
 	li $t0, 0 # i = 0 
 	sub $sp,$sp, 20
 	sw $ra, 0($sp) 
 	lw $t2, 0($a0) 		#request->length 
loop_1: 
	li $t1 ,0 # j = 0 
 	bge $t0, $t2,end 	#first loop 
	add $t3, $t0, 1 	#i+1 
 	sub $t3, $t2, $t3 	# length -(i+1) 
loop_2: 
 	bge $t1, $t3, break_ 	#second loop 
 	mul $t4, $t1, 8 
 	add $t4, $t4, 4 
 	add $t4, $a0, $t4 	#request->ingredients[j] 
 	add $t5, $t4, 8 	#request->ingredients[j+1] 
 	sw $a0, 4($sp) 		
 	sw $a1, 8($sp) 		
   	lw $s1, 8($sp) 
 	move $a0, $t4		#change a0
 	move $a1, $t5		#change a1
   	sw $t0, 12($sp) 
	sw $t1, 16($sp) 
 	jalr $s1 		#camp_func 
 	move $t6, $v0 
 	lw $a0, 4($sp) 
 	lw $a1, 8($sp) 
 	lw $t0, 12($sp) 
 	lw $t1, 16($sp)

 	ble $t6, $zero, none_ 
 	lw $t6, 0($t4) 		#exchange value
 	lw $t7, 4($t4) 
 	lw $t8, 0($t5) 
 	lw $t9, 4($t5) 
 	sw $t8, 0($t4) 
 	sw $t9, 4($t4) 
 	sw $t6, 0($t5) 
 	sw $t7, 4($t5) 
	add $t1, $t1, 1 	#loop back
 	jr loop_2 

none_: 	add $t1, $t1, 1 
 	jr loop_2 
break_: add $t0, $t0, 1 
 	jr loop_1 
end: 	lw $ra, 0($sp) 
 	add $sp, $sp, 20 
 	jr $ra 

	
	
##int compare_ingredients(Ingredient* ingredient1, Ingredient* ingredient2) {
##    if (ingredient1->amount > ingredient2->amount) {
##        return 1;
##    } else {
##        return 0;   
##    }
##}

.globl compare_ingredients
compare_ingredients:
	lw $t0, 4($a0)
	lw $t1, 4($a1)
	bgt $t0, $t1, go
	li $v0, 0
	jr $ra
go: 	li $v0, 1
	jr $ra
	
	
##//Computes the euclidean squared distance between the given starting_coordinates
##//and the index of the kitchen array that contains the given ingredient
##int euclidean_squared(unsigned kitchen[15][15], 
##                      int starting_coordinates[2], unsigned ingredient) {
##  for (int i = 0 ; i < 15 ; ++ i) {
##    for (int j = 0 ; j < 15 ; ++ j) {
##      if (kitchen[i][j] == ingredient) {
##        return ((i - starting_coordinates[0]) * (i - starting_coordinates[0]) + 
##                (j - starting_coordinates[1]) * (j - starting_coordinates[1]));
##      }
##    }
##  }
##  return -1;
##}

.globl euclidean_squared
euclidean_squared:
	li $t2, 0 	#i = 0
	lw $t0, 0($a1) 	#starting_coordinates[0]
	lw $t1, 4($a1) 	#starting_coordinates[1]

loop1:
	bge $t2, 15, end2
	li $t3, 0 	#j = 0

loop2:
	bge $t3, 15, break2
	mul $t5, $t2, 15
	add $t5, $t5, $t3
	mul $t5, $t5, 4
	add $t6, $a0, $t5
	lw $t6, 0($t6)

	bne $t6, $a2, else
	sub $t7, $t2, $t0
	mul $t7, $t7, $t7  #(i - starting_coordinates[0]) * (i - starting_coordinates[0])
	sub $t8, $t3, $t1
	mul $t8, $t8, $t8  #(j - starting_coordinates[1]) * (j - starting_coordinates[1])
	add $v0, $t7, $t8
	jr $ra

else:
	add $t3, $t3, 1
	jr loop2

break2:
	add $t2, $t2, 1
	j loop1

end2:
	li $v0, -1
	jr $ra
