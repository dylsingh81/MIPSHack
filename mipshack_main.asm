.data
map_filename: .asciiz "map3.txt"
# num words for map: 45 = (num_rows * num_cols + 2) // 4 
# map is random garbage initially
.asciiz "Don't touch this region of memory"
map: .word 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 
.asciiz "Don't touch this"
# player struct is random garbage initially
player: .word 0x2912FECD
.asciiz "Don't touch this either"
# visited[][] bit vector will always be initialized with all zeroes
# num words for visited: 6 = (num_rows * num*cols) // 32 + 1
visited: .word 0 0 0 0 0 0 
.asciiz "Really, please don't mess with this string"

welcome_msg: .asciiz "Welcome to MipsHack! Prepare for adventure!\n"
pos_str: .asciiz "Pos=["
health_str: .asciiz "] Health=["
coins_str: .asciiz "] Coins=["
your_move_str: .asciiz " Your Move: "
you_won_str: .asciiz "Congratulations! You have defeated your enemies and escaped with great riches!\n"
you_died_str: .asciiz "You died!\n"
you_failed_str: .asciiz "You have failed in your quest!\n"

.text
reveal_all:
la $t0, map  # the function does not need to take arguments
lb $t1, 0($t0) #t1= row
lb $t2, 1($t0) #t2 = cols
mul $t3, $t1, $t2
li $t4, 0
addi $t0, $t0, 2
reveal.loop:
	beq $t4, $t3, reveal.done
	lbu $t5, 0($t0)	
	andi $t5, $t5, 127
	sb $t5, 0($t0)
	addi $t4, $t4, 1
	addi $t0, $t0, 1
j reveal.loop
reveal.done:
	jr $ra

print_map:
la $t0, map  # the function does not need to take arguments
lb $t1, 0($t0) #t1= row
lb $t2, 1($t0) #t2 = cols
li $t3, 0
li $t4, 0
addi $t0, $t0, 2
printmaploop:
	lbu $a0, 0($t0)	
	
	andi $t5, $a0, 128
	beqz $t5, printchar		#If 7th bit is not toggled print char - else print space
	
	li $a0, ' '
	
printchar:
	li $v0, 11
	syscall

	addi $t4, $t4, 1
	addi $t0, $t0, 1
	beq $t2, $t4, nextRowPrint	#Next row if at col = 25, t2 = t4
j printmaploop	
nextRowPrint:
	li $a0, '\n'
	li $v0, 11
	syscall
	addi $t3, $t3, 1
	li $t4, 0
	beq $t1, $t3, printMapDone		#done if at row = 7
	j printmaploop
printMapDone:	
	jr $ra 

print_player_info:
# the idea: print something like "Pos=[3,14] Health=[4] Coins=[1]"
la $t0, player
lbu $t1, 0($t0)
lbu $t2, 1($t0)
lb $t3, 2($t0)
lbu $t4, 3($t0)
#Print pos
la $a0, pos_str
li $v0, 4
syscall
move $a0, $t1
li $v0, 1
syscall
li $a0, ','
li $v0, 11
syscall
move $a0, $t2
li $v0, 1
syscall
#print health
la $a0, health_str
li $v0, 4
syscall
move $a0, $t3
li $v0, 1
syscall
#print coins
la $a0, coins_str
li $v0, 4
syscall
move $a0, $t4
li $v0, 1
syscall
li $a0, ']'
li $v0, 11
syscall
jr $ra
##################################################################################
.globl main
main:
la $a0, welcome_msg
li $v0, 4
syscall

la $a0, map_filename
la $a1, map
la $a2, player
jal init_game

la $t0, player
la $a0, map
lbu, $a1, 0($t0)
lbu, $a2, 1($t0)
jal reveal_area

li $s0, 0  # move = 0

game_loop:  # while player is not dead and move == 0:
bnez $s0, game_over
la $t0, player
lb $t3, 2($t0)
blez $t3, game_over
#jal reveal_all
jal print_map # takes no args
jal print_player_info # takes no args

# print prompt
la $a0, your_move_str
li $v0, 4
syscall

li $v0, 12  # read character from keyboard
syscall
move $s1, $v0  # $s1 has character entered
li $s0, 0  # move = 0

beq $s1, 'w', up.input
beq $s1, 'a', left.input
beq $s1, 's', down.input
beq $s1, 'd', right.input
beq $s1, 'r', reveal.input
j game_loop

up.input:
	li $a2, 'U'
	j do.player.turn
left.input:
	li $a2, 'L'
	j do.player.turn
down.input:
	li $a2, 'D'
	j do.player.turn
right.input:
	li $a2, 'R'
	j do.player.turn

reveal.input:
	la $t0, player
	la $a0, map
	lbu, $a1, 0($t0)
	lbu, $a2, 1($t0)
	la $a3, visited
	jal flood_fill_reveal
	j game_loop
	
do.player.turn:
	la $a0, map
	la $a1, player
	jal player_turn
	
	move $s0, $v0
	
	beqz $s0, reveal.inloop

reveal.inloop:
	la $t0, player
	la $a0, map
	lbu, $a1, 0($t0)
	lbu, $a2, 1($t0)
	jal reveal_area

li $a0, '\n'
li $v0 11
syscall
j game_loop

game_over:
jal print_map
jal print_player_info
li $a0, '\n'
li $v0, 11
syscall

la $t0, player
lbu $t3, 3($t0)
bge $t3, 3, player.check.health

lb $t3, 2($t0)
blez $t3, player_dead

j failed

player.check.health:
lb $t3, 2($t0)
bgtz $t3, won
j player_dead

# choose between (1) player dead, (2) player escaped but lost, (3) player escaped and won

won:
la $a0, you_won_str
li $v0, 4
syscall
j exit

failed:
la $a0, you_failed_str
li $v0, 4
syscall
j exit

player_dead:
la $a0, you_died_str
li $v0, 4
syscall

exit:
li $v0, 10
syscall



.include "mipshack.asm"
