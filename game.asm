##################################################################### 
# 
# CSCB58 Winter 2023 Assembly Final Project 
# University of Toronto, Scarborough 
# 
# Student: #
# 
# Bitmap Display Configuration: 
# - Unit width in pixels: 8 (update this as needed)  
# - Unit height in pixels: 8 (update this as needed) 
# - Display width in pixels: 1024 (update this as nee-ded) 
# - Display height in pixels: 512 (update this as needed) 
# - Base Address for Display: 0x10008000 ($gp) 
# 
# Which milestones have been reached in this submission? 
# (See the assignment handout for descriptions of the milestones) 
# - Milestone 1
# - Milestone 2
# - Milestone 3
# 
# Which approved features have been implemented for milestone 3? 
# (See the assignment handout for the list of additional features) 
# 1. Score Display (Scorebar on top and post game screens)
# 2. Win condition/Win screen (Collect 10 coin to win)
# 3. Lose condition/Game Over screen (Touch monster to lose)
# 4. Double Jump (A powerup to double jump)
# 5. Pickup/Power ups (0 - Double jump, 1 - Higher jump velocity, 2 - Build platform below, 3 - teleport to coin)
# 6. Start menu (A start menu)
# 7. Moving platforms (2 moving platforms, 1 solid moving platform and 1 soft moving platform)
# 8. Moving Objects (An monster moving left and right, a coin hovering up and down, a powerup hovering up and down)
# 
# Link to video demonstration for final submission: 
# - https://play.library.utoronto.ca/watch/1083dccc8aa350072a55fe86a7e4e4e4
# 
# Are you OK with us sharing the video with people outside course staff? 
# - yes / no / yes, and please share this project github link as well! 
# 
# Any additional information that the TA needs to know: 
# - For any powerup press F to use
# - On Main menu, use F to select the choice highlighted
# - key P brings you back to main menu
# - Two different types of platform, red - solid, orange - platform you can jump through
##################################################################### 

# DISPLAY:
.eqv 	DISPLAY		0x10008000	# The display address
# COLOR PALLETE:
.eqv 	CLR_RED		0x00C0392B
.eqv	CLR_ROSE	0x00E74C3C
.eqv	CLR_BLUE	0x003498DB
.eqv	CLR_DRKBLUE	0x002980B9
.eqv	CLR_GREEN	0x0027AE60
.eqv	CLR_LGHTGREEN	0x002ECC71
.eqv	CLR_BLACK	0x00000000
.eqv	CLR_YELLOW	0x00F1C40F
.eqv	CLR_GOLD	0x00FFD700
.eqv	CLR_WHITE	0x00FFFFFF
.eqv	CLR_GRAY	0x00BDC3C7
.eqv	CLR_DRKGRAY	0x00464646
.eqv	CLR_LGHTGRAY	0x00D0D3D4
.eqv	CLR_ORANGE	0x00F39C12
.eqv	CLR_BROWN	0x00784212
.eqv	CLR_PURPLE	0x008E44AD
.eqv	CLR_LGHTPURPLE	0x00884EA0
# BACKGROUND COLOR:
.eqv	CLR_BG		0x000A114B 	# Standard Background color
# COIN PIXELS:
.eqv	COIN_CORE	0x00FDD835	# Coin core color
.eqv	COIN_EDGE	0x00FFF59D	# Coin edge color
# TOP BAR PIXELS:
.eqv	CLR_BAR		0x00242324	# Utility bar color
.eqv	CLR_SCORE_EMP	0x00FFF59D	# Empty scorebar color
# CHARACTER PIXELS:
.eqv	CHR_FIN 	0x00D0D3D4	# Color of Player legs
.eqv	CHR_BODY	0x00FFFFFF	# Color of Player body
.eqv	CHR_EYE		0x00000000	# Color of Player eye
# MONSTER PIXELS:
.eqv	MON_EYE		0x00000000	# Color of Monster eye
.eqv	MON_BODY	0x00990030	# Color of Monster body
# CONST DISPLAY POSITION:
.eqv	LAST_ROW	0x0000003F	# Last Row on display
.eqv	LAST_COL	0x0000007F	# Last Column on display
.eqv	LAST_RIGHT	0x000001FC	# Right most column on Display already calculated
.eqv	WIDTH		0x00000200	# Total width of the Display already calculated
.eqv	BOTTOMRIGHT	0x00007FFC	# The Bottom Right Corner of the screen already calculated
# INPUT ADDRESS:
.eqv	KEYBOARD	0xFFFF0000 	# keyboard
.eqv	KEY_W		0x00000077 	# w ascii 
.eqv	KEY_A		0x00000061 	# a ascii
.eqv	KEY_D		0x00000064 	# d ascii
.eqv	KEY_F		0x00000066 	# f ascii
.eqv	KEY_S		0x00000073 	# s ascii
.eqv	KEY_P		0x00000070 	# p ascii
# POWER COLOR:
.eqv	CLR_POWER0	0x005998C5 	# Double Jump Power Core Color
.eqv	CLR_POWER1	0x00C2EABD 	# Higher Jump Power Core Color
.eqv	CLR_POWER2	0x00C75146 	# Build Platform Below Power Core Color
.eqv	CLR_POWER3	0x00363537 	# Teleport to Coin Power Core Color
# PLATFORM COLOR:
.eqv	PLAT1_CLR	0x00F39C12 	# Color for moving platform
.eqv	PLAT2_CLR	0x00C0392B 	# Color for moving solid platform

# Calculate display position: (y * 2^9 + x * 2^2) 
.data
newLine:  	.asciiz "\n"	# Newline Character
# PLAYER DATA
CHR_POS:	.word	3, 57	# General Player Position Array (x, y)
CHR_TOP:	.word	56	# The y-position of Player's top pixel relative to DISPLAY
CHR_BOT:	.word	60	# The y-position of Player's bot pixel relative to DISPLAY
CHR_DIR:	.word	2, 4	# The x-positions of Player's left and right pixels relative to DISPLAY (left-x, right-x)
CHR_MAXJUMP:	.word	1	# The maximum jump for the Player
CHR_JUMP:	.word	1	# The current jump for the player
CHR_GROUND:	.word	0 	# Value of how far the character is above ground
CHR_FALL:	.word	0	# The falling velocity for the Player
CHR_MIDJUMP:	.word	0 	# 1 if in jump state, 0 otherwise
CHR_JUMPVELO:	.word	1 	# Jumping incremental velocity
CHR_JUMPTIME:	.word	4	# How long a jump state lasts
CHR_SCORE:	.word	0	# Player score
CHR_POWER:	.word	-1	# Player power
PIXEL_HOLD:	.space	44	# Player's pixels to hold on drawn, used for when player moves we redraw
# DRAWING ARRAY 
DRAW_POS0: 	.space  8 	# An array of 2 integers for drawing (x, y)
DRAW_POS1:	.space	8 	# An second array for drawing (x, y)
# COLLISION MAP ARRAY
COLLISION_MAP:	.space	8192 	# 128 * 64 = 8192, a 8192 byte collision map
# Collision Map Mapping:
# 0 - Background/Nothing
# 1 - Solid
# 2 - Platform
# 3 - Enemy
# 4 - Coin
# 5 - PICKUP
# 6 - Solid Moving Platform
# 7 - Moving Platform
#=======================
# COIN DATA
COIN_POS:	.space	8 	# Coin coordinate position (x, y)
COIN_STATE:	.word	0 	# 0 untouched, 1 hover
COIN_TIMER:	.word	5	# Coin timer until state change
COIN_PREV:	.word	-1	# Previous coin location, tracked to prevent randomized spawning spawn coin at same spot
# POWERUP DATA
PICKUP_PREV:	.word	-1	# Previous pickup location, tracked to prevent randomized spawning spawn pickup at same spot
PICKUP_POS:	.space	8	# Pickup coordinate position (x, y)
PICKUP_STATE:	.word	1 	# 0 untouched, 1 hover
PICKUP_TIMER:	.word	5	# Pickup timer until state change
PICKUP_TYPE:	.word	-1 	# The Current powerup type
# Powerup Mapping:
# 0 - Double Jump
# 1 - Higher Jump
# 2 - Build Platform below
# 3 - Teleport to Coin
#======================
# MOVING PLATFORM DATA
MOVE_PLAT1:	.space	12 	# array of 3 integers for position (x, y) of moving platform, 3rd index for length of platform
PLAT1_DIR:	.word	0 	# 0 to go left, 1 to go right
# SOLID MOVING PLATFORM DATA
MOVE_PLAT2:	.space	12 	# array of 3 integers for position (x, y) of moving platform, 3rd index for length of platform
PLAT2_DIR:	.word	1 	# 0 to go left, 1 to go right
# MONSTER DATA
MONSTER:	.space	8 	# array of 2 integers for moving monster feet left (x, y)
MON_DIR:	.word	0	# 0 to go left, 1 to go right
# UTILITY BAR DATA
BAR_POS:	.word	516	# Stores the calculated position of the scorebar for incrementing score
.text
.globl main
main:
# =======================
#	MAIN MENU
# =======================
# -------MENU--------
# Draws the main menu for the game
entryScreen:
	li $t9, 67
	sw $t9, CHR_POS
	li $t9, 14
	sw $t9, CHR_POS + 4
	li $a2, 0
	li $a1, 7
	jal clearScreen
	li $a0, CLR_WHITE
	jal drawCol
	li $a1, 120
	jal drawCol
	li $a1, 112
	li $t9, 22
	sw $t9, DRAW_POS0 + 4
	li $t9, 7
	sw $t9, DRAW_POS0
	jal drawPlatform
# Draws a big T for the menu title
drawBigT:
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	li $t9, 50
	sw $t9, DRAW_POS0
	li $a1, 5
	jal drawPlatform
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 52
	sw $t9, DRAW_POS0
	li $t9, 5
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawVertical
	li $t9, 53
	sw $t9, DRAW_POS0
	jal drawVertical
# Draws a big I for the menu title
drawBigI:
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawPlatform
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 60
	sw $t9, DRAW_POS0
	li $t9, 5
	sw $t9, DRAW_POS0 + 4
	li $a1, 1
	jal drawVertical
	li $t9, 61
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 7
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawPlatform
	li $t9, 8
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
# Draws a big N for the menu title
drawBigN:
	li $t9, 66
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $t9, 67
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 2
	li $t9, 68
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 69
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 70
	sw $t9, DRAW_POS0
	li $t9, 5
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 71
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $t9, 72
	sw $t9, DRAW_POS0
	jal drawVertical
# Draws a big Y for the menu title
drawBigY:
	li $t9, 75
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawVertical
	li $t9, 76
	sw $t9, DRAW_POS0
	li $a1, 3
	jal drawVertical
	li $t9, 77
	sw $t9, DRAW_POS0
	li $t9, 5
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 78
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 79
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $a1, 2
	li $t9, 80
	sw $t9, DRAW_POS0
	jal drawVertical
# Draws a big G for the menu title
drawBigG:
	li $t9, 48
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawVertical
	li $t9, 49
	sw $t9, DRAW_POS0
	li $t9, 11
	sw $t9, DRAW_POS0 + 4
	li $a1, 6
	jal drawVertical
	li $t9, 50
	sw $t9, DRAW_POS0
	li $t9, 11
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawPlatform
	li $t9, 51
	sw $t9, DRAW_POS0
	li $t9, 14
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	li $t9, 15
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 52
	sw $t9, DRAW_POS0
	li $t9, 16
	sw $t9, DRAW_POS0 + 4
	li $a1, 1
	jal drawPlatform
	li $t9, 50
	sw $t9, DRAW_POS0
	li $t9, 17
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
# Draws a big H for the menu title
drawBigH:
	li $t9, 56
	sw $t9, DRAW_POS0
	li $t9, 11
	sw $t9, DRAW_POS0 + 4
	li $a1, 6
	jal drawVertical
	li $t9, 57
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 58
	sw $t9, DRAW_POS0
	li $a1, 1
	li $t9, 14
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 15
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 60
	sw $t9, DRAW_POS0
	li $t9, 11
	sw $t9, DRAW_POS0 + 4
	li $a1, 6
	jal drawVertical
	li $t9, 61
	sw $t9, DRAW_POS0
	jal drawVertical
# Draws a big O for the menu title
drawBigO:
	la $a0, CLR_GRAY
	li $t9, 64
	sw $t9, DRAW_POS0
	li $a1, 2
	li $t9, 13
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 65
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawVertical
	li $t9, 69
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 70
	sw $t9, DRAW_POS0
	li $a1, 2
	li $t9, 13
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 66
	sw $t9, DRAW_POS0
	li $t9, 11
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 16
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 17
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	jal drawChr # Draws the character inside the O :) fun 
# Draws a big U for menu title
drawBigU:
	la $a0, CLR_WHITE
	li $t9, 73
	sw $t9, DRAW_POS0
	li $t9, 11
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $a1, 6
	li $t9, 74
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 76
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 5
	li $t9, 77
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 16
	sw $t9, DRAW_POS0 + 4
	li $t9, 75
	sw $t9, DRAW_POS0
	li $a1, 1
	jal drawVertical
# Draws a big L for menu title
drawBigL:
	li $t9, 80
	sw $t9, DRAW_POS0
	li $t9, 11
	sw $t9, DRAW_POS0 + 4
	li $a1, 6
	jal drawVertical
	li $t9, 81
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 82
	sw $t9, DRAW_POS0
	li $t9, 16
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	li $t9, 17
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
# Draws a small S for the selections on main menu
drawSmallS:
	li $t9, 53
	sw $t9, DRAW_POS0
	li $t9, 35
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawPlatform
	jal drawVertical
	li $t9, 38
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 41
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 38
	sw $t9, DRAW_POS0 + 4
	li $t9, 56
	sw $t9, DRAW_POS0
	jal drawVertical
# Draws a small T for the selections on main menu
drawSmallT:
	li $t9, 58
	sw $t9, DRAW_POS0
	li $t9, 35
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawPlatform
	li $t9, 60
	sw $t9, DRAW_POS0
	li $a1, 6
	jal drawVertical
# Draws a small A for the selection on main menu
drawSmallA:
	li $t9, 64
	sw $t9, DRAW_POS0
	li $t9, 36
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $t9, 67
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 1
	li $t9, 65
	sw $t9, DRAW_POS0
	li $t9, 35
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 38
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
# Draws a small T for the selection on main menu
drawAnotherSmallT:
	li $t9, 74
	sw $t9, DRAW_POS0
	li $t9, 35
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawPlatform
	li $t9, 76
	sw $t9, DRAW_POS0
	li $a1, 6
	jal drawVertical
# Draws a small R for the selection on main menu
drawSmallR:
	li $t9, 69
	sw $t9, DRAW_POS0
	li $t9, 36
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $a1, 1
	li $t9, 70
	sw $t9, DRAW_POS0
	li $t9, 35
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 38
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 72
	sw $t9, DRAW_POS0
	li $t9, 36
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawVertical
	li $t9, 40
	li $a1, 1
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 39
	li $a1, 0
	sw $t9, DRAW_POS0 + 4
	li $t9, 71
	sw $t9, DRAW_POS0
	jal drawPlatform
# Draws a small Q for the selection on main menu
drawSmallQ:
	li $t9, 58
	sw $t9, DRAW_POS0
	li $t9, 50
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawVertical
	li $t9, 55
	sw $t9, DRAW_POS0
	li $t9, 50
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 56
	sw $t9, DRAW_POS0
	li $t9, 49
	sw $t9, DRAW_POS0 + 4
	li $a1, 1
	jal drawPlatform
	li $t9, 55
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 0
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 53
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 55
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
# Draws a small U for the selection on main menu
drawSmallU:
	li $t9, 61
	sw $t9, DRAW_POS0
	li $t9, 49
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $t9, 64
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 62
	sw $t9, DRAW_POS0
	li $t9, 55
	sw $t9, DRAW_POS0 + 4
	li $a1, 1
	jal drawPlatform
# Draws a small I and T for the selection on main menu
drawSmallIT:
	li $t9, 66
	sw $t9, DRAW_POS0
	li $t9, 49
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	li $t9, 55
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 50
	sw $t9, DRAW_POS0 + 4
	li $t9, 67
	sw $t9, DRAW_POS0
	li $a1, 4
	jal drawVertical
	li $t9, 70
	sw $t9, DRAW_POS0
	li $t9, 49
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawPlatform
	li $t9, 72
	sw $t9, DRAW_POS0
	li $a1, 6
	jal drawVertical
	
	li $t9, 51
	sw $t9, DRAW_POS0
	li $t9, 33
	sw $t9, DRAW_POS0 + 4
	li $a1, 29
	jal drawPlatform
	li $t9, 43
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 34
	sw $t9, DRAW_POS0 + 4
	li $a1, 8
	jal drawVertical
	li $t9, 80
	sw $t9, DRAW_POS0
	jal drawVertical
	
	li $s1, 1
# A loop for the main menu in order to select whether user wishes to START or QUIT (F to select)
menuLoop:
	lw $t9, KEYBOARD
	beqz $t9, menuLoop
	lw $t9,	0xFFFF0004
	la $t8, KEY_W
	beq $t9, $t8, chooseUp
	la $t8, KEY_S
	beq $t9, $t8, chooseDown
	la $t8, KEY_F
	beq $t9, $t8, pickSelection
	la $t8, KEY_P
	beq $t9, $t8, reset
	j menuLoop
# A function for highlighting the START choice on pressing W/UP
chooseUp:
	beq $s1, 1, menuLoop
	la $a0, CLR_WHITE
	li $t9, 51
	sw $t9, DRAW_POS0
	li $t9, 33
	sw $t9, DRAW_POS0 + 4
	li $a1, 29
	jal drawPlatform
	li $t9, 43
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 34
	sw $t9, DRAW_POS0 + 4
	li $a1, 8
	jal drawVertical
	li $t9, 80
	sw $t9, DRAW_POS0
	jal drawVertical
	
	la $a0, CLR_BLACK
	li $t9, 51
	sw $t9, DRAW_POS0
	li $t9, 47
	sw $t9, DRAW_POS0 + 4
	li $a1, 29
	jal drawPlatform
	li $t9, 57
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 48
	sw $t9, DRAW_POS0 + 4
	li $a1, 8
	jal drawVertical
	li $t9, 80
	sw $t9, DRAW_POS0
	jal drawVertical
	addi $s1, $zero, 1
	j menuLoop
# A function for highlighting the QUIT choice on pressing S/DOWN
chooseDown:
	beq $s1, 0, menuLoop
	la $a0, CLR_BLACK
	li $t9, 51
	sw $t9, DRAW_POS0
	li $t9, 33
	sw $t9, DRAW_POS0 + 4
	li $a1, 29
	jal drawPlatform
	li $t9, 43
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 34
	sw $t9, DRAW_POS0 + 4
	li $a1, 8
	jal drawVertical
	li $t9, 80
	sw $t9, DRAW_POS0
	jal drawVertical
	
	la $a0, CLR_WHITE
	li $t9, 51
	sw $t9, DRAW_POS0
	li $t9, 47
	sw $t9, DRAW_POS0 + 4
	li $a1, 29
	jal drawPlatform
	li $t9, 57
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 48
	sw $t9, DRAW_POS0 + 4
	li $a1, 8
	jal drawVertical
	li $t9, 80
	sw $t9, DRAW_POS0
	jal drawVertical
	add $s1, $zero, $zero
	j menuLoop
# A function to navigate based on the selection after pressing F
pickSelection:
	beq $s1, 1, drawStage
	jal clearScreen
	j Exit
# ================================
#	POST GAME HELPER FUNCTIONS
# ================================
# A slow animation closing on winning or losing the game
slowAnimation:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	add $s1, $zero, $zero
	addi $s2, $zero, 63
	addi $a2, $zero, 0
# A animation loop for finishing the game by drawing black from top to bottom and bottom to top at same time
animationLoop:
	bge $s1, 63, Return
	la $a0, CLR_BLACK
	add $a1, $s1, $zero
	jal drawRow
	add $a1, $s2, $zero
	jal drawRow
	addi $s1, $s1, 1
	subi $s2, $s2, 1
	jal animationDelay
	j animationLoop
# A sleep system delay to make the animation look less instantenous
animationDelay:
	li $v0, 32
	li $a0, 30
	syscall
	jr $ra
# =======================
#	POST GAME
# =======================
# -------WIN GAME--------
# Function for showing the win game screen
winGame:
	jal slowAnimation # performs a closing animation
	# Draws the rest of the outline of the winGame screen
	li $a2, 0
	li $a1, 7
	li $a0, CLR_WHITE
	jal drawCol
	li $a1, 120
	jal drawCol
	li $a1, 112
	li $t9, 22
	sw $t9, DRAW_POS0 + 4
	li $t9, 7
	sw $t9, DRAW_POS0
	jal drawPlatform
	li $t9, 16452
	sw $t9, BAR_POS
	# Draws the "YOU WIN" phrase
	li $t9, 55
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawVertical
	li $t9, 57
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 56
	sw $t9, DRAW_POS0
	li $t9, 8
	sw $t9, DRAW_POS0 + 4
	li $a1, 1
	jal drawVertical
	
	li $t9, 62
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $a1, 1
	jal drawPlatform
	li $t9, 9
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 64
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	
	li $t9, 68
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $t9, 70
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 68
	sw $t9, DRAW_POS0
	li $t9, 9
	sw $t9, DRAW_POS0 + 4
	li $a1, 1
	jal drawPlatform
	
	li $t9, 54
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawVertical
	li $t9, 58
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 56
	sw $t9, DRAW_POS0
	li $t9, 13
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawVertical
	li $t9, 55
	sw $t9, DRAW_POS0
	li $t9, 16
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	li $t9, 57
	sw $t9, DRAW_POS0
	jal drawDot

	li $t9, 62
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	li $t9, 16
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 63
	sw $t9, DRAW_POS0
	li $t9, 13
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	
	li $t9, 67
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawVertical
	li $t9, 71
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 68
	sw $t9, DRAW_POS0
	li $t9, 13
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	li $t9, 69
	sw $t9, DRAW_POS0
	li $t9, 14
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	li $t9, 70
	sw $t9, DRAW_POS0
	li $t9, 15
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	# Draws the endgame scorebar
	jal drawPostScorebar
	# Goes to the loop for post game
	j endLoop
	
# -------GAME OVER--------
# Function for drawing the game over screen
gameOver:
	jal slowAnimation #Slow closing animation
	# Draws the gameOver screen layout
	li $a2, 0
	li $a1, 7
	li $a0, CLR_WHITE
	jal drawCol
	li $a1, 120
	jal drawCol
	li $a1, 112
	li $t9, 22
	sw $t9, DRAW_POS0 + 4
	li $t9, 7
	sw $t9, DRAW_POS0
	jal drawPlatform
	li $t9, 16452
	sw $t9, BAR_POS
	# Draws the "GAME OVER" phrase on screen
	la $a0, CLR_WHITE
	li $t9, 51
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawVertical
	li $t9, 52
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 2
	li $t9, 8
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 1
	li $t9, 55
	sw $t9, DRAW_POS0
	li $t9, 6
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $a1, 0
	li $t9, 54
	sw $t9, DRAW_POS0
	li $t9, 6
	jal drawPlatform
	
	li $t9, 58
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawVertical
	li $t9, 61
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 1
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 6
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	li $t9, 64
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $t9, 70
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 0
	li $t9, 69
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 68
	sw $t9, DRAW_POS0
	li $t9, 5
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 67
	sw $t9, DRAW_POS0
	li $t9, 6
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 66
	sw $t9, DRAW_POS0
	li $t9, 5
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 65
	sw $t9, DRAW_POS0
	li $t9, 4
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	li $t9, 73
	sw $t9, DRAW_POS0
	li $t9, 3
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $a1, 3
	jal drawPlatform
	li $a1, 2
	li $t9, 5
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 3
	li $t9, 8
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	li $t9, 52
	sw $t9, DRAW_POS0
	li $t9, 13
	sw $t9, DRAW_POS0 + 4
	li $a1, 3
	jal drawVertical
	li $t9, 56
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 2
	li $t9, 53
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 17
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 63
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 1
	li $t9, 60
	sw $t9, DRAW_POS0
	li $t9, 15
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 62
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 0
	li $t9, 61
	sw $t9, DRAW_POS0
	li $t9, 17
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	li $t9, 66
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $a1, 3
	jal drawPlatform
	li $a1, 2
	li $t9, 14
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 3
	li $t9, 17
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	li $t9, 72
	sw $t9, DRAW_POS0
	li $t9, 12
	sw $t9, DRAW_POS0 + 4
	li $a1, 5
	jal drawVertical
	li $a1, 2
	jal drawPlatform
	li $t9, 15
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 1
	li $t9, 75
	sw $t9, DRAW_POS0
	li $t9, 13
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $a1, 0
	li $t9, 74
	sw $t9, DRAW_POS0
	li $t9, 16
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 75
	sw $t9, DRAW_POS0
	li $t9, 17
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	# Draws the endgame scorebar
	jal drawPostScorebar
	# Goes to the loop for post game
# A post game loop to wait for the player to press P to return to main menu
endLoop:
	lw $t9, KEYBOARD 	# loads the keyboard address
	beqz $t9, endLoop 	# reloop if no keyboard input
	lw $t9,	0xFFFF0004 	# Load the ascii 
	la $t8, KEY_P 		# Load ascii P in register
	beq $t9, $t8, reset 	# Check the key are equals if so reset
	j endLoop		# Reloop incase they pressed other keys
# A label that simply resets/ jumps to the beginning of the entire program
reset:
	j entryScreen # jump to main menu
# Function draws the scorebar for post game screens. It shows the scorebar
drawPostScorebar:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	# Draws the phrase "SCORE" on screen
	la $a0, CLR_WHITE
	li $t9, 54
	sw $t9, DRAW_POS0
	li $t9, 25
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	jal drawVertical
	li $t9, 27
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 29
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 56
	sw $t9, DRAW_POS0
	li $t9, 27
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	
	li $t9, 58
	sw $t9, DRAW_POS0
	li $t9, 25
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 4
	jal drawVertical
	li $a1, 2
	li $t9, 29
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	li $a1, 4
	li $t9, 62
	sw $t9, DRAW_POS0
	li $t9, 25
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $a1, 3
	jal drawPlatform
	li $t9, 29
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 4
	li $t9, 65
	sw $t9, DRAW_POS0
	li $t9, 25
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	
	li $a1, 4
	li $t9, 67
	sw $t9, DRAW_POS0
	li $t9, 25
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $a1, 2
	jal drawPlatform
	li $t9, 69
	sw $t9, DRAW_POS0
	jal drawVertical
	li $t9, 67
	sw $t9, DRAW_POS0
	li $t9, 27
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 0
	li $t9, 68
	sw $t9, DRAW_POS0
	li $t9, 28
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 69
	sw $t9, DRAW_POS0
	li $t9, 29
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	li $a1, 4
	li $t9, 71
	sw $t9, DRAW_POS0
	li $t9, 25
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $a1, 2
	jal drawPlatform
	li $t9, 29
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 27
	sw $t9, DRAW_POS0 + 4
	li $a1, 1
	jal drawPlatform
	
	li $a1, 0
	li $t9, 75
	sw $t9, DRAW_POS0
	li $t9, 25
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 75
	sw $t9, DRAW_POS0
	li $t9, 29
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	
	# Draws the actual scorebar but empty
	la $a0, CLR_SCORE_EMP
	lw $t8, BAR_POS
	addi $t9, $t8, 360
	srl $t7, $t8, 2
	jal adapterDrawLoop
	lw $t8, BAR_POS
	addi $t8, $t8, 512
	addi $t9, $t8, 360
	srl $t7, $t8, 2
	jal adapterDrawLoop
	lw $t8, BAR_POS
	addi $t8, $t8, 1024
	addi $t9, $t8, 360
	srl $t7, $t8, 2
	jal adapterDrawLoop
	lw $t8, BAR_POS
	addi $t8, $t8, 1536
	addi $t9, $t8, 360
	srl $t7, $t8, 2
	jal adapterDrawLoop
	la $a0, CHR_EYE
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 1024
	sw $a0, DISPLAY($t9)
	la $a0, CLR_WHITE
	subi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 1024
	sw $a0, DISPLAY($t9)
	# Drawing coin icon
	subi $t9, $t9, 500
	la $a0, COIN_EDGE
	sw $a0, DISPLAY($t9)
	
	la $a0, COIN_CORE
	
	addi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	
	addi $t9, $t9, 508
	sw $a0, DISPLAY($t9)
	
	addi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	
	# Draws a big P underneath the scorebar to indicate to press P
	la $a0, CLR_WHITE
	li $t9, 61
	sw $t9, DRAW_POS0
	li $t9, 49
	sw $t9, DRAW_POS0 + 4
	li $a1, 7
	jal drawVertical
	li $a1, 3
	jal drawPlatform
	li $t9, 53
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 2
	li $t9, 65
	sw $t9, DRAW_POS0
	li $t9, 50
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	
	# Draws the character to the next of "SCORE" text
	li $t9, 50
	sw $t9, CHR_POS
	li $t9, 27
	sw $t9, CHR_POS + 4
	jal drawChr
	# Fills the scorebar based of the player's score
	jal drawPostScore
	# Shows the numerical value of the player's score
	jal showScore
	# Returns the function
	j Return
# Draws the numerical score out of 10
showScore:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	# Draws "/10" on screen
	la $a0, CLR_WHITE
	li $t9, 67
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawVertical

	li $a1, 4
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 69
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 1
	jal drawPlatform
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 4
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 71
	sw $t9, DRAW_POS0
	jal drawVertical
	# Draws the "/"
	li $a1, 0
	li $t9, 65
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	li $t9, 64
	sw $t9, DRAW_POS0
	li $t9, 43
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	li $t9, 63
	sw $t9, DRAW_POS0
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	li $t9, 62
	sw $t9, DRAW_POS0
	li $t9, 45
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	li $t9, 61
	sw $t9, DRAW_POS0
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	# Loads the Player score and draws the number according to the player score
	lw $t9, CHR_SCORE
	beqz $t9, draw0Score # draw 0
	beq $t9, 1, draw1Score # draw 1
	beq $t9, 2, draw2Score # draw 2
	beq $t9, 3, draw3Score # draw 3
	beq $t9, 4, draw4Score # draw 4
	beq $t9, 5, draw5Score # draw 5
	beq $t9, 6, draw6Score # draw 6
	beq $t9, 7, draw7Score # draw 7
	beq $t9, 8, draw8Score # draw 8
	beq $t9, 9, draw9Score # draw 9
	beq $t9, 10, draw10Score # draw 10
# Draws a literal 0 before /10
draw0Score:
	li $a1, 4
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 57
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 1
	jal drawPlatform
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 4
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 59
	sw $t9, DRAW_POS0
	jal drawVertical
	j Return
# Draws a literal 1 before /10
draw1Score:
	li $a1, 4
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 57
	sw $t9, DRAW_POS0
	jal drawVertical
	j Return
# Draws a literal 2 before /10
draw2Score:
	li $a1, 2
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 57
	sw $t9, DRAW_POS0
	jal drawPlatform
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	j Return
# Draws a literal 3 before /10
draw3Score:
	li $a1, 2
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 57
	sw $t9, DRAW_POS0
	jal drawPlatform
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 0
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	li $t9, 58
	sw $t9, DRAW_POS0
	jal drawDot
	li $a1, 3
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 59
	sw $t9, DRAW_POS0
	jal drawVertical
	j Return
# Draws a literal 4 before /10
draw4Score:
	li $a1, 2
	li $t9, 56
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $a1, 4
	li $t9, 58
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 3
	li $t9, 56
	sw $t9, DRAW_POS0
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	j Return
# Draws a literal 5 before /10
draw5Score:
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	jal drawVertical
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 1
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 45
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	j Return
# Draws a literal 6 before /10
draw6Score:
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	jal drawVertical
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 1
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 45
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 45
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	j Return
# Draws a literal 7 before /10
draw7Score:
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	li $a1, 4
	li $t9, 59
	sw $t9, DRAW_POS0
	jal drawVertical
	j Return
# Draws a literal 8 before /10
draw8Score:
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	jal drawVertical
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 1
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 45
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 45
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 43
	sw $t9, DRAW_POS0 + 4
	jal drawDot
	j Return
# Draws a literal 9 before /10
draw9Score:
	li $t9, 57
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $a1, 2
	jal drawPlatform
	jal drawVertical
	li $t9, 44
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 4
	li $t9, 59
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	jal drawVertical
	j Return
# Draws a literal 10 before /10
draw10Score:
	li $t9, 55
	sw $t9, DRAW_POS0
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $a1, 4
	jal drawVertical

	li $a1, 4
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 57
	sw $t9, DRAW_POS0
	jal drawVertical
	li $a1, 1
	jal drawPlatform
	li $t9, 46
	sw $t9, DRAW_POS0 + 4
	jal drawPlatform
	li $a1, 4
	li $t9, 42
	sw $t9, DRAW_POS0 + 4
	li $t9, 59
	sw $t9, DRAW_POS0
	jal drawVertical
	j Return
# Fills the scorebar in the post game screens with actual player score
drawPostScore:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	lw $s0, CHR_SCORE
	li $s1, 1
# A loop to fill it up, 9 lines at a time
drawPostScoreLoop:
	bgt $s1, $s0, Return
	jal increaseScorebar
	addi $s1, $s1, 1
	jal barDelay
	j drawPostScoreLoop
# A delay for the loop for making an animation for filling the scorebar
barDelay:
	li $v0, 32
	li $a0, 100
	syscall
	jr $ra
# Calculates the CHR_BOT, CHR_DIR, CHR_TOP based off the CHR_POS
relativeChrPos:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	lw $t9, CHR_POS
	lw $t8, CHR_POS + 4
	addi $t9, $t9, 1
	sw $t9, CHR_DIR + 4
	subi $t9, $t9, 2
	sw $t9, CHR_DIR
	subi $t8, $t8, 1
	sw $t8, CHR_TOP
	addi $t8, $t8, 3
	sw $t8, CHR_BOT
	j Return
# Loads the position of $s0, $s1 into DRAW0_POS for easier call on drawing functions
loadPosition:
	sw $s0, DRAW_POS0	
	sw $s1, DRAW_POS0 + 4
	jr $ra
# Draws the stage for the game
drawStage:
	jal drawBG # draws the background
	li $t9, -1
	sw $t9, CHR_POWER # sets the player's power to none
	addi $t9, $zero, 516 
	sw $t9, BAR_POS # resets the bar position
	jal drawUtilBar # draws the utility bar
	# draws the ground
	la $a0, CLR_BROWN
	li $a2, 1
	li $a1, 63
	jal drawRow
	li $a1, 62
	jal drawRow
	li $a1, 61
	jal drawRow
	la $a0, CLR_GREEN
	li $a1, 60
	jal drawRow
	la $a0, CLR_DRKGRAY
	li $a1, 22
	li $s0, 105
	li $s1, 60
	jal loadPosition
	jal drawPlatform
	# draws some platforms
	subi $a1, $a1, 1
	addi $s0, $s0, 1
	subi $s1, $s1, 1
	jal loadPosition
	jal drawPlatform
	subi $a1, $a1, 4
	addi $s0, $s0, 4
	subi $s1, $s1, 1
	jal loadPosition
	jal drawPlatform
	subi $s1, $s1, 9
	jal loadPosition
	jal drawPlatform
	la $a0, CLR_ORANGE
	li $a2, 2
	li $a1, 6
	li $s0, 101
	li $s1, 53
	jal loadPosition
	jal drawPlatform
	subi $s0, $s0, 6
	subi $s1, $s1, 4
	subi $a1, $a1, 1
	jal loadPosition
	jal drawPlatform
	li $a1, 42
	jal drawRow
	la $a0, CLR_DRKGRAY
	li $a2, 1
	li $s0, 12
	li $s1, 42
	li $a1, 9
	jal loadPosition
	jal drawVertical
	addi $s1, $s1, 9
	li $s0, 0
	li $a1, 11
	jal loadPosition
	jal drawPlatform
	la $a0, CLR_ROSE
	li $s0, 58
	li $s1, 34
	li $a1, 14
	jal loadPosition
	jal drawPlatform
	subi $s0, $s0, 58
	jal loadPosition
	jal drawPlatform
	la $a0, CLR_ORANGE
	li $a2, 2
	li $s0, 75
	li $s1, 36
	li $a1, 5
	jal loadPosition
	jal drawPlatform
	la $a0, CLR_ROSE
	li $a2, 1
	li $s0, 117
	li $s1, 36
	li $a1, 10
	jal loadPosition
	jal drawPlatform
	la $a0, CLR_ORANGE
	li $s0, 50
	li $s1, 47
	li $a1, 5
	li $a2, 2
	jal loadPosition
	jal drawPlatform
	li $s0, 117
	li $s1, 29
	li $a1, 4
	li $a2, 1
	la $a0, CLR_ROSE
	jal loadPosition
	jal drawPlatform
	li $s1, 6
	li $s0, 28
	li $a1, 8
	jal loadPosition
	jal drawVertical
	li $s0, 40
	jal loadPosition
	jal drawVertical
	li $s1, 14
	li $s0, 30
	la $a0, CLR_ORANGE
	li $a2, 2
	jal loadPosition
	jal drawPlatform
	li $s1, 20
	li $s0, 0
	jal loadPosition
	jal drawDot
	li $s1, 12
	jal loadPosition
	jal drawDot
	li $s1, 13
	la $a0, CLR_ROSE
	li $a2, 1
	li $s0, 4
	jal loadPosition
	jal drawPlatform
	li $s1, 15
	la $s0, 15
	jal loadPosition
	jal drawPlatform
	li $s0, 111
	li $s1, 25
	li $a2, 2
	la $a0, CLR_ORANGE
	jal loadPosition
	jal drawPlatform
	li $s1, 15
	li $s0, 80
	jal loadPosition
	jal drawPlatform
	li $a2, 1
	li $s1, 14
	li $s0, 89
	la $a0, CLR_ROSE
	li $a1, 38
	jal loadPosition
	jal drawPlatform
	li $a1, 12
	la $a0, CLR_ORANGE
	li $s1, 15
	li $s0, 52
	li $a2, 2
	jal loadPosition
	jal drawPlatform
	# Resets the coin and pickup's previous location number to none
	# This section also resets all the platform direction movement and monster direction movement
	li $t9, -1
	sw $t9, COIN_PREV
	sw $t9, PICKUP_PREV
	addi $t9, $t9, 2
	sw $t9, PICKUP_STATE
	sw $t9, PLAT2_DIR
	subi $t9, $t9, 1
	sw $t9, PLAT1_DIR
	sw $t9, COIN_STATE
	sw $t9, MON_DIR
	# Places the solid moving platform 2
	li $t9, 32
	sw $t9, MOVE_PLAT2
	li $t9, 34
	sw $t9, MOVE_PLAT2 + 4
	li $t9, 6
	sw $t9, MOVE_PLAT2 + 8
	jal drawMovePlat2
	# Places the moving platform 1
	li $t9, 63
	sw $t9, MOVE_PLAT1
	li $t9, 21
	sw $t9, MOVE_PLAT1 + 4
	li $t9, 8
	sw $t9, MOVE_PLAT1 + 8
	jal drawMovePlat1
	# Places the monster
	li $t9, 63
	sw $t9, MONSTER
	li $t9, 41
	sw $t9, MONSTER + 4
	jal drawMon
	# Resets pickup and coin state change timer
	addi $t9, $zero, 5
	sw $t9, COIN_TIMER
	sw $t9, PICKUP_TIMER
# Resets all data related to the character to the default values
resetChr:
	addi $t8, $zero, 3
	sw $t8, CHR_POS # Reset player x value
	addi $t8, $zero, 57 
	sw $t8, CHR_POS + 4 # Reset player y value
	jal relativeChrPos # Calculate the relative player position and sets the CHR_TOP, CHR_DIR, CHR_BOT
	sw $zero, CHR_MIDJUMP # Reset state of whether character is jumping
	sw $zero, CHR_FALL # Reset fall velocity
	sw $zero, CHR_GROUND # Reset the height above ground
	li $t9, 1
	sw $t9, CHR_MAXJUMP # Reset maximum number of jump
	sw $t9, CHR_JUMP # Reset number of jumps
	sw $t9, CHR_JUMPVELO # Reset jump velocity
	li $t9, 4
	sw $t9, CHR_JUMPTIME # Resets the jump time
	sw $zero, CHR_SCORE # Reset score to 0
	li $t9, -1
	sw $t9, CHR_POWER # Reset player power to none
	jal randomizeSpawnCoin # Randomly spawn a coin
	jal randomizePower # Randomly spawn a powerup core
	jal drawChr # draws the player
# Loads the different player datas into the different registers
stateLoad:
	lw $s7, CHR_POS
	lw $s6, CHR_POS + 4
	lw $s5, CHR_BOT
	lw $s4, CHR_TOP
	lw $s3, CHR_DIR
	lw $s2, CHR_DIR + 4
	lw $s1, CHR_FALL
# A control loop for player controls
controlLoop:
	lw $t9, KEYBOARD
	beqz $t9, noInput # If the keyboard has no input
# Checks the different control keys
control:
	lw $t9,	0xFFFF0004
	# w key check (jumps up)
	la $t8, KEY_W
	beq $t9, $t8, moveUp
	# a key check (moves left)
	la $t8, KEY_A
	beq $t9, $t8, moveLeft
	# d key check (moves right)
	la $t8, KEY_D
	beq $t9, $t8, moveRight
	# s key check (moves down)
	la $t8, KEY_S
	beq $t9, $t8, moveDown
	# f key check (uses the power)
	la $t8, KEY_F
	beq $t9, $t8, usePower
	# p key check (reset the game)
	la $t8, KEY_P
	beq $t9, $t8, reset
	j noInput # assume no input if no valid key was reached
# Jumping up behavior on W key press
moveUp:
	lw $t8, CHR_JUMP 	# check current number of jumps
	beqz $t8, noInput 	# if player has no jump then we don't do anything
	addi $t9, $zero, 1
	sw $t9, CHR_MIDJUMP 	# enable player jump state
	lw $s0, CHR_JUMPTIME 	# load jumptime
	lw $s1, CHR_JUMPVELO 	# load jump velocity
	sub $t8, $t8, 1
	sw $t8, CHR_JUMP 	# remove 1 jump from player
	j noInput 		# jumps to noInput for all other none control related behavior
# Moving down behavior on S key press
moveDown:
	add $t8, $zero, $s5
	addi $t8, $t8, 1
	# Load player's bottom position + 1 for checking the collision map details
	sw $t8, DRAW_POS0 + 4
	add $t8, $zero, $s2
	sw $t8, DRAW_POS0
	add $a0, $zero, $zero
	jal computePos
	add $t6, $zero, $t9
	addi $sp, $sp, 4
	srl $t6, $t6, 2 # middle bottom pixel
	subi $t7, $t6, 1 # left bottom pixel
	subi $t8, $t7, 1 # right bottom pixel
	# Checks all 3 pixels below the player's feet to see if all of them are soft platforms if so we can beneath that platform
	lb $t3, COLLISION_MAP($t6)
	lb $t4, COLLISION_MAP($t7)
	lb $t5, COLLISION_MAP($t8)
	beq $t3, 1, noInput
	beq $t4, 1, noInput
	beq $t5, 1, noInput
	beq $t3, 6, noInput
	beq $t4, 6, noInput
	beq $t5, 6, noInput
	# If the checks were all passed then we go down the platform
	jal drawPast
	addi $s4, $s4, 2
	sw $s4, CHR_TOP
	addi $s5, $s5, 2
	sw $s5, CHR_BOT
	addi $s6, $s6, 2
	sw $s6, CHR_POS + 4
	jal drawChr
	j noInput
# Moving left behavior on A key press
moveLeft:
	# Moves player left if player hasn't reached the screen boundary and the player isn't moving towards a solid wall
	beqz $s3, noInput # checks for boundary
	jal checkCollideLeft # checks for solid wall
	# If so move left
	jal drawPast
	subi $s3, $s3, 1
	sw $s3, CHR_DIR
	subi $s2, $s2, 1
	sw $s2, CHR_DIR + 4
	subi $s7, $s7, 1
	sw $s7, CHR_POS
	jal drawChr
	j noInput
# Moving right behavior on D key press
moveRight:
	# Moves player right if player hasn't reached the right screen boundary and the player isn't moving towards a solid wall
	beq $s2, 127, noInput # checks for the boundary
	jal checkCollideRight # checks for solid wall
	# If so move right
	jal drawPast
	addi $s3, $s3, 1
	sw $s3, CHR_DIR
	addi $s2, $s2, 1
	sw $s2, CHR_DIR + 4
	addi $s7, $s7, 1
	sw $s7, CHR_POS
	jal drawChr
	j noInput
# Utilizing player's held powers on F key press
usePower:
	lw $t1, CHR_POWER
	bltz $t1, noInput # Do nothing if the player has no power (CHR_POWER = -1) 
	addi $t8, $zero, -1
	sw $t8, CHR_POWER
	# Redraw the power section on the utility bar at the top since we just used a held power
	jal drawUtilPowerAdapter
	beqz $t1, power0 # use power0 if we have
	beq $t1, 1, power1 # use power1 if we have
	beq $t1, 2, power2 # use power2 if we have
	beq $t1, 3, power3 # use power3 if we have
	j noInput
# A section where all the all stage behavior occurs
noInput:
# Controls the power up. Used for moving the pickup core up and down via hover/unhover
controlPowerUp:
	lw  $t9, PICKUP_TIMER
	bnez $t9, controlCoin 		# Checks if the state change timer has reached 0
	addi $t9, $zero, 5 
	sw $t9, PICKUP_TIMER 		# State change timer reached 0 so we reset
	jal powerPast 			# Erase the current powerup core
	lw $t9, PICKUP_STATE 		# Load the PICKUP_STATE
	beqz $t9, increaseHoverPower 	# Change state to hover if its not hovering
	sw $zero, PICKUP_STATE
	# Actual hover behavior
	lw $t9, PICKUP_POS + 4
	addi $t9, $t9, 1
	sw $t9, PICKUP_POS + 4
	# Redraws the powerup
	j doPower 			# a label to draw the updated powerup core position
# Change the state of the powerup state to hover and update the position to upwards
increaseHoverPower:
	addi $t9, $zero, 1
	sw $t9, PICKUP_STATE
	lw $t9, PICKUP_POS + 4
	subi $t9, $t9, 1
	sw $t9, PICKUP_POS + 4
# label to draw the powerup core
doPower:
	jal drawPower
# Controls the coin. Used for moving the coin up and down via hover/unhover
controlCoin:
	lw $t9, COIN_TIMER
	bnez $t9, checkStandardCollide	# Checks if the state change timer has reached 0
	addi $t9, $zero, 5		
	sw $t9, COIN_TIMER		# State change timer reached 0 so we reset
	jal coinPast			# Erase the current coin
	lw $t9, COIN_STATE
	beqz $t9, increaseHover		# Change state to hover if its not hovering
	sw $zero, COIN_STATE
	lw $t9, COIN_POS + 4
	addi $t9, $t9, 1
	sw $t9, COIN_POS + 4
	j doCoin			# a label to draw the updated coin position
# Change the state of the coin state to hover and update the position to upwards
increaseHover:
	addi $t9, $zero, 1
	sw $t9, COIN_STATE
	lw $t9, COIN_POS + 4
	subi $t9, $t9, 1
	sw $t9, COIN_POS + 4
# label to draw the coin
doCoin:
	jal drawCoin
# Checking if the current player has collide with coin, powerup, or a monster and branch to the perspective behaviors
checkStandardCollide:
	addi $a0, $zero, 2
	jal computePos
	addi $sp, $sp, 4
	add $t8, $zero, $t9
	srl $t8, $t8, 2
	# Checks the entirety of the player's pixel to check if its within a particular collision that requires behavior (3, 4, 5 values)
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	subi $t8, $t8, 129
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	addi $t8, $t8, 1
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	addi $t8, $t8, 1
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	addi $t8, $t8, 128
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	addi $t8, $t8, 128
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	addi $t8, $t8, 128
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	subi $t8, $t8, 2
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	subi $t8, $t8, 128
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	addi $t8, $t8, 1
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	subi $t8, $t8, 129
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	beq $t7, 4, pickedUpCoin
	beq $t7, 5, pickUpPower
	j jumpProcess # jump to the next process
# Behavior for picking up a coin
pickedUpCoin:
	jal coinPast # Erase the coin
	jal drawPast # Erase the character (for avoiding overlap)
	jal drawChr # Draws the new character
	# Adds onto the score
	lw $t9, CHR_SCORE
	addi $t9, $t9, 1
	sw $t9, CHR_SCORE
	# Function call to draw a bar since we increased score
	jal increaseScorebar
	lw $t9, CHR_SCORE
	# Check if we have won the game by picking up 10 coins already
	bge $t9, 10, winGame
	# Reset coin state and timer
	addi $t9, $zero, 5
	sw $t9, COIN_TIMER
	addi $t9, $zero, 0
	sw $t9, COIN_STATE
	# Spawn another coin at a random location
	jal randomizeSpawnCoin
	j jumpProcess
# Behavior for picking up a powerup core
pickUpPower:
	jal powerPast # Erase the powerup core
	jal drawPast # Erase the character (for avoiding overlap)
	jal drawChr # Draws the new character
	lw $t9, PICKUP_TYPE
	sw $t9, CHR_POWER
	# Reset pickup state and timer
	addi $t9, $zero, 5
	sw $t9, PICKUP_TIMER
	addi $t9, $zero, 1
	sw $t9, PICKUP_STATE
	# Draws the utility power section since we just picked up a new power
	jal drawUtilPowerAdapter
	# Spawn a random powerup at a random location
	jal randomizePower
# Check the current state of the player whether it is in jumping or falling
jumpProcess:
	lw $t9, CHR_MIDJUMP
	beqz $t9, fallingMech # if we aren't jumping state then we go fall
	j handleJump # else handle the jump logic
# Wrapper for calling handling fall
fallingMech:
	jal handleFall
# The reset of the game stage process
continueProcess:
# Moves the monster
moveMonster:
	# Calculate the monster's position on collision map
	addi $a0, $zero, 4
	jal computePos
	addi $sp, $sp, 4
	srl $t9, $t9, 2
	# Check the direction of the monster
	lw $t8, MON_DIR
	beqz $t8, moveLeftMon
# Moves the monster right
moveRightMon:
	# Checks via the collision map to see if they have reached any walls if so change direction
	addi $t9, $t9, 3
	lw $t1, MONSTER
	addi $t1, $t1, 3
	bge $t1, 128, switchLeftMon
	lb $t8, COLLISION_MAP($t9)
	bnez $t8, switchLeftMon
	subi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	bnez $t8, switchLeftMon
	subi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	bnez $t8, switchLeftMon
	# Move monster if all checks were passed and right can be moved
	jal pastMon # erase monster
	lw $t9, MONSTER
	addi $t9, $t9, 1
	sw $t9, MONSTER
	jal drawMon # redraw monster on the new position
	# A simple branch to check if player has collide with monster
	j checkDeathCollide
# Change the monster direction to right since we can't move left
switchLeftMon:
	sw $zero, MON_DIR
	j checkDeathCollide
# Moves the monster left
moveLeftMon:	
	# Checks via the collision map to see if they have reached any walls if so change direction
	subi $t9, $t9, 1
	lw $t1, MONSTER
	subi $t1, $t1, 1
	bltz $t1, switchRightMon
	lb $t8, COLLISION_MAP($t9)
	bnez $t8, switchRightMon
	subi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	bnez $t8, switchRightMon
	subi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	bnez $t8, switchRightMon
	# Move monster if all checks were passed and left can be moved
	jal pastMon # erase monster
	lw $t9, MONSTER
	subi $t9, $t9, 1
	sw $t9, MONSTER
	jal drawMon # redraw monster on the new position
	j checkDeathCollide
# Switch direction to left since we can't move right
switchRightMon:
	addi $t9, $zero, 1
	sw $t9, MON_DIR
# Second gameover check to see if the monster movement caused a collision with player and if so we go gameOver
# Checks every single player pixel on collision map to check collision
checkDeathCollide:
	addi $a0, $zero, 2
	jal computePos
	addi $sp, $sp, 4
	add $t8, $zero, $t9
	srl $t8, $t8, 2
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	subi $t8, $t8, 129
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	addi $t8, $t8, 1
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	addi $t8, $t8, 1
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	addi $t8, $t8, 128
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	addi $t8, $t8, 128
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	addi $t8, $t8, 128
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	subi $t8, $t8, 2
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	subi $t8, $t8, 128
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	addi $t8, $t8, 1
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
	subi $t8, $t8, 129
	lb $t7, COLLISION_MAP($t8)
	beq $t7, 3, gameOver
# Move the second platform
movePlatform2:
	addi $a0, $zero, 6
	jal computePos
	srl $t8, $t9, 2
	addi $sp, $sp, 4
	# Checks the direction of the platform movement
	lw $t9, PLAT2_DIR
	beqz $t9, moveLeftPlat2
# Moves the second platform right
moveRightPlat2:
	lw $t7, MOVE_PLAT2 + 8
	addi $t7, $t7, 1
	add $t8, $t7, $t8
	lw $t1, MOVE_PLAT2
	add $t1, $t1, $t7
	# Checks if moving right causes any problem like collision and out of bound
	# If so we switch direction by branch to switchLeft2
	bge $t1, 128, switchLeft2
	lb $t9, COLLISION_MAP($t8)
	bnez $t9, switchLeft2
	# Perform an up scan to see if player is on platform if so we also move the player
	jal platform2UpScan
	beqz $t1, plat2Right # If the result gives us zero, that implies player shouldn't be moved due to issues
	jal testRight
	beqz $a3, plat2Right
	# Move player while the platform is moving
	jal drawPast
	addi $s3, $s3, 1
	sw $s3, CHR_DIR
	addi $s2, $s2, 1
	sw $s2, CHR_DIR + 4
	addi $s7, $s7, 1
	sw $s7, CHR_POS
	jal drawChr
# Actually moving the second platform right
plat2Right:
	jal pastMovePlat2
	lw $t9, MOVE_PLAT2
	addi $t9, $t9, 1
	sw $t9, MOVE_PLAT2
	jal drawMovePlat2
	j movePlatform1
# Switch the direction of the second platform
switchLeft2:
	sw $zero, PLAT2_DIR
	j movePlatform1
# Moves the second platform left
moveLeftPlat2: 
	subi $t8, $t8, 1
	lw $t1, MOVE_PLAT2
	# Check if platform can move left if not then we change direction
	subi $t1, $t1, 1
	bltz $t1, switchRight2
	lb $t9, COLLISION_MAP($t8)
	bnez $t9, switchRight2
	# Check player is on platform
	jal platform2UpScan
	beqz $t1, plat2Left
	jal testLeft
	beqz $a3, plat2Left
	# Move player same direction as platform
	jal drawPast
	subi $s3, $s3, 1
	sw $s3, CHR_DIR
	subi $s2, $s2, 1
	sw $s2, CHR_DIR + 4
	subi $s7, $s7, 1
	sw $s7, CHR_POS
	jal drawChr
# Move platform left
plat2Left:
	jal pastMovePlat2
	lw $t9, MOVE_PLAT2
	subi $t9, $t9, 1
	sw $t9, MOVE_PLAT2
	jal drawMovePlat2
	j movePlatform1
# Switch platform 2 direction to right
switchRight2:
	addi $t9, $zero, 1
	sw $t9, PLAT2_DIR
# Moves the first platform
movePlatform1:
	addi $a0, $zero, 5
	jal computePos
	srl $t8, $t9, 2
	addi $sp, $sp, 4
	# Checks the direction of the platform movement
	lw $t9, PLAT1_DIR 
	beqz $t9, moveLeftPlat1
# Moving the first platform right
moveRightPlat1:
	lw $t7, MOVE_PLAT1 + 8
	addi $t7, $t7, 1
	add $t8, $t7, $t8
	lw $t1, MOVE_PLAT1
	add $t1, $t1, $t7
	# Check if platform can move right if not then we change direction
	bge $t1, 128, switchLeft1
	lb $t9, COLLISION_MAP($t8)
	bnez $t9, switchLeft1
	# Check player is on platform
	jal platform1UpScan
	beqz $t1, plat1Right
	jal testRight
	beqz $a3, plat1Right
	# Move player same direction as platform
	jal drawPast
	addi $s3, $s3, 1
	sw $s3, CHR_DIR
	addi $s2, $s2, 1
	sw $s2, CHR_DIR + 4
	addi $s7, $s7, 1
	sw $s7, CHR_POS
	jal drawChr
# Move the platform 1 right
plat1Right:
	jal pastMovePlat1
	lw $t9, MOVE_PLAT1
	addi $t9, $t9, 1
	sw $t9, MOVE_PLAT1
	jal drawMovePlat1
	j frameTime
# Change the first platform directions to left
switchLeft1:
	sw $zero, PLAT1_DIR
	j frameTime
# Moves the platform left
moveLeftPlat1:
	subi $t8, $t8, 1
	lw $t1, MOVE_PLAT1
	subi $t1, $t1, 1
	# Check if platform can move right if not then we change direction
	bltz $t1, switchRight1
	lb $t9, COLLISION_MAP($t8)
	bnez $t9, switchRight1
	# Check player is on platform
	jal platform1UpScan
	beqz $t1, plat1Left
	jal testLeft
	beqz $a3, plat1Left
	# Move player same direction as platform
	jal drawPast
	subi $s3, $s3, 1
	sw $s3, CHR_DIR
	subi $s2, $s2, 1
	sw $s2, CHR_DIR + 4
	subi $s7, $s7, 1
	sw $s7, CHR_POS
	jal drawChr
# Move the platform left actually
plat1Left:
	jal pastMovePlat1
	lw $t9, MOVE_PLAT1
	subi $t9, $t9, 1
	sw $t9, MOVE_PLAT1
	jal drawMovePlat1
	j frameTime
# Change the first platform direction to right
switchRight1:
	addi $t9, $zero, 1
	sw $t9, PLAT1_DIR
# Produce a system sleep to make the game flow smooth while also decrementing the timers
frameTime:
	lw $t9, COIN_TIMER
	subi $t9, $t9, 1
	sw $t9, COIN_TIMER
	lw $t9, PICKUP_TIMER
	subi $t9, $t9, 1
	sw $t9, PICKUP_TIMER
	li $v0, 32
	li $a0, 60
	syscall
	j controlLoop
# Selects a random power up using the RNG system call
randomizePower:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	li $v0, 42
	li $a1, 4
	syscall
	sw $a0, PICKUP_TYPE
# Selects a random number for randomizing the power location using the system call
# Sets the previous location number to the current random so we don't get the same location on next random generate
randomizeSpawnPower:
	li $v0, 42
	li $a1, 6
	syscall
	lw $t9, PICKUP_PREV
	beq $a0, $t9, randomizeSpawnPower
	sw $a0, PICKUP_PREV
	beqz $a0, rP0
	beq $a0, 1 rP1
	beq $a0, 2, rP2
	beq $a0, 3, rP3
	beq $a0, 4, rP4
	beq $a0, 5, rP5
# Power random location 0
rP0:
	li $t9, 120
	sw $t9, PICKUP_POS
	li $t9, 45
	sw $t9, PICKUP_POS + 4
	j makePower
# Power random location 1
rP1:
	li $t9, 5
	sw $t9, PICKUP_POS
	li $t9, 46
	sw $t9, PICKUP_POS + 4
	j makePower
# Power random location 2
rP2:
	li $t9, 52
	sw $t9, PICKUP_POS
	li $t9, 43
	sw $t9, PICKUP_POS + 4
	j makePower
# Power random location 3
rP3:
	li $t9, 124
	sw $t9, PICKUP_POS
	li $t9, 32
	sw $t9, PICKUP_POS + 4
	j makePower
# Power random location 4
rP4:
	li $t9, 58
	sw $t9, PICKUP_POS
	li $t9, 10
	sw $t9, PICKUP_POS + 4
	j makePower
# Power random location 5
rP5:
	li $t9, 5
	sw $t9, PICKUP_POS
	li $t9, 30
	sw $t9, PICKUP_POS + 4
	j makePower
# Draw the new power core since we just generated the new power
makePower:
	jal drawPower
	j Return
# A Wrapper to convert selectNewCoinLocal to a function
randomizeSpawnCoin:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
# Selects a random number for randomizing the coin location using the system call
# Sets the previous location number to the current random so we don't get the same location on next random generate
selectNewCoinLocal:
	li $v0, 42
	li $a1, 6
	syscall
	lw $t9, COIN_PREV
	beq $a0, $t9, selectNewCoinLocal
	sw $a0, COIN_PREV
	beqz $a0, rC0
	beq $a0, 1, rC1
	beq $a0, 2, rC2
	beq $a0, 3, rC3
	beq $a0, 4, rC4
	beq $a0, 5, rC5
# Coin random location 0
rC0:
	li $t9, 124
	sw $t9, COIN_POS
	li $t9, 11
	sw $t9, COIN_POS + 4
	j makeCoin
# Coin random location 1
rC1:
	li $t9, 5
	sw $t9, COIN_POS
	li $t9, 39
	sw $t9, COIN_POS + 4
	j makeCoin
# Coin random location 2
rC2:
	li $t9, 120
	sw $t9, COIN_POS
	li $t9, 53
	sw $t9, COIN_POS + 4
	j makeCoin
# Coin random location 3
rC3:
	li $t9, 20
	sw $t9, COIN_POS
	li $t9, 11
	sw $t9, COIN_POS + 4
	j makeCoin
# Coin random location 4
rC4:
	li $t9, 120
	sw $t9, COIN_POS
	li $t9, 39
	sw $t9, COIN_POS + 4
	j makeCoin
# Coin random location 5
rC5:
	li $t9, 34
	sw $t9, COIN_POS
	li $t9, 11
	sw $t9, COIN_POS + 4
	j makeCoin
# Draw the coins since we just finished picking a random location
makeCoin:
	jal drawCoin
	j Return
# A function to check if player is indefinitely on platform for relative movement with platform1
platform1UpScan:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 5
	lw $t9, MOVE_PLAT1 + 4
	subi $t9, $t9, 1
	sw $t9, MOVE_PLAT1 + 4
	jal computePos
	addi $sp, $sp, 4
	la $t8, CHR_FIN	
	lw $t6, MOVE_PLAT1 + 8
# Check if player is on first platform
upScanLoop:
	lw $t7, DISPLAY($t9)
	beq $t7, $t8, foundFinScan
	subi $t6, $t6, 1
	addi $t9, $t9, 4
	bgez $t6, upScanLoop
	add $t1, $zero, $zero
# Reset the position since we used it to check if player is above platform
finishUpScan:
	lw $t9, MOVE_PLAT1 + 4
	addi $t9, $t9, 1
	sw $t9, MOVE_PLAT1 + 4
	j Return
# First platform's up scan finish
foundFinScan:
	addi $t1, $zero, 1
	j finishUpScan
# A function to check if player is indefinitely on platform for relative movement with platform2
platform2UpScan:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 6
	lw $t9, MOVE_PLAT2 + 4
	subi $t9, $t9, 1
	sw $t9, MOVE_PLAT2 + 4
	jal computePos
	addi $sp, $sp, 4
	la $t8, CHR_FIN	
	lw $t6, MOVE_PLAT2 + 8
# Check if player is on second platform
upScanLoop2:
	lw $t7, DISPLAY($t9)
	beq $t7, $t8, foundFinScan2
	subi $t6, $t6, 1
	addi $t9, $t9, 4
	bgez $t6, upScanLoop2
	add $t1, $zero, $zero
# Reset the position since we used it to check if player is above platform
finishUpScan2:
	lw $t9, MOVE_PLAT2 + 4
	addi $t9, $t9, 1
	sw $t9, MOVE_PLAT2 + 4
	j Return
# Second platform's up scan finish
foundFinScan2:
	addi $t1, $zero, 1
	j finishUpScan2
# Handling the actual jump by checking the jump time state if so we continue to jump
handleJump:
	beqz $s0, completeJump
	beq $t9, 0, completeJump
	jal handleDefJump
	subi $s0, $s0, 1
	addi $s1, $s1, 1
	j continueProcess
# A wrapper for completing the jump and changing the jump state to 0
completeJump:
	add $s1, $zero, $zero
	sw $s1, CHR_MIDJUMP
	j fallingMech # go back to falling since we finished the jump
# Handles the jump by checking the distance from player head to the top ground to see which one to perform
handleDefJump:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	jal calcHead
	subi $t9, $t9, 1
	beqz $t9, handleReturnJump
	jal handleDefDefJump
	j Return
# Handles and divides the jump behavior based on the jump velocity
handleDefDefJump:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	sub $t8, $t9, $s1
	blez $t8, fixHead
	jal jumpProceed
	j Return
# Handles if the player's jump velocity exceeds and causes the player to clip through solid platforms
# Fixes it by causing the player to bump to the top platform if any
fixHead:
	add $s1, $s1, $t8
	jal drawPast
	sub $s4, $s4, $s1
	sw $s4, CHR_TOP
	sub $s5, $s5, $s1
	sw $s5, CHR_BOT
	sub $s6, $s6, $s1
	sw $s6, CHR_POS + 4
	jal drawChr
	j Return
# Handles the jumping of the player
jumpProceed:
	jal drawPast
	sub $s4, $s4, $s1
	sw $s4, CHR_TOP
	sub $s5, $s5, $s1
	sw $s5, CHR_BOT
	sub $s6, $s6, $s1
	sw $s6, CHR_POS + 4
	jal drawChr
	j Return
# A wrapper function for return for the jump functions
handleReturnJump:
	addi $sp $sp, 4
	j completeJump
# Handles the player fall by calculating distance from ground and proceed fall
handleFall:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	jal calcGround
	sub $t9, $t9, 1
	blez $t9, fixJumpCount
	jal handleDefFall
	j Return
# Determine which fall to perform. fixGround will be performed if the velocity causes the player to go below the ground else fallProceed
handleDefFall:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	sub $t8, $t9, $s1
	blez $t8, fixGround
	beq $s1, 4, fallProceed
	add $s1, $s1, 1
# Continue to fall since we have not reached a velocity where we would clip through the ground
fallProceed:
	subi $sp, $sp, 4
	sw $t8, 0($sp)
	jal drawPast
	add $s4, $s4, $s1
	sw $s4, CHR_TOP
	add $s5, $s5, $s1
	sw $s5, CHR_BOT
	add $s6, $s6, $s1
	sw $s6, CHR_POS + 4
	jal drawChr
	lw $t8, 0($sp)
	addi $sp, $sp, 4
	beq $t8, 1, fixJumpCount
	j Return
# Function for popping the player out of the ground if the player's feet clips into a platform
# Performs collision check for platform
fixInGround:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 2
	jal computePos
	addi $sp, $sp, 4
	srl $t9, $t9, 2
	addi $t9, $t9, 256
	lb $t7, COLLISION_MAP($t9)
	beq $t7, 2, popOutGround
	beq $t7, 7, popOutGround
	addi $t9, $t9, 1
	lb $t7, COLLISION_MAP($t9)
	beq $t7, 2, popOutGround
	beq $t7, 7, popOutGround
	subi $t9, $t9, 2
	lb $t7, COLLISION_MAP($t9)
	beq $t7, 2, popOutGround
	beq $t7, 7, popOutGround
	j Return
# Pops the player out of the ground if the player manage's to clip its feet into the platform
popOutGround:
	jal drawPast
	subi $s4, $s4, 1
	subi $s5, $s5, 1
	subi $s6, $s6, 1
	sw $s4, CHR_TOP
	sw $s5, CHR_BOT
	sw $s6, CHR_POS + 4
	jal drawChr
	j Return
# Fixes the ground to prevent players from falling and going through the ground
fixGround:
	add $s1, $s1, $t8
	jal drawPast
	add $s4, $s4, $s1
	sw $s4, CHR_TOP
	add $s5, $s5, $s1
	sw $s5, CHR_BOT
	add $s6, $s6, $s1
	sw $s6, CHR_POS + 4
	jal drawChr
	add $s1, $zero, $zero
# Resets the jump counter for the player on landing
fixJumpCount:
	jal fixInGround
	lw $t9, CHR_MAXJUMP
	sw $t9, CHR_JUMP
	j Return
# A function for calculating the distance from the players top to the closest top solid ground, used for when player jumps
# Prevent players from jump and skipping over a solid platform and not bumping their head
calcHead:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	add $t8, $zero, $s4
	sw $t8, DRAW_POS0 + 4
	add $t8, $zero, $s2
	sw $t8, DRAW_POS0
	add $a0, $zero, $zero
	jal computePos
	add $t6, $zero, $t9
	addi $sp, $sp, 4
	srl $t6, $t6, 2
	subi $t7, $t6, 1
	subi $t8, $t7, 1
	add $t9, $zero, $zero
# A loop for calculating the distance from the players head to the closest top solid platform
heightLoopTop:
	bltz $t6, Return
	bltz $t7, Return
	bltz $t8, Return
	lb $t3, COLLISION_MAP($t6)
	lb $t4, COLLISION_MAP($t7)
	lb $t5, COLLISION_MAP($t8)
	beq $t3, 1, Return
	beq $t4, 1, Return
	beq $t5, 1, Return
	beq $t3, 6, Return
	beq $t4, 6, Return
	beq $t5, 6, Return
	subi $t6, $t6, 128
	subi $t7, $t7, 128
	subi $t8, $t8, 128
	addi $t9, $t9, 1
	j heightLoopTop
# A function for calculating the distance from the players feet to the closest bottom solid ground, used for when player falls
# Prevents player from falling through the floor
calcGround:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	add $t8, $zero, $s5
	sw $t8, DRAW_POS0 + 4
	add $t8, $zero, $s2
	sw $t8, DRAW_POS0
	add $a0, $zero, $zero
	jal computePos
	add $t6, $zero, $t9
	addi $sp, $sp, 4
	srl $t6, $t6, 2
	subi $t7, $t6, 1
	subi $t8, $t7, 1
	add $t9, $zero, $zero
# A loops to calculate the distance from the players feet to the closest ground (check via collision map)
heightLoopBot:
	lb $t3, COLLISION_MAP($t6)
	lb $t4, COLLISION_MAP($t7)
	lb $t5, COLLISION_MAP($t8)
	beq $t3, 1, Return
	beq $t3, 2, Return
	beq $t3, 6, Return
	beq $t3, 7, Return
	beq $t4, 1, Return
	beq $t4, 2, Return
	beq $t4, 6, Return
	beq $t4, 7, Return
	beq $t5, 1, Return
	beq $t5, 2, Return
	beq $t5, 6, Return
	beq $t5, 7, Return
	addi $t6, $t6, 128
	addi $t7, $t7, 128
	addi $t8, $t8, 128
	addi $t9, $t9, 1
	j heightLoopBot
# Checks left collision on a moving platform
testLeft:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $s3, $s3, 1
	bltz $s3, leftOutBound
	sw $s3, DRAW_POS0
	jal testHorizontal
	addi $s3, $s3, 1
	j Return
# Handling if moving left will cause out of bound on moving platform
leftOutBound:
	addi $s3, $s3, 1
	add $a3, $zero, $zero
	j Return
# Checks right collision on a moving platform
testRight:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $s2, $s2, 1
	bge $s2, 128, rightOutBound
	sw $s2, DRAW_POS0
	jal testHorizontal
	subi $s2, $s2, 1
	j Return
# Handling if moving right will cause out of bound on moving platform
rightOutBound:
	subi $s2, $s2, 1
	add $a3, $zero, $zero
	j Return
# A version of collideHorizontal but for checking on a moving platform
testHorizontal:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	sw $s4, DRAW_POS0 + 4
	add $a0, $zero, $zero
	jal computePos
	lw $t9, 0($sp)
	addi $sp, $sp, 4
	srl $t9, $t9, 2
	add $a3, $zero, $zero
	lb $t8, COLLISION_MAP($t9)
	beq $t8, 1, Return
	addi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	beq $t8, 1, Return
	addi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	beq $t8, 1, Return
	addi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	beq $t8, 1, Return
	addi $a3, $zero, 1
	j Return
# Checks the collision on the left side of player
checkCollideLeft:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $s3, $s3, 1
	li $a0, 0
	sw $s3, DRAW_POS0
	jal collideHorizontal
	addi $s3, $s3, 1
	j Return
# Checks the collision on right side of player
checkCollideRight:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $s2, $s2, 1
	li $a0, 1
	sw $s2, DRAW_POS0
	jal collideHorizontal
	subi $s2, $s2, 1
	j Return
# Checks the collision on the sides to determine if one should move in the direction the player wishes
collideHorizontal:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	sw $s4, DRAW_POS0 + 4
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	add $a0, $zero, $zero
	jal computePos
	lw $t9, 0($sp)
	addi $sp, $sp, 4
	srl $t9, $t9, 2
	lb $t8, COLLISION_MAP($t9)
	beq $t8, 1, posReturn
	beq $t8, 6, posReturn
	addi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	beq $t8, 1, posReturn
	beq $t8, 6, posReturn
	addi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	beq $t8, 1, posReturn
	beq $t8, 6, posReturn
	addi $t9, $t9, 128
	lb $t8, COLLISION_MAP($t9)
	beq $t8, 1, posReturn
	beq $t8, 6, posReturn
	addi $sp, $sp, 4
	j Return
# Another wrapper function for returning and reverting
posReturn:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	beqz $a0, handleBadLeft
	subi $s2, $s2, 1
	j dontGo
# Revert the change since we cannot go left
handleBadLeft:
	addi $s3, $s3, 1
# A wrapper function to pop 2 off the stack and then continue stage process
dontGo:
	addi $sp, $sp, 8
	j noInput
# POWERS SECTION
# Functionality of the 0th powerup
power0:
	addi $t9, $zero, 2
	sw $t9, CHR_MAXJUMP
	sw $t9, CHR_JUMP
	j noInput
# Functionality of the 1st powerup
power1:
	addi $t9, $zero, 2
	sw $t9, CHR_JUMPVELO
	j noInput
# Functionality of the 2nd powerup
power2: # build platform below
	addi $t9, $s5, 1
	sw $t9, DRAW_POS0 + 4
	sw $s3, DRAW_POS0
	addi $a1, $zero, 2
	addi $a2, $zero, 2
	la $a0, CLR_ORANGE
	jal drawPlatform
	j noInput
# Functionality of the 3rd powerup
power3:	# teleport to coin
	jal drawPast
	lw $s7, COIN_POS
	sw $s7, CHR_POS
	lw $s6, COIN_POS + 4
	subi $s6, $s6, 1
	subi $s4, $s6, 1
	addi $s5, $s6, 2
	sw $s6, CHR_POS + 4
	sw $s5, CHR_BOT
	sw $s4, CHR_TOP
	subi $s3, $s7, 1
	addi $s2, $s7, 1
	sw $s3, CHR_DIR
	sw $s2, CHR_DIR + 4
	sw $zero, CHR_FALL
	add $s1, $zero, $zero
	jal drawChr
	j noInput
	
# ============================
#	DRAWING SECTION
# ============================

# --- PLAYER DRAWING ---
# Erases the entire player by redrawing whatever is in PIXEL_HOLD
drawPast:	
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	add $a0, $zero, $zero
	lw $t9, CHR_POS
	sw $t9, DRAW_POS0
	lw $t9, CHR_POS + 4
	sw $t9, DRAW_POS0 + 4
	jal computePos
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	add $t8, $zero, $zero
	jal handlePast
	
	addi $t0, $t0, 4
	addi $t8, $t8, 4
	jal handlePast
	
	addi $t8, $t8, 4
	subi $t0, $t0, 512
	jal handlePast
	
	addi $t8, $t8, 4
	subi $t0, $t0, 4
	jal handlePast
	
	addi $t8, $t8, 4
	subi $t0, $t0, 4
	jal handlePast
	
	addi $t8, $t8, 4
	addi $t0, $t0, 512
	jal handlePast
	
	addi $t8, $t8, 4
	addi $t0, $t0, 512
	jal handlePast
	
	addi $t8, $t8, 4
	addi $t0, $t0, 4
	jal handlePast
	
	addi $t8, $t8, 4
	addi $t0, $t0, 4
	jal handlePast
	
	addi $t8, $t8, 4
	addi $t0, $t0, 512
	jal handlePast
	
	addi $t8, $t8, 4
	subi $t0, $t0, 8
	jal handlePast
	j Return
# Helper function for erasing the player by redrawing everything in PIXEL_HOLD
handlePast:
	lw $a0, PIXEL_HOLD($t8)
	sw $a0, DISPLAY($t0)
	jr $ra

# Draw Character based on current position (CHR_POS) [PLAYERS HAVE NO COLLISION VALUE ON MAP]
drawChr:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 2
	jal computePos
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	add $t7, $zero, $t0
	srl $t7, $t7, 2
	add $t8, $zero, $zero
	la $a0, CHR_BODY
	jal handleSave
	
	addi $t0, $t0, 4
	addi $t8, $t8, 4
	addi $t7, $t7, 1
	la $a0, CHR_EYE
	jal handleSave
	
	subi $t0, $t0, 512
	addi $t8, $t8, 4
	subi $t7, $t7, 128
	la $a0, CHR_BODY
	jal handleSave
	
	subi $t0, $t0, 4
	addi $t8, $t8, 4
	subi $t7, $t7, 1
	jal handleSave
	
	subi $t0, $t0, 4
	addi $t8, $t8, 4
	subi $t7, $t7, 1
	jal handleSave
	
	addi $t0, $t0, 512
	addi $t8, $t8, 4
	addi $t7, $t7, 128
	la $a0, CHR_EYE
	jal handleSave
	
	addi $t0, $t0, 512
	addi $t8, $t8, 4
	addi $t7, $t7, 128
	la $a0, CHR_BODY
	jal handleSave
	
	addi $t0, $t0, 4
	addi $t8, $t8, 4
	addi $t7, $t7, 1
	jal handleSave

	addi $t0, $t0, 4
	addi $t8, $t8, 4
	addi $t7, $t7, 1
	jal handleSave
	
	addi $t0, $t0, 512
	addi $t8, $t8, 4
	addi $t7, $t7, 128
	la $a0, CHR_FIN
	jal handleSave
	
	subi $t0, $t0, 8
	addi $t8, $t8, 4
	subi $t7, $t7, 2
	jal handleSave
		
	j Return
# Saves all supported pixels behind the current player into PIXEL_HOLD
handleSave:	
	lw $t9, DISPLAY($t0)
	lb $t1, COLLISION_MAP($t7)
	beq $t1, 4, badSave
	beq $t1, 5, badSave
	beq $t1, 3, badSave
	beq $t1, 6 badSave
	beq $t1, 7, badSave
	j setSave
# Loads the background color to save in PIXEL_HOLD if the current player is infront of an object that isn't suppose to be saved (coin, pickup, monster)
badSave:
	la $t9, CLR_BG
# Handles saving the pixels behind the player into PIXEL_HOLD and drawing the player onto the bitmap
setSave:
	sw $t9, PIXEL_HOLD($t8)
	sw $a0, DISPLAY($t0)
	jr $ra

# --- MONSTER DRAWING ---
# Erases the monster and resets the collision map of the monster at position MONSTER
pastMon:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 4
	jal computePos
	addi $sp, $sp, 4
	add $t7, $zero, $t9
	srl $t7, $t7, 2
	addi $t1, $zero, 0
	la $a0, CLR_BG
	jal monWrite
	
	add $t9, $t9, 8
	add $t7, $t7, 2
	jal monWrite
	
	subi $t9, $t9, 516
	subi $t7, $t7, 129
	jal monWrite
	
	subi $t9, $t9, 512
	subi $t7, $t7, 128
	jal monWrite
	
	subi $t9, $t9, 4
	subi $t7, $t7, 1
	jal monWrite
	
	addi $t9, $t9, 8
	addi $t7, $t7, 2
	jal monWrite
	
	addi $t9, $t9, 512
	addi $t7, $t7, 128
	jal monWrite
	
	subi $t9, $t9, 8
	subi $t7, $t7, 2
	jal monWrite
	j Return
# Draws the monster based off the position in MONSTER position array
# It sets the collision value and draws the monster onto the bitmap
drawMon:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 4
	jal computePos
	addi $sp, $sp, 4
	add $t7, $zero, $t9
	srl $t7, $t7, 2
	addi $t1, $zero, 3
	la $a0, MON_BODY
	jal monWrite
	
	add $t9, $t9, 8
	add $t7, $t7, 2
	jal monWrite
	
	subi $t9, $t9, 516
	subi $t7, $t7, 129
	jal monWrite
	
	subi $t9, $t9, 512
	subi $t7, $t7, 128
	jal monWrite
	
	subi $t9, $t9, 4
	subi $t7, $t7, 1
	jal monWrite
	
	addi $t9, $t9, 8
	addi $t7, $t7, 2
	jal monWrite
	
	la $a0, MON_EYE
	addi $t9, $t9, 512
	addi $t7, $t7, 128
	jal monWrite
	
	subi $t9, $t9, 8
	subi $t7, $t7, 2
	jal monWrite
	j Return
# Helper function for drawing the monster onto the bitmap and setting the collision map values
monWrite:	
	sb $t1, COLLISION_MAP($t7)
	sw $a0, DISPLAY($t9)
	jr $ra

# --- PICKUP DRAWING ---
# Draws the corresponding powerup based off the randomly rolled powerup stored in PICKUP_TYPE
# It draws pickup based on PICKUP_POS
drawPower:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 7
	jal computePos
	addi $sp, $sp, 4
	add $t8, $zero, $t9
	srl $t8, $t8, 2
	# Draw it based off selection
	lw $a0, PICKUP_TYPE
	beqz $a0, pT0
	beq $a0, 1, pT1
	beq $a0, 2, pT2
	beq $a0, 3, pT3
# Select power0 color
pT0: # double jump
	la $a0, CLR_POWER0
	j drawPowerDef
# Select power1 color
pT1: # jump height
	la $a0, CLR_POWER1
	j drawPowerDef
# Select power2 color
pT2: # build platform below
	la $a0, CLR_POWER2
	j drawPowerDef
# Select power3 color
pT3: # tp to coin 
	la $a0, CLR_POWER3
# Function for drawing the current power that was selected by the RNG
drawPowerDef:
	addi $t7, $zero, 5
	
	jal handlePowerSave
	
	addi $t9, $t9, 4
	addi $t8, $t8, 1
	
	jal handlePowerSave
	
	addi $t9, $t9, 508
	addi $t8, $t8, 127
	
	jal handlePowerSave
	
	addi $t9, $t9, 4
	addi $t8, $t8, 1
	
	jal handlePowerSave
	
	j Return
# Helper function for drawing the item on to the bitmap and setting its collision
handlePowerSave:
	sw $a0, DISPLAY($t9)
	sb $t7, COLLISION_MAP($t8)
	jr $ra
# Function for erasing the pickup item off the bitmap
powerPast:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 7
	jal computePos
	addi $sp, $sp, 4
	add $t8, $zero, $t9
	srl $t8, $t8, 2
	la $t5, CLR_BG
	jal handlePowerPast
	
	addi $t9, $t9, 4
	addi $t8, $t8, 1
	
	jal handlePowerPast
	
	addi $t9, $t9, 508
	addi $t8, $t8, 127
	
	jal handlePowerPast
	
	addi $t9, $t9, 4
	addi $t8, $t8, 1
	
	jal handlePowerPast
	
	j Return
# Helper function for erasing the Pickup on the bitmap and resetting the collision map at that position
handlePowerPast:
	sw $t5, DISPLAY($t9)
	sb $zero, COLLISION_MAP($t8)
	jr $ra
	
# --- COIN DRAWING ---
# Draws the coin at COIN_POS and sets the collision value
drawCoin:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 3
	jal computePos
	addi $sp, $sp, 4
	add $t8, $zero, $t9
	srl $t8, $t8, 2
	
	la $a0, COIN_EDGE
	addi $t7, $zero, 4
	
	jal handleCoinSave
	
	la $a0, COIN_CORE
	addi $t9, $t9, 4
	addi $t8, $t8, 1
	
	jal handleCoinSave
	
	addi $t9, $t9, 508
	addi $t8, $t8, 127
	
	jal handleCoinSave
	
	addi $t9, $t9, 4
	addi $t8, $t8, 1
	
	jal handleCoinSave
	
	j Return
# Helper function for drawing the coin
handleCoinSave:
	sw $a0, DISPLAY($t9)
	sb $t7, COLLISION_MAP($t8)
	jr $ra
# Erases the entirety of the coin at position COIN_POS
coinPast:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 3
	jal computePos
	addi $sp, $sp, 4
	add $t8, $zero, $t9
	srl $t8, $t8, 2
	la $t5, CLR_BG
	jal handleCoinPast
	
	addi $t9, $t9, 4
	addi $t8, $t8, 1
	
	jal handleCoinPast
	
	addi $t9, $t9, 508
	addi $t8, $t8, 127
	
	jal handleCoinPast
	
	addi $t9, $t9, 4
	addi $t8, $t8, 1
	
	jal handleCoinPast
	
	j Return
# A helper function for erasing the coin off the bitmap and resetting the collision map value for the coin
handleCoinPast:
	sw $t5, DISPLAY($t9)
	sb $zero, COLLISION_MAP($t8)
	jr $ra
	
# --- UTILITY BAR DRAWING ---
# Draws the top utility bar including the scorebar 
drawUtilBar:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	
	add $t8, $zero, $zero
	addi $t9, $zero, 3068
	add $a2, $zero, 1
	add $t7, $zero, $zero
	la $a0, CLR_BAR
	jal adapterDrawLoop
	la $a0, CLR_SCORE_EMP
	lw $t8, BAR_POS
	addi $t9, $t8, 360
	srl $t7, $t8, 2
	jal adapterDrawLoop
	lw $t8, BAR_POS
	addi $t8, $t8, 512
	addi $t9, $t8, 360
	srl $t7, $t8, 2
	jal adapterDrawLoop
	lw $t8, BAR_POS
	addi $t8, $t8, 1024
	addi $t9, $t8, 360
	srl $t7, $t8, 2
	jal adapterDrawLoop
	lw $t8, BAR_POS
	addi $t8, $t8, 1536
	addi $t9, $t8, 360
	srl $t7, $t8, 2
	jal adapterDrawLoop
	la $a0, CHR_EYE
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 1024
	sw $a0, DISPLAY($t9)
	la $a0, CLR_WHITE
	subi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 1024
	sw $a0, DISPLAY($t9)
	# Drawing coin icon
	subi $t9, $t9, 500
	la $a0, COIN_EDGE
	sw $a0, DISPLAY($t9)
	
	la $a0, COIN_CORE
	
	addi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	
	addi $t9, $t9, 508
	sw $a0, DISPLAY($t9)
	
	addi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	
	la $a0, CLR_WHITE
	subi $t9, $t9, 500
	addi $t8, $t9, 28
	sw $a0, DISPLAY($t8)
	subi $t8, $t8, 512
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 4
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 4
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 4
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 512
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 512
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 512
	sw $a0, DISPLAY($t8)
	subi $t8, $t8, 4
	sw $a0, DISPLAY($t8)
	subi $t8, $t8, 4
	sw $a0, DISPLAY($t8)
	subi $t8, $t8, 4
	sw $a0, DISPLAY($t8)
	subi $t8, $t8, 512
	sw $a0, DISPLAY($t8)
	j drawUtilPower
# A wrapper function for drawing the top bar
drawUtilPowerAdapter:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
# Draws the second half of the top bar based on the current pickup power player is holding
drawUtilPower:
	addi $t9, $zero, 1416
	lw $a0, CHR_POWER
	beq $a0, -1, pUtilNo
	beqz $a0, pUtilT0
	beq $a0, 1, pUtilT1
	beq $a0, 2, pUtilT2
	beq $a0, 3, pUtilT3
# Loads the color for when you have no power
pUtilNo: # no power
	la $a0, CLR_LGHTGRAY
	j drawF
# Loads the power0 color
pUtilT0: # double jump
	la $a0, CLR_POWER0
	j drawF
# Loads the power1 color
pUtilT1: # jump height
	la $a0, CLR_POWER1
	j drawF
# Loads the power2 color
pUtilT2: # build platform below
	la $a0, CLR_POWER2
	j drawF
# Loads the power3 color
pUtilT3: # tp to coin 
	la $a0, CLR_POWER3
# Draws a big F for the utility bar at the top
drawF:
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 1024
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 16
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 516
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 12
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 4
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 512
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	addi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 516
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	subi $t9, $t9, 8
	sw $a0, DISPLAY($t9)
	j Return
# Function for increasing the scorebar on touching a coin, it fills exactly 9 lines in the scorebar on each call
increaseScorebar:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	lw $t9, BAR_POS
	jal drawBarDown
	addi $t9, $t9, 4
	jal drawBarDown
	addi $t9, $t9, 4
	jal drawBarDown
	addi $t9, $t9, 4
	jal drawBarDown
	addi $t9, $t9, 4
	jal drawBarDown
	addi $t9, $t9, 4
	jal drawBarDown
	addi $t9, $t9, 4
	jal drawBarDown
	addi $t9, $t9, 4
	jal drawBarDown
	addi $t9, $t9, 4
	jal drawBarDown
	addi $t9, $t9, 4
	sw $t9, BAR_POS
	j Return
# A helper function for drawing the scorebar, it fills a single line in the scorebar with color
drawBarDown:
	add $t8, $t9, $zero
	la $a0, COIN_CORE
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 512
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 512
	sw $a0, DISPLAY($t8)
	addi $t8, $t8, 512
	sw $a0, DISPLAY($t8)
	jr $ra
	
# --- GENERAL DRAWING FUNCTIONS ---
# Clears the screen by filling collision map with 0 and painting everything black
clearScreen:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	add $a2, $zero, $zero
	la $t9, BOTTOMRIGHT
	add $t8, $zero, $zero
	la $a0, CLR_BLACK
	add $t7, $zero, $zero
	j drawLoop
# Draws the background and fills the collision map with 0 and paints the bitmap with CLR_BG
drawBG:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	add $a2, $zero, $zero
	la $t9, BOTTOMRIGHT
	add $t8, $zero, $zero
	la $a0, CLR_BG
	add $t7, $zero, $zero
	j drawLoop
# Compute the display position for a particular object relative to the bitmap display
# 0 - DRAW_POS0
# 1 - DRAW_POS1
# 2 - CHR_POS
# 3 - COIN_POS
# 4 - MONSTER
# 5 - MOVE_PLAT1
# 6 - MOVE_PLAT2
# 7 - PICKUP_POS
computePos:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	beqz $a0, computePos0		# Compute DRAW_POS0 pos
	beq $a0, 2, computeUsr 		# Compute player pos
	beq $a0, 3, computeCoin 	# Compute coin pos
	beq $a0, 4, computeMon 		# Compute monster pos
	beq $a0, 5, computePlat1 	# Compute moving platform 1 pos
	beq $a0, 6, computePlat2	# Compute moving platform 2 pos
	beq $a0, 7, computePower	# Compute pickup pos
# Load positions for DRAW_POS1 into register for later calculating by finishCompute (DRAW_POS1 position)
computePos1:
	lw $t9, DRAW_POS1 + 4
	lw $t8, DRAW_POS1
	j finishCompute
# Load positions for CHR_POS into register for later calculating by finishCompute (Player Position)
computeUsr:
	lw $t9, CHR_POS + 4
	lw $t8, CHR_POS
	j finishCompute
# Load positions for COIN_POS into register for later calculating by finishCompute (Coin position)
computeCoin:
	lw $t9, COIN_POS + 4
	lw $t8, COIN_POS
	j finishCompute
# Load positions for MOVE_PLAT1 into register for later calculating by finishCompute (Moving Platform Position)
computePlat1:
	lw $t9, MOVE_PLAT1 + 4
	lw $t8, MOVE_PLAT1
	j finishCompute
# Load positions for MOVE_PLAT2 into register for later calculating by finishCompute (Solid Moving Platform Position)
computePlat2:
	lw $t9, MOVE_PLAT2 + 4
	lw $t8, MOVE_PLAT2
	j finishCompute
# Load positions for MONSTER into register for later calculating by finishCompute (Monster position)
computeMon:
	lw $t9, MONSTER + 4
	lw $t8, MONSTER
	j finishCompute
# Load positions for PICKUP_POS into register for later calculating by finishCompute (Pickup position)
computePower:
	lw $t9, PICKUP_POS + 4
	lw $t8, PICKUP_POS
	j finishCompute
# Load positions for DRAW_POS0 into register for later calculating by finishCompute (DRAW_POS0 position)
computePos0:
	lw $t9, DRAW_POS0 + 4
	lw $t8, DRAW_POS0
# A sector of computePos for computing the actual position relative to DISPLAY and returning such value
finishCompute:
	sll $t9, $t9, 9
	sll $t8, $t8, 2
	add $t9, $t9, $t8
	lw $t0, 0($sp)
	sw $t9, 0($sp)
	jr $t0
# function to draw a single dot using DRAW_POS0 with collision map $a2
drawDot:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp) #save color
	add $a0, $zero, $zero
	jal computePos
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	sw $a0, DISPLAY($t9)
	srl $t8, $t9, 2
	sb $a2, COLLISION_MAP($t8)
	j Return
# Function to draw a platform. $a0 color, $a1 length, $a2 platform type
drawPlatform:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	lw $t9, DRAW_POS0
	add $t9, $t9, $a1
	sw $t9, DRAW_POS1
	lw $t9, DRAW_POS0 + 4
	sw $t9, DRAW_POS1 + 4
	jal drawCont
	j Return
# Draws vertically using DRAW_POS0 as starting point with $a0 as color, $a1 as vertical length, $a2 as collision type
drawVertical:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	lw $t9, DRAW_POS0 + 4
	add $t9, $t9, $a1
	sw $t9, DRAW_POS1 + 4
	lw $t9, DRAW_POS0
	sw $t9, DRAW_POS1
	jal drawVerticalHelper
# A modified version of the drawCont but with purpose of drawing vertically instead of horizontally
# Used by drawVertical to draw vertically $a1 length
drawVerticalHelper:
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	addi $a0, $zero, 1
	jal computePos
	add $a0, $zero, $zero
	jal computePos
	lw $t8, 0($sp)
	add $t7, $zero, $t8
	srl $t7, $t7, 2
	lw $t9, 4($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 12
	j drawColLoop
# Draw continuously from (x1, y1) DRAW_POS1 to (x0, y0) DRAW_POS0 with collision map $a2
# Precondition: DRAW_POS0's computed value < DRAW_POS1's computed value
drawCont:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	addi $a0, $zero, 1
	jal computePos
	add $a0, $zero, $zero
	jal computePos
	lw $t8, 0($sp)
	add $t7, $zero, $t8
	srl $t7, $t7, 2
	lw $t9, 4($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 12
	j drawLoop
# An adapter draw function for calling drawLoop and turning it into a function
adapterDrawLoop:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
# Drawing loop to draw from values of $t8 to $t9
drawLoop:
	blt $t9, $t8, Return
	sw $a0, DISPLAY($t8)
	sb $a2, COLLISION_MAP($t7)
	addi $t8, $t8, 4
	addi $t7, $t7, 1
	j drawLoop
# Function for drawing the moving platform 1 using the MOVE_PLAT1
drawMovePlat1:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a0, $zero, 5
	addi $a2, $zero, 7
	jal computePos
	lw $t8, 0($sp)
	addi $sp, $sp, 4
	lw $t6, MOVE_PLAT1 + 8
	sll $t6, $t6, 2
	add $t9, $t9, $t6
	add $t7, $zero, $t8
	srl $t7, $t7, 2
	la $a0, PLAT1_CLR
	j drawLoop
# Function for erasing the moving platform 1 using the MOVE_PLAT1
pastMovePlat1:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a2, $zero, 0
	addi $a0, $zero, 5
	jal computePos
	lw $t8, 0($sp)
	addi $sp, $sp, 4
	lw $t6, MOVE_PLAT1 + 8
	sll $t6, $t6, 2
	add $t9, $t9, $t6
	add $t7, $zero, $t8
	srl $t7, $t7, 2
	la $a0, CLR_BG
	j drawLoop
# Function for drawing the solid moving platform 2 using the MOVE_PLAT2
drawMovePlat2:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a2, $zero, 6
	addi $a0, $zero, 6
	jal computePos
	lw $t8, 0($sp)
	addi $sp, $sp, 4
	lw $t6, MOVE_PLAT2 + 8
	sll $t6, $t6, 2
	add $t9, $t9, $t6
	add $t7, $zero, $t8
	srl $t7, $t7, 2
	la $a0, PLAT2_CLR
	j drawLoop
# Function for erasing the solid moving platform 2 using the MOVE_PLAT2
pastMovePlat2:
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	addi $a2, $zero, 0
	addi $a0, $zero, 6
	jal computePos
	lw $t8, 0($sp)
	addi $sp, $sp, 4
	lw $t6, MOVE_PLAT2 + 8
	sll $t6, $t6, 2
	add $t9, $t9, $t6
	add $t7, $zero, $t8
	srl $t7, $t7, 2
	la $a0, CLR_BG
	j drawLoop
# Fills a column (x) $a1 with $a0 color with collision type $a2
drawCol: # drawCol($a1 = column#, $a0 = color, $a2 = type)
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	sw $a1, DRAW_POS1
	sw $a1, DRAW_POS0
	la $t9, LAST_ROW
	sw $t9, DRAW_POS1 + 4
	addi $a0, $zero, 1
	jal computePos
	sw $zero, DRAW_POS0 + 4
	add $a0, $zero, $zero
	jal computePos
	lw $t8, 0($sp)
	add $t7, $zero, $t8
	srl $t7, $t7, 2
	lw $t9, 4($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 12
# A helper function to fill a column looping
drawColLoop: # fills column from value $t8 to $t9
	blt $t9, $t8, Return
	sw $a0, DISPLAY($t8)
	sb $a2, COLLISION_MAP($t7)
	addi $t8, $t8, 512
	addi $t7, $t7, 128
	j drawColLoop
# Fills a row (y) $a1 with $a0 color with collision type $a2
drawRow: # fills a row from value $t8 to $t9
	subi $sp, $sp, 4
	sw $ra, 0($sp)
	subi $sp, $sp, 4
	sw $a0, 0($sp)
	sw $a1, DRAW_POS1 + 4
	la $t9, LAST_COL
	sw $t9, DRAW_POS1
	sw $a1, DRAW_POS0 + 4
	sw $zero, DRAW_POS0
	addi $a0, $zero, 1
	jal computePos
	add $a0, $zero, $zero
	jal computePos
	lw $t8, 0($sp)
	add $t7, $zero, $t8
	srl $t7, $t7, 2
	lw $t9, 4($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 12
	j drawLoop # The actual drawing occurs here
	
# --- GENERAL HELP FUNCTIONS ---
# A wrapper function for returning from a function
Return:
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	jr $t0
# Exits the games
Exit:
	li $v0, 10
	syscall
