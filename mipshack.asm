# Dylan Singh
# 111484302
# DYSINGH

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

########################################################## Part I ################################################################
init_game:

#S 0 1 2 4 5 6
li $v0, -200
li $v1, -200
addi $sp, $sp, -32 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s2 on stack
sw $s3, 16($sp) # save $s1 on stack
sw $s4, 20($sp) # save $s2 on stack
sw $s5, 24($sp) # save $s2 on stack
sw $s6, 28($sp) # save $s2 on stack

#a0 = string map filename
#a1 = Map *map ptr
#a2 = Player *player ptr)
move $t0, $a0
move $t1, $a1
move $t2, $a2

move $s4, $t1	#messed up so got lazy :)
move $s5, $t2
move $s6, $s4	#can delete probably (for testing)

addi $sp, $sp, -9801	#Use stack to store map stuffs
#a0 has file name
move $a0, $t0
li $a1, 0	#read only
li $a2, -1	#ignored
li $v0, 13	#Read from file
syscall 
#v0 has file decyrptor
move, $s0, $v0		#s1 has decryptr ******* FILES ONLY WORK IF ON DESKTOP
bltz $v0, init_error	#if v0 is error from syscal
#read from file
move $a0, $s0
#Use Stack pointer to store

move $a1, $sp	#map ptr 

li $a2, 9801	#Max Chars #################*********ASK IF THERE IS A LIMIT
li $v0, 14	#Read from file
syscall
bltz $v0, init_error	#if v0 is error from syscal
#close file
move $a0, $s0
li $v0, 16
syscall
bltz $v0, init_error	#if v0 is error from syscal
#result in at $t1 (map ptr)

move $s2, $sp			#s2 will be used as sp

#Find Rows
lbu $t2, 0($s2)
addi $t2, $t2, -48		#Check this
lbu $t3, 1($s2)
addi $t3, $t3, -48 
#beqz $t2, findCol
#didget(t2) * 10 + t3)
li $t0, 10
mul $t2, $t2, $t0
add $t3, $t2, $t3

findCol: #(row in s0)
addi $s2, $s2, 3
move $s0, $t3		#s0 has rows
lbu  $t2, 0($s2)
addi $t2, $t2, -48		#Check this
lbu $t3, 1($s2)
addi $t3, $t3, -48 
#beqz $t2, findCol
#didget(t2) * 10 + t3)
li $t0, 10
mul $t2, $t2, $t0
add $t3, $t2, $t3
move $s1, $t3		#s1 has cols

sb $s0, 0($s4)		#Store row
sb $s1, 1($s4)		#Store col


addi $s4, $s4, 2	#advance map_ptr
addi $s2, $s2, 2	#advance sp of stuff

li $t0, 0	#row count
li $t1, 0	#col count
plotmaploop:
	lb $t2, 0($s2)	#pointer to stack(has continuin map stuff)
	
	beq $t2, '\n', nextRowPlot	#Next row if at newline
	#beq $t1, $s1, nextRowPlot
	
	ori $t2, $t2, 0x80		#Mask 7th bit
	sb $t2, 0($s4)	#s4 has map_ptr
	beq $t2, 192, setPlayerCoords	#@ with 7th bit masked 1100000s
	
contplotmaploop:	
	addi $s2, $s2, 1	#advance
	addi $s4, $s4, 1	#advance	
	addi $t1, $t1, 1	#next column
j plotmaploop	

nextRowPlot:
	beq $t0, $s0, plot.done
	addi $t0, $t0, 1
	addi $s2, $s2, 1	#advance
	li $t1, 0
	j plotmaploop
	
setPlayerCoords:
	addi $t5, $t0, -1
	sb $t5, 0($s5)
	sb $t1, 1($s5)	#s5 has player ptr
	j contplotmaploop

plot.done:
addi $s2, $s2 1

lbu $t2, 0($s2) 	#somehow its an int, but ok ** CHECK
addi $t2, $t2, -48		#Check this
lb $t3, 1($s2)
addi $t3, $t3, -48 
beqz $t2, setPlayerHealth
#didget(t2) * 10 + t3)
li $t0, 10
mul $t2, $t2, $t0
add $t3, $t2, $t3

setPlayerHealth:
#Set $t2 to 3rd bit of player
sb $t3, 2($s5)
li $t0, 0
sb $t0, 3($s5)

#null terminate new map_ptr
li $t0, '\0'
sb $t0, 0($s4)

li $v0, 0
addi $sp, $sp, 9801	#restore stack


lw $ra, 0($sp)
lw $s0, 4($sp) # save $ra on stack
lw $s1, 8($sp) # save $s1 on stack
lw $s2, 12($sp) # save $s2 on stack
lw $s3, 16($sp) # save $s1 on stack
lw $s4, 20($sp) # save $s2 on stack
lw $s5, 24($sp) # save $s2 on stack
lw $s6, 28($sp) # save $s2 on stack
addi $sp, $sp, 32 # make space on stack to
jr $ra

init_error:
addi $sp, $sp, 9801	#restore stack
lw $ra, 0($sp)
lw $s0, 4($sp) # save $ra on stack
lw $s1, 8($sp) # save $s1 on stack
lw $s2, 12($sp) # save $s2 on stack
lw $s3, 16($sp) # save $s1 on stack
lw $s4, 20($sp) # save $s2 on stack
lw $s5, 24($sp) # save $s2 on stack
lw $s6, 28($sp) # save $s2 on stack
addi $sp, $sp, 32 # make space on stack to
	li $v0 -1
	jr $ra

######################################################## Part II ##################################################################
is_valid_cell:
li $v0, -200
li $v1, -200

#The function takes the following arguments, in this order:
#• map ptr: The starting address of a Map struct. Note: this is NOT the address of the character at index
#[0][0] of the game world.
#• row: The 0-based row index of the desired byte.
#• col: The 0-based column index of the desired by

#a0 = map_ptr
#a1 = row
#a2 = col

#Get map ptr rows and cols
lbu $t0, 0($a0)	#map ptr rows
lbu $t1, 1($a0)	#map ptr cols

#ERROR CHECKS#
bltz, $a1, is_valid_cell.error	#row<0
bltz, $a2, is_valid_cell.error	#col<0

bge $a1, $t0, is_valid_cell.error
bge, $a2, $t1, is_valid_cell.error

li $v0, 0
jr $ra

is_valid_cell.error:
li $v0, -1
jr $ra

######################################################### Part III #################################################################
get_cell:
li $v0, -200
li $v1, -200

addi $sp, $sp, -16 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s2 on stack

move $s0, $a0
move $s1, $a1
move $s2, $a2

jal is_valid_cell

beq $v0 -1, get_cell.error

lbu $t0, 0($s0)	#map ptr rows
lbu $t1, 1($s0)	#map ptr cols

addi $s0, $s0, 2	#base addr of array now is s0
			#i = s1
			#j = s2
			#cols = $t1
			#1 byte = size

#addr = base + size(i*cols+j)
#addr = s2 + t2(s1*t1+s2)
#Address Calculation
mul $t4, $s1, $t1	#i*cols = t4
add $t4, $t4, $s2	#t4 =(i*cols+j)
add $t4, $t4, $s0	#t4 = address of element we want to switch

lbu $v0, 0($t4)

j get_cell.exit

get_cell.error:
li $v0, -1
j get_cell.exit

get_cell.exit:
 
lw $ra, 0($sp)# save $ra on stack
lw $s0, 4($sp) # save $s0 on stack
lw $s1, 8($sp) # save $s1 on stack
lw $s2, 12($sp) # save $s2 on stack
addi $sp, $sp, 16 # dealolcate space on stack to
jr $ra

######################################################### Part IV #################################################################
set_cell:
li $v0, -200
li $v1, -200

addi $sp, $sp, -20 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s2 on stack
sw $s3, 16($sp) #save s3 on stack

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3	#char
jal is_valid_cell

beq $v0 -1, get_cell.error

lbu $t0, 0($s0)	#map ptr rows
lbu $t1, 1($s0)	#map ptr cols

addi $s0, $s0, 2	#base addr of array now is s0
			#i = s1
			#j = s2
			#cols = $t1
			#1 byte = size

#addr = base + size(i*cols+j)
#addr = s2 + t2(s1*t1+s2)
#Address Calculation
mul $t4, $s1, $t1	#i*cols = t4
add $t4, $t4, $s2	#t4 =(i*cols+j)
add $t4, $t4, $s0	#t4 = address of element we want to switch

sb $s3, 0($t4)
li $v0, 0
j set_cell.exit

set_cell.error:
	li $v0, -1

set_cell.exit:
	lw $ra, 0($sp)# save $ra on stack
	lw $s0, 4($sp) # save $s0 on stack
	lw $s1, 8($sp) # save $s1 on stack
	lw $s2, 12($sp) # save $s2 on stack
	lw $s3, 16($sp)#load s3 from stack
	addi $sp, $sp, 20 # dealolcate space on stack to
	jr $ra


######################################################### Part V ##################################################################
reveal_area:
li $v0, -200
li $v1, -200
#S 0 1 2 3 4
addi $sp, $sp, -24 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s2 on stack
sw $s3, 16($sp) # save $s1 on stack
sw $s4, 20($sp) # save $s2 on stack

move $s0, $a0
move $s1, $a1
move $s2, $a2

li $s3, 0	#row count for loop only
li $s4, 0	#col coumt for loop only

addi $s1, $s1, -1	#Row num
addi $s2, $s2, -1	#Col num
reveal_check.loop:
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	jal is_valid_cell
	
	beqz, $v0, reveal.set
	
	addi $s4, $s4, 1	#increiment colms
	addi $s2, $s2, 1	#increiment colms
	
	beq $s4, 3, reveal.nextRow
j reveal_check.loop

reveal.nextRow:
addi $s1, $s1, 1
addi $s3, $s3, 1
addi $s2, $s2, -3	#Reset cols back to start
addi $s4, $s4, -3	#Reset cols back to start
beq $s3, 3, reveal_area.exit
j reveal_check.loop


reveal.set:
	#Get cell at row and col (#s1, #s3)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal get_cell
	beq $v0, -1, invalid_cell_error	#invalid position, do nothign continue
	
	andi $a3, $v0, 0x7F		
	jal set_cell		#set 7th bit to 0

	addi $s4, $s4, 1	#increiment colms
	addi $s2, $s2, 1	#increiment colms
invalid_cell_error:
	beq $s4, 3, reveal.nextRow	#if end of col then next row, else next col
j reveal_check.loop

reveal_area.exit:
lw $ra, 0($sp)# save $ra on stack
lw $s0, 4($sp) # save $s0 on stack
lw $s1, 8($sp) # save $s1 on stack
lw $s2, 12($sp) # save $s2 on stack
lw $s3, 16($sp)
lw $s4, 20($sp) # save $s2 on stack
addi $sp, $sp, 24 # dealolcate space on stack to
jr $ra

######################################################## Part VI ##################################################################
get_attack_target:
li $v0, -200
li $v1, -200

addi $sp, $sp, -16 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s2 on stack

#int get attack target(Map *map ptr, Player *player ptr, char direction)
#check if char is U D L R
#a0 = map
#a1 = player
#a2 = char
move $s0, $a0

lbu $s1, 0($a1)		#player row
lbu $s2, 1($a1)		#player col

beq $a2, 'U', targetUp
beq $a2, 'D', targetDown
beq $a2, 'L', targetLeft
beq $a2, 'R', targetRight
j target_error	#if none error.

targetUp:
#find coords
#player ptr.row-1,player ptr.col
addi $a1, $s1, -1
move $a2, $s2
jal get_cell
beq $v0, -1, target_error	#If invalid index error
j checkTarget			#else check target

targetDown:
#player ptr.row+1,player ptr.col
addi $a1, $s1, 1
move $a2, $s2
jal get_cell
beq $v0, -1, target_error	#If invalid index error
j checkTarget			#else check target

targetLeft:
#player ptr.row,player ptr.col -1
move $a1, $s1
addi $a2, $s2, -1
jal get_cell
beq $v0, -1, target_error	#If invalid index error
j checkTarget			#else check target

targetRight:
#player ptr.row,player ptr.col + 1
move $a1, $s1
addi $a2, $s2, 1
jal get_cell
beq $v0, -1, target_error	#If invalid index error
j checkTarget			#else check target

checkTarget:

#Hard check if $v0 is  m , B, /
beq $v0, 'm', targetIsValid
beq $v0, 'B', targetIsValid
beq $v0, '/', targetIsValid
j target_error
targetIsValid:
	lw $ra, 0($sp)# save $ra on stack
	lw $s0, 4($sp) # save $s0 on stack
	lw $s1, 8($sp) # save $s1 on stack
	lw $s2, 12($sp) # save $s2 on stack
	addi $sp, $sp, 16 # dealolcate space on stack to
	jr $ra

target_error:
li $v0, -1

lw $ra, 0($sp)# save $ra on stack
lw $s0, 4($sp) # save $s0 on stack
lw $s1, 8($sp) # save $s1 on stack
lw $s2, 12($sp) # save $s2 on stack
addi $sp, $sp, 16 # dealolcate space on stack to
jr $ra


####################################################### Part VII ###################################################################
complete_attack:
li $v0, -200
li $v1, -200

#void complete attack(Map *map ptr, Player *player ptr, int target row, int target col)

addi $sp, $sp, -20 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s2 on stack
sw $s3, 16($sp) #save s3 on stack

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3	#char

move $a1, $s2
move $a2, $s3
jal get_cell


beq $v0, 'm', monster_battle
beq $v0, 'B', boss_battle
beq $v0, '/', wall_battle

monster_battle:
	#Player health -1
	lb $t0, 2($s1)
	addi $t0, $t0, -1
	sb $t0, 2($s1)

	#Replace m with $
	li $t0, '$'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t0
	jal set_cell
	j checkPlayerHealthPositive

boss_battle:
	#Player health -2
	lb $t0, 2($s1)
	addi $t0, $t0, -2
	sb $t0, 2($s1)

	#Replace m with $
	li $t0, '*'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t0
	jal set_cell
	j checkPlayerHealthPositive
wall_battle:
	#Replace / with .
	li $t0, '.'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t0
	jal set_cell
	j checkPlayerHealthPositive
checkPlayerHealthPositive:
	lb $t0, 2($s1)
	blez $t0, playerDied 
	
	j attack.done

playerDied:
	#Replace @ with X
	li $t0, 'X'
	move $a0, $s0
	lbu $a1, 0($s1)
	lbu $a2, 1($s1)
	move $a3, $t0
	jal set_cell

attack.done:
	lw $ra, 0($sp)# save $ra on stack
	lw $s0, 4($sp) # save $s0 on stack
	lw $s1, 8($sp) # save $s1 on stack
	lw $s2, 12($sp) # save $s2 on stack
	lw $s3, 16($sp)#load s3 from stack
	addi $sp, $sp, 20 # dealolcate space on stack to
	jr $ra

###################################################### Part VIII ##################################################################
monster_attacks:
li $v0, -200
li $v1, -200

# int monster attacks(Map *map ptr, Player *player ptr)
addi $sp, $sp, -24 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s1 on stack
sw $s3, 16($sp) # save $s1 on stack
sw $s4, 20($sp) # save $s1 on stack
#a0 = map
#a1 = player
move $s0, $a0
lbu $s1, 0($a1)
lbu $s2, 1($a1)

li $s3, 0 #boss count
li $s4, 0 #minion coynt

isMonsterAbove:
#player ptr.row-1,player ptr.col
move $a0, $s0
addi $a1, $s1, -1
move $a2, $s2
jal get_cell

beq $v0, 'B', bossIsAbove
beq $v0, 'm', monsterIsAbove

isMonsterBelow:
#player ptr.row+1,player ptr.col
move $a0, $s0
addi $a1, $s1, 1
move $a2, $s2
jal get_cell

beq $v0, 'B', bossIsBelow
beq $v0, 'm', monsterIsBelow

isMonsterLeft:
#player ptr.row,player ptr.col -1
move $a0, $s0
move $a1, $s1
addi $a2, $s2, -1
jal get_cell

beq $v0, 'B', bossIsLeft
beq $v0, 'm', monsterIsLeft

isMonsterRight:
#player ptr.row,player ptr.col + 1
move $a0, $s0
move $a1, $s1
addi $a2, $s2, 1
jal get_cell

beq $v0, 'B', bossIsRight
beq $v0, 'm', monsterIsRight

j monster.damage.done


monsterIsAbove:
	addi $s4, $s4, 1
	j isMonsterBelow
monsterIsBelow:
	addi $s4, $s4, 1
	j isMonsterLeft
monsterIsLeft:
	addi $s4, $s4, 1
	j isMonsterRight
monsterIsRight:
	addi $s4, $s4, 1
	j monster.damage.done

bossIsAbove:
	addi $s3, $s3, 1
	j isMonsterBelow
bossIsBelow:
	addi $s3, $s3, 1
	j isMonsterLeft
bossIsLeft:
	addi $s3, $s3, 1
	j isMonsterRight
bossIsRight:
	addi $s3, $s3, 1
	j monster.damage.done
	
monster.damage.done:
sll $s3, $s3, 1
add $v0, $s3, $s4

lw $ra, 0($sp)# save $ra on stack
lw $s0, 4($sp) # save $s0 on stack
lw $s1, 8($sp) # save $s1 on stack
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
addi $sp, $sp, 24 # dealolcate space on stack to
jr $ra

#################################################### Part IX #####################################################################

player_move:
li $v0, -200
li $v1, -200

addi $sp, $sp, -20 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s1 on stack
sw $s3, 16($sp) # save $s1 on stack
#a0 = map
#a1 = player
move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3

jal monster_attacks
move $t0, $v0

#Player health = lb #2	t1 - t0
lb $t1, 2($s1)
sub $t0, $t1, $t0	#t0 is new player health
#Set this health
sb $t0, 2($s1)
#check if my man died
blez, $t0, playerDiedInMove

move $a0, $s0
move $a1, $s2
move $a2, $s3
jal get_cell

beq $v0, '.', player.move.space
beq $v0, '$', player.move.coin
beq $v0, '*', player.move.bag
beq $v0, '>', player.move.end

player.move.space: 
	li $t0, '.'
	move $a0, $s0
	lbu $a1, 0($s1)
	lbu $a2, 1($s1)
	move $a3, $t0
	jal set_cell
	
	li $t0, '@'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t0
	jal set_cell
	
	li $v0, 0 
	
	j player.move.exit
	
player.move.coin:
	li $t0, '.'
	move $a0, $s0
	lbu $a1, 0($s1)
	lbu $a2, 1($s1)
	move $a3, $t0
	jal set_cell
	
	li $t0, '@'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t0
	jal set_cell
	
	#Add 1 to players coins
	lbu $t0, 3($s1)
	addi $t0, $t0, 1
	sb $t0, 3($s1)
	
	li $v0, 0 
	
	j player.move.exit

player.move.bag:
	li $t0, '.'
	move $a0, $s0
	lbu $a1, 0($s1)
	lbu $a2, 1($s1)
	move $a3, $t0
	jal set_cell
	
	li $t0, '@'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t0
	jal set_cell
	
	#Add 1 to players coins
	lbu $t0, 3($s1)
	addi $t0, $t0, 5
	sb $t0, 3($s1)
	
	li $v0, 0 
	
	j player.move.exit

player.move.end:
	li $t0, '.'
	move $a0, $s0
	lbu $a1, 0($s1)
	lbu $a2, 1($s1)
	move $a3, $t0
	jal set_cell
	
	li $t0, '@'
	move $a0, $s0
	move $a1, $s2
	move $a2, $s3
	move $a3, $t0
	jal set_cell
	
	li $v0, -1
	
	j player.move.exit


playerDiedInMove:
	#Replace @ with X
	li $t0, 'X'
	move $a0, $s0
	lbu $a1, 0($s1)
	lbu $a2, 1($s1)
	move $a3, $t0
	jal set_cell

	li $v0, 0
	
player.move.exit:
	#change to new player_stucrt to new position
	sb $s2, 0($s1)
	sb $s3, 1($s1)
	##
	lw $ra, 0($sp)# save $ra on stack
	lw $s0, 4($sp) # save $s0 on stack
	lw $s1, 8($sp) # save $s1 on stack
	lw $s2, 12($sp) # save $s2 on stack
	lw $s3, 16($sp)
	addi $sp, $sp, 20 # dealolcate space on stack to
	jr $ra

################################################## Part X ######################################################################
player_turn:
li $v0, -200
li $v1, -200

addi $sp, $sp, -24 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s2 on stack
sw $s3, 16($sp) # save $s1 on stack
sw $s4, 20($sp) # save $s2 on stack
#check if char is U D L R
#a0 = map
#a1 = player
#a2 = char
move $s0, $a0
move $s3, $a1
move $s4, $a2
lbu $s1, 0($a1)		#player row
lbu $s2, 1($a1)		#player col

beq $a2, 'U' turn.direction.up
beq $a2, 'D' turn.direction.down
beq $a2, 'L' turn.direction.left
beq $a2, 'R' turn.direction.right
j turn.error			#Else error
##
turn.direction.up:
#find coords
#player ptr.row-1,player ptr.col
addi $s1, $s1, -1
move $a1, $s1
move $a2, $s2
jal get_cell
j turn.checkMonster				#else check target

turn.direction.down:
#player ptr.row+1,player ptr.col
addi $s1, $s1, 1
move $a1, $s1
move $a2, $s2
jal get_cell
j turn.checkMonster		#else check target

turn.direction.left:
#player ptr.row,player ptr.col -1
addi $s2, $s2, -1
move $a1, $s1
move $a2, $s2
jal get_cell
j turn.checkMonster			#else check target

turn.direction.right:
#player ptr.row,player ptr.col + 1
addi $s2, $s2, 1
move $a1, $s1
move $a2, $s2
jal get_cell
j turn.checkMonster			#else check target


turn.checkMonster:
beq $v0, -1, turn_invalid_target	#If invalid index error
beq $v0, '#', turn_invalid_target

move $a0, $s0
move $a1, $s3
move $a2, $s4
jal get_attack_target
beq $v0, -1, turn.isMove

move $a0, $s0
move $a1, $s3
move $a2, $s1
move $a3, $s2
jal complete_attack
j turn_invalid_target	#not invalid but returns 0 so.

turn.isMove:
move $a0, $s0
move $a1, $s3
move $a2, $s1
move $a3, $s2
jal player_move
j turn.exit

turn_invalid_target:
li $v0, 0
j turn.exit

turn.error:
li $v0, -1
j turn.exit

turn.exit:
lw $ra, 0($sp)# save $ra on stack
lw $s0, 4($sp) # save $s0 on stack
lw $s1, 8($sp) # save $s1 on stack
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
addi $sp, $sp, 24 # dealolcate space on stack to
jr $ra

################################################# Part XI ######################################################################
flood_fill_reveal:
li $v0, -200
li $v1, -200

#int flood fill reveal(Map *map ptr, int row, int col, bit[][] visited)
addi $sp, $sp, -36 # make space on stack to
sw $ra, 0($sp)
sw $s0, 4($sp) # save $ra on stack
sw $s1, 8($sp) # save $s1 on stack
sw $s2, 12($sp) # save $s2 on stack
sw $s3, 16($sp) # save $s1 on stack
sw $s4, 20($sp) # save $s2 on stack
sw $s5, 24($sp) # save $s1 on stack
sw $s6, 28($sp) # save $s2 on stack
sw $fp, 32($sp) 

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3


#map.ptr.numcols = s4
lb $s4, 1($s0)

#map.ptr.numrows = to
lb $t0, 0($s0)

#error checks
bltz $a1, flood_reveal.error
bge $a1, $t0, flood_reveal.error
bltz $a2, flood_reveal.error
bge $a2, $s4, flood_reveal.error

#check row col is_valid
move $a0, $s0
move $a1, $s1
move $a2, $s2
jal is_valid_cell

beq $v0, -1, flood_reveal.error

move $fp, $sp		#fp = sp

addi $sp $sp, -4
sb $s1, 1($sp)		#$sp.push(row)
sb $s2, 0($sp)		#$sp.push(col)

flood.loop:# while $sp != $fp:

beq $sp, $fp, flood_reveal.done

lb $s1, 1($sp)	#row = $sp.pop()	
lb $s2, 0($sp)	#col = $sp.pop()
addi $sp $sp, 4

#make the cell at index (row,col) visible in the world map
#Get cell at row and col (#s1, #s3)
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal get_cell
	beq $v0, -1, flood.loop	#invalid position, do nothign continue
	andi $a3, $v0, 0x7F		
	jal set_cell		#set 7th bit to 0	
	
	#offset1:
	li $t0, -1	#i = -1
	li $t1, 0	#j = 0
	
	add $s5, $s1, $t0	#row + i = t0
	add $s6, $s2, $t1	#col + j = t1
	
	move $a0, $s0
	move $a1, $s5
	move $a2, $s6
	jal get_cell
	
	#if the cell at index (row+i, col+j) represents empty floor 
	andi $v0, $v0, 127	#ignore 7th bit
	bne $v0, 46, offset2	#check next offset
	#AND (*) the cell has not been visited yet, then
	
	move $a0, $s3	#visited array
	move $a1, $s5	#i
	move $a2, $s6	#j
	move $a3, $s4	#num cols
	jal is_visited
	
	beqz $v0, offset2		#check next offset is it was visited
							
	#else
			#(1) set that cell as having been visited
	move $a0, $s3	#visited array
	move $a1, $s5	#i
	move $a2, $s6	#j
	move $a3, $s4	#num cols
	jal set_visited	
	
	addi $sp, $sp, -4
	sb $s5, 1($sp)	#(2) $sp.push(row+i)
	sb $s6, 0($sp)	#(3) $sp.push(col+j)	

offset2:
	li $t0, 1	#i = 1
	li $t1, 0	#j = 0
	
	add $s5, $s1, $t0	#row + i = t0
	add $s6, $s2, $t1	#col + j = t1
	
	move $a0, $s0
	move $a1, $s5
	move $a2, $s6
	jal get_cell
	
	#if the cell at index (row+i, col+j) represents empty floor 
	andi $v0, $v0, 127	#ignore 7th bit
	bne $v0, 46, offset3	#check next offset
	#AND (*) the cell has not been visited yet, then
	
	move $a0, $s3	#visited array
	move $a1, $s5	#i
	move $a2, $s6	#j
	move $a3, $s4	#num cols
	jal is_visited
	
	beqz $v0, offset3		#check next offset is it was visited
							
	#else
			#(1) set that cell as having been visited
	move $a0, $s3	#visited array
	move $a1, $s5	#i
	move $a2, $s6	#j
	move $a3, $s4	#num cols
	jal set_visited	

	
	addi $sp, $sp, -4
	sb $s5, 1($sp)	#(2) $sp.push(row+i)
	sb $s6, 0($sp)	#(3) $sp.push(col+j)	
offset3:
	li $t0, 0	#i = 0
	li $t1, -1	#j = -1
	
	add $s5, $s1, $t0	#row + i = t0
	add $s6, $s2, $t1	#col + j = t1
	
	move $a0, $s0
	move $a1, $s5
	move $a2, $s6
	jal get_cell
	
	#if the cell at index (row+i, col+j) represents empty floor 
	andi $v0, $v0, 127	#ignore 7th bit
	bne $v0, 46, offset4	#check next offset
	#AND (*) the cell has not been visited yet, then
	
	move $a0, $s3	#visited array
	move $a1, $s5	#i
	move $a2, $s6	#j
	move $a3, $s4	#num cols
	jal is_visited
	
	beqz $v0, offset4		#check next offset is it was visited
							
	#else
			#(1) set that cell as having been visited
	move $a0, $s3	#visited array
	move $a1, $s5	#i
	move $a2, $s6	#j
	move $a3, $s4	#num cols
	jal set_visited	
	addi $sp, $sp, -4
	sb $s5, 1($sp)	#(2) $sp.push(row+i)
	sb $s6, 0($sp)	#(3) $sp.push(col+j)	
offset4:
	li $t0, 0	#i = 0
	li $t1, 1	#j = 1
	
	add $s5, $s1, $t0	#row + i = t0
	add $s6, $s2, $t1	#col + j = t1
	
	move $a0, $s0
	move $a1, $s5
	move $a2, $s6
	jal get_cell
	
	#if the cell at index (row+i, col+j) represents empty floor 
	andi $v0, $v0, 127	#ignore 7th bit
	bne $v0, 46, flood.loop	#check next offset
	#AND (*) the cell has not been visited yet, then
	
	move $a0, $s3	#visited array
	move $a1, $s5	#i
	move $a2, $s6	#j
	move $a3, $s4	#num cols
	jal is_visited
	
	beqz $v0, flood.loop		#check next offset is it was visited
							
	#else
			#(1) set that cell as having been visited
	move $a0, $s3	#visited array
	move $a1, $s5	#i
	move $a2, $s6	#j
	move $a3, $s4	#num cols
	jal set_visited	
	addi $sp, $sp, -4
	sb $s5, 1($sp)	#(2) $sp.push(row+i)
	sb $s6, 0($sp)	#(3) $sp.push(col+j)	
j flood.loop

flood_reveal.error:
li $v0, -1
j flood_reveal.exit

flood_reveal.done:
li $v0, 0
flood_reveal.exit:
	lw $ra, 0($sp)# save $ra on stack
	lw $s0, 4($sp) # save $s0 on stack
	lw $s1, 8($sp) # save $s1 on stack
	lw $s2, 12($sp) # save $s2 on stack
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $fp, 32($sp) 
	jr $ra

set_visited:
#a0 = visted 2darray
#a1 = i 
#a2 = j
#a3 = num cols
	mul $t0, $a1, $a3 #i*cols = t0
	add $t0, $t0, $a2 #t0 = t0 + j
	li $t1, 8
	div $t0, $t1
	mflo $t0	#Quotient (byte needed)
	mfhi $t1	#Remainder (bit needed)

	add $t3, $a0, $t0 #base + t0
	lb $t0, 0($t3)
	#Set $t1 bit of byte
	li $t2, 1		    #0000000001
	sllv $t2, $t2, $t1     #t2  0000100000
		       #t0  0000100000
		#    and=   0000100000
	or $t0, $t0, $t2	#t0 has new byte needed
	sb $t0, 0($t3)
	
	jr $ra

is_visited:
#a0 = visted 2darray
#a1 = i 
#a2 = j
#a3 = num cols
# addr = base_addr + elem_size_in_bytes * (i * num_columns + j)
#i=$a1 j=$a2
mul $t0, $a1, $a3 #i*cols = t0
add $t0, $t0, $a2 #t0 = t0 + j

li $t1, 8
div $t0, $t1
mflo $t0	#Quotient (byte needed)
mfhi $t1	#Remainder (bit needed)

add $t0, $a0, $t0 #base + t0
lb $t0, 0($t0)
#Check $t1 bit of byte
li $t2, 1		    #0000000001
sllv $t2, $t2, $t1     #t2  0000100000
		       #t0  0000100000
		#    and=   0000100000
and $t0, $t0, $t2
srlv $t0, $t0, $t1	#00000001
#Check t0 is 0 or 1 if its visited

beqz $t0, is_visited_false	#if 0 then not visited

li $v0, 0
jr $ra

is_visited_false:
li $v0, -1
jr $ra
#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
