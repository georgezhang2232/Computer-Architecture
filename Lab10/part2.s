.data
Flag: .space 4
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

SUBMIT_ORDER 		= 0xffff00b0
DROPOFF 		= 0xffff00c0
PICKUP 			= 0xffff00e0
GET_TILE_INFO		= 0xffff0050
SET_TILE		= 0xffff0058

REQUEST_PUZZLE          = 0xffff00d0
SUBMIT_SOLUTION         = 0xffff00d4

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000
TIMER_ACK               = 0xffff006c

REQUEST_PUZZLE_INT_MASK = 0x800
REQUEST_PUZZLE_ACK      = 0xffff00d8

GET_MONEY               = 0xffff00e4
GET_LAYOUT 		= 0xffff00ec
SET_REQUEST 		= 0xffff00f0
GET_REQUEST 		= 0xffff00f4
.align 4
SPACE: .word 0:511
solution: .word 4


.text
main:





	# Construct interrupt mask
	li      $t4, 0
	or      $t4, $t4, BONK_INT_MASK # request bonk
	or      $t4, $t4, REQUEST_PUZZLE_INT_MASK	        # puzzle interrupt bit
	or      $t4, $t4, 1 # global enable
	mtc0    $t4, $12

	#Fill in your code here
	
label:	lw $t1, GET_MONEY
	bge $t1, 5, go
	la $t0, SPACE
	sw $t0, REQUEST_PUZZLE
	sw $zero, Flag
	
wait:	lw $t0, Flag
	beq $t0, 0, wait
	j label


go:	jal move_south
	jal move_south
	sw $zero, PICKUP  # pick up meat
	jal move_east
	jal move_south
	jal move_south
	jal move_south
	jal move_south
	jal move_south
	jal turn_west
	sw $zero, PICKUP  # pick up cheese
	jal move_south
	jal move_south
	jal move_south
	jal move_south
	jal turn_west
	sw $zero, PICKUP  # pick up onion
	jal move_east
	jal move_north
	jal move_north
	jal move_north
	jal move_north
	jal move_north
	jal move_north
	jal move_north
	jal move_north
	jal turn_north
	sw $zero, DROPOFF  # drop off meat on the oven
	jal cooking_meat
	sw $zero, PICKUP  # pick up meat
	jal move_east
	jal move_east
 	jal move_east
	jal turn_north
	li $t3, 2
	sw $t3, DROPOFF  # drop off onion 
	jal copping_onion
	sw $zero, PICKUP  # pick up onion
	jal move_east
	li $t3, 2
	sw $t3, DROPOFF
	li $t3, 1
	sw $t3, DROPOFF
	li $t3, 0
	sw $t3, DROPOFF
	jr $ra



.kdata
chunkIH:    .space 32
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
        move      $k1, $at        # Save $at
.set at
        la        $k0, chunkIH
        sw        $a0, 0($k0)        # Get some free registers
        sw        $v0, 4($k0)        # by storing them to a global variable
        sw        $t0, 8($k0)
        sw        $t1, 12($k0)
        sw        $t2, 16($k0)
        sw        $t3, 20($k0)
		sw $t4, 24($k0)
		sw $t5, 28($k0)

        mfc0      $k0, $13             # Get Cause register
        srl       $a0, $k0, 2
        and       $a0, $a0, 0xf        # ExcCode field
        bne       $a0, 0, non_intrpt




interrupt_dispatch:            # Interrupt:
    mfc0       $k0, $13        # Get Cause register, again
    beq        $k0, 0, done        # handled all outstanding interrupts

    and        $a0, $k0, BONK_INT_MASK    # is there a bonk interrupt?
    bne        $a0, 0, bonk_interrupt

    and        $a0, $k0, TIMER_INT_MASK    # is there a timer interrupt?
    bne        $a0, 0, timer_interrupt

	and 	$a0, $k0, REQUEST_PUZZLE_INT_MASK
	bne 	$a0, 0, request_puzzle_interrupt

    li        $v0, PRINT_STRING    # Unhandled interrupt types
    la        $a0, unhandled_str
    syscall
    j    done

bonk_interrupt:
	sw $0, BONK_ACK
    #Fill in your code here
    j       interrupt_dispatch    # see if other interrupts are waiting

request_puzzle_interrupt:
	sw $0, REQUEST_PUZZLE_ACK
	#Fill in your code here
	li, $a0, 1
	li, $a1, 1
	la, $a2, SPACE
	jal dfs
	sw $v0, solution
	la $t1, solution
	sw $t1, SUBMIT_SOLUTION
	li $t0, 1
	sw $t0, Flag
	j	interrupt_dispatch

.globl dfs
dfs:
				sub		$sp, $sp, 16		# STACK STORE
				sw 		$ra, 0($sp)		# Store ra
				sw		$s0, 4($sp)		# s0 = target
				sw		$s1, 8($sp)		# s1 = i
				sw		$s2, 12($sp)	# s2 = tree
				move 	$s0, $a0
				move 	$s1, $a1
				move	$s2, $a2


			##	if (i >= 127) {
			##		return -1;
			##	}

			_dfs_base_case_one:
			blt     $s1, 127, _dfs_base_case_two
			li      $v0, -1
			j _dfs_return


			##	if (target == tree[i]) {
			##		return 0;
			##	}

			_dfs_base_case_two:

				mul		$t1, $s1, 4
				add		$t2, $s2, $t1
			lw      $t1, 0($t2)  			# tree[i]

			bne     $t1, $s0, _dfs_ret_one
			li      $v0, 0
				j _dfs_return

			##	int ret = dfs(target, 2 * i, tree);
			##	if (ret >= 0) {
			##		return ret + 1;
			##	}
			_dfs_ret_one:
				mul		$a1, $s1, 2
				jal 	dfs				##	int ret = dfs(target, 2 * i, tree);


				blt		$v0, 0, _dfs_ret_two	##	if (ret >= 0)

				addi	$v0, 1					##	return ret + 1
				j _dfs_return

			##	ret = dfs(target, 2 * i + 1, tree);
			##	if (ret >= 0) {
			##		return ret + 1;
			##	}
			_dfs_ret_two:
			mul		$a1, $s1, 2
				addi	$a1, 1
				jal 	dfs				##	ret = dfs(target, 2 * i + 1, tree);


				blt		$v0, 0, _dfs_return		##	if (ret >= 0)

				addi	$v0, 1					##	return ret + 1
				j _dfs_return

			##	return ret;
			_dfs_return:
				lw 		$ra, 0($sp)
				lw		$s0, 4($sp)
				lw		$s1, 8($sp)
				lw		$s2, 12($sp)
				add		$sp, $sp, 16
			jal     $ra




timer_interrupt:
	sw 		$0, TIMER_ACK
	#Fill in your code here
    j        interrupt_dispatch    # see if other interrupts are waiting

non_intrpt:                # was some non-interrupt
    li        $v0, PRINT_STRING
    la        $a0, non_intrpt_str
    syscall                # print out an error message
    # fall through to done

done:
    la      $k0, chunkIH
    lw      $a0, 0($k0)        # Restore saved registers
    lw      $v0, 4($k0)
    lw      $t0, 8($k0)
    lw      $t1, 12($k0)
    lw      $t2, 16($k0)
    lw      $t3, 20($k0)
    lw      $t4, 24($k0)
    lw      $t5, 28($k0)
.set noat
    move    $at, $k1        # Restore $at
.set at
    eret


.text
.globl move_south
move_south:
lw $t2, 0xffff0024($zero) # current y location
li $t3, 90
sw $t3, 0xffff0014($zero)
li $t3, 1
sw $t3, 0xffff0018($zero) # set current angle to the south 90
add $t2, $t2, 20 # the target y location
go_south:
lw $t1, 0xffff0024($zero) # current y location
bge $t1, $t2, arrive
li $t3, 5
sw $t3, 0xffff0010($zero) #set current velocity 
j go_south
arrive:
sw $zero, 0xffff0010($zero) #set current velocity 0
jr $ra

.text
.globl move_east
move_east:
lw $t2, BOT_X # current x location
sw $zero, 0xffff0014($zero)
li $t3, 1
sw $t3, 0xffff0018($zero) # set current angle to the east 0
add $t2, $t2, 20 # the target x location
go_east:
lw $t1, 0xffff0020($zero) # current x location
bge $t1, $t2, arrive2
li $t3, 5
sw $t3, 0xffff0010($zero) #set current velocity 5
j go_east
arrive2:
sw $zero, 0xffff0010($zero) #set current velocity 0
jr $ra

.text
.globl move_west
move_west:
lw $t2, 0xffff0020($zero) # current x location
li $t3, 180
sw $t3, 0xffff0014($zero)
li $t3, 1
sw $t3, 0xffff0018($zero) # set current angle to the west 180
sub $t2, $t2, 20 # the target x location
go_west:
lw $t1, 0xffff0020($zero) # current x location
bge $t2, $t1, arrive3
li $t3, 5
sw $t3, 0xffff0010($zero) #set current velocity 5
j go_west
arrive3:
sw $zero, 0xffff0010($zero) #set current velocity 0
jr $ra

.text
.globl move_north
move_north:
lw $t2, 0xffff0024($zero) # current y location
li $t3, 270
sw $t3, 0xffff0014($zero)
li $t3, 1
sw $t3, 0xffff0018($zero) # set current angle to the north 270
sub $t2, $t2, 20 # the target y location
go_north:
lw $t1, 0xffff0024($zero) # current y location
bge $t2, $t1, arrive4
li $t3, 5
sw $t3, 0xffff0010($zero) #set current velocity 5
j go_north
arrive4:
sw $zero, 0xffff0010($zero) #set current velocity 0
jr $ra

.text
.globl turn_west
turn_west:
li $t3, 180
sw $t3, 0xffff0014($zero)
li $t3, 1
sw $t3, 0xffff0018($zero) # set current angle to 180
jr $ra

.text
.globl turn_north
turn_north:
li $t3, 270
sw $t3, 0xffff0014($zero)
li $t3, 1
sw $t3, 0xffff0018($zero) # set current angle to 180
jr $ra

.text
.globl cooking_meat
cooking_meat:
li $t0, 0x00020002
sw $t0, SET_TILE
meatnotyet:
lw $t1, GET_TILE_INFO
beq $t1, 0, meatnotyet
jr $ra


.text
.globl copping_onion
copping_onion:
li $t0, 0x00020005
sw $t0, SET_TILE
onionnotyet:
lw $t1, GET_TILE_INFO
beq $t1, 0, onionnotyet
jr $ra
