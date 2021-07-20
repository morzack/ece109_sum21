;;;This tests each type of collision in the game

	.ORIG x6000
	LEA R3, TEST_SNAKE

	LDR R0, R3, 6
	LDR R1, R3, 7

	ADD R1, R1, -1
	LD R2, TEST_APPLE_COLOR
	TRAP x40

	ADD R1, R1, 2
	AND R2, R2, 0
	ADD R2, R2, -1
	TRAP x40

	ADD R1, R1, -1
	ADD R0, R0, 1
	LD R2, ARBITRARY_COLOR
	TRAP x40

	ADD R0, R3, 0
	JSRR R4

	AND R1, R1, 0
	STR R1, R0, 4
	JSRR R4

	ADD R1, R1, 1
	STR R1, R0, 4
	JSRR R4

	ADD R1, R1, 1
	STR R1, R0, 4
	JSRR R4


	HALT

TEST_APPLE_COLOR:      	.FILL x7C00
ARBITRARY_COLOR:	.FILL x6354

TEST_SNAKE:
        .FILL x0000  ; HeadOff +0
        .FILL x0000  ; TailOff +1
		.FILL x0000  ; size
        .FILL x4     ; GrowCount +2
        .FILL x3     ; Direction +3
        .FILL x8AA8  ; Color +4
        .FILL 20     ; Start of Position Queue +5
        .FILL 10
        .BLKW 254 ;2x128-2
