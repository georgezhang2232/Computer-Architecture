# syscall constants
.data
PRINT_INT = 1
PRINT_STRING = 4
PRINT_CHAR = 11
.globl newline
newline:    .asciiz "\n"      # useful for printing commands
.globl symbollist
symbollist: .ascii  "_#ABCDEFGHIJKLMNOPQRSTUVWXYZ"
.data 0x10010100
line1:
.asciiz "____#_##_#__##__"
.data 0x10010200
line2:
.asciiz "#__#___#___####_"
.data 0x10010300
line3:
.asciiz "##___###_##_#__#"
.data 0x10010400
line4:
.asciiz "_____##__###____"
.data 0x10010500
line5:
.asciiz "#_###_##__##_#__"
.data 0x10010600
line6:
.asciiz "#__#_####_____##"
.data 0x10010700
line7:
.asciiz "##______##____##"
.data 0x10010800
line8:
.asciiz "##_###______##__"
.data 0x10010900
line9:
.asciiz "#__##_#_###__##_"
.data 0x10011000
line10:
.asciiz "__###__##__#_#_#"
.data 0x10011100
line11:
.asciiz "_#_#___#_##_#_##"
.data 0x10011200
line12:
.asciiz "#___##_###______"
.data 0x10011300
line13:
.asciiz "##__##__##__#_##"
.data 0x10011400
line14:
.asciiz "_#__##_#___####_"
.data 0x10011500
line15:
.asciiz "__##_###_####_##"
.data 0x10011600
line16:
.asciiz "_#_##____#_#__##"
.align 4
board:
.word 0x10010100 0x10010200 0x10010300 0x10010400 0x10010500 0x10010600 0x10010700 0x10010800 
.word 0x10010900 0x10011000 0x10011100 0x10011200 0x10011300 0x10011400 0x10011500 0x10011600
puzzle:
.word 16 16 board
transition_matrix:
.word 0 8 8 9999 3 3
.word 9999 0 7 3 1 9999
.word 1 9999 0 3 10 7
.word 3 10 2 0 9999 9999
.word 1 9999 4 8 0 7
.word 9999 4 7 9999 1 0
shortest_distances:
.word 0 0 0 0 0 0
.word 0 0 0 0 0 0
.word 0 0 0 0 0 0
.word 0 0 0 0 0 0
.word 0 0 0 0 0 0
.word 0 0 0 0 0 0
.text
# print board ##################################################
#
# argument $a0: board to print
.globl print_board
print_board:
    sub $sp, $sp, 20
    sw  $ra, 0($sp)     # save $ra and free up 4 $s registers for
    sw  $s0, 4($sp)     # i
    sw  $s1, 8($sp)     # j
    sw  $s2, 12($sp)        # the address
    sw  $s3, 16($sp)        # the line number
    move    $s2, $a0
    li  $s0, 0          # i
pb_loop1:
    li  $s1, 0          # j
pb_loop2:
    mul $t0, $s0, 4     # i*4
    add $t0, $t0, $s2
    lw  $s3, 0($t0)     #Get correct line address
    add $t1, $s3, $s1   #Get correct byte   
    lb  $a0, 0($t1)     # num = &board[i][j]
    li  $v0, 11
    syscall
    j   pb_cont
pb_cont:    
    add $s1, $s1, 1     # j++
    blt $s1, 16, pb_loop2
    li  $v0, 11         # at the end of a line, print a newline char.
    li  $a0, '\n'
    syscall 
    
    add $s0, $s0, 1     # i++
    blt $s0, 16, pb_loop1
    lw  $ra, 0($sp)     # restore registers and return
    lw  $s0, 4($sp)
    lw  $s1, 8($sp)
    lw  $s2, 12($sp)
    lw  $s3, 16($sp)
    add $sp, $sp, 20
    jr  $ra
# print int and space ##################################################
#
# argument $a0: number to print
print_int_and_space:
    li  $v0, PRINT_INT  # load the syscall option for printing ints
    syscall         # print the number
    li      $a0, 32         # print a black space (ASCII 32)
    li  $v0, PRINT_CHAR # load the syscall option for printing chars
    syscall         # print the char
    
    jr  $ra     # return to the calling procedure
# print newline ########################################################
#
# no arguments
print_newline:
    li  $v0, 4          # at the end of a line, print a newline char.
    la  $a0, newline
    syscall 
    jr  $ra
# main function ########################################################
.globl main
main:
    sub $sp, $sp, 4
    sw  $ra, 0($sp) # save $ra on stack

    la  $a0, puzzle  
    li  $s0, 0      # col counter
    li  $v0, 'A'
    lw  $s1, 0($a0) # NUM_ROWS
    lw  $s2, 4($a0) # NUM_COLS
outer_loop:
    bge $s0, $s1, end_outer

    li  $s3, 0      # row counter
inner_loop:
    bge $s3, $s2, end_inner
    la  $a0, puzzle  
    move    $a1, $v0
    move    $a2, $s0
    move    $a3, $s3
    jal floodfill           # Test floodfill


    add $s3, $s3, 1
    j   inner_loop
end_inner:
    add $s0, $s0, 1
    j   outer_loop
end_outer:


    la  $a0, board     
    jal print_board         # all "#" should be removed
    
    jal     print_newline
    la $a0, transition_matrix
    la $a1, shortest_distances
    jal floyd_warshall      # Test Floyd-Warshall
#   This is what your output should look like
#    0 7 7 10 3 3 
#    2 0 5 3 1 5 
#    1 8 0 3 4 4 
#    3 10 2 0 6 6 
#    1 8 4 7 0 4 
#    2 4 5 7 1 0 
    
    la $t2, shortest_distances
    li $t0, 0       #i = 0
test_loop_i:
    bge $t0, 6, test_end
    li $t1, 0       #j = 0
test_loop_j:
    bge $t1, 6, test_iterate_i
    mul $t3, $t0, 24
    mul $t4, $t1, 4
    add $a0, $t3, $t4
    add $a0, $a0, $t2
    lw $a0, 0($a0)
    jal print_int_and_space
    add $t1, $t1, 1
    j test_loop_j
test_iterate_i:
    jal     print_newline
    add $t0, $t0, 1
    j test_loop_i
test_end:
    lw  $ra, 0($sp)
    add $sp, $sp, 4
    jr  $ra