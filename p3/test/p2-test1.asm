;;;This test checks several consecutive enqueues
;;;and the circuluar queue wrap-around condition

	.ORIG x6000
	LEA R0, TEST_SNAKE
	AND R5, R5, 0
	ADD R5, R5, -1
	AND R4, R4, 0
	ADD R4, R4, 4

LOOP:	ADD R4, R4, -1
	BRnz CONT
	ADD R5, R5, 2
	ADD R6, R5, 1
	JSRR R1
	LDR R2, R0, 1 ;
	ADD R2, R2, R0
	ADD R2, R2, 6 ;
	LDR R3, R2, 1
	LDR R2, R2, 0
	BRnzp LOOP

CONT:	LD R2, NEW_POSITION
	STR R2, R0, 1 ;
	ADD R5, R5, 2
	ADD R6, R5, 1
	JSRR R1
	LDR R2, R0, 1 ;
	ADD R2, R2, R0
	ADD R2, R2, 6 ;
	LDR R3, R2, 1
	LDR R2, R2, 0

	HALT

NEW_POSITION:		.FILL x00FE

TEST_SNAKE:
        .FILL x0000  ; HeadOff +0
MY_TEST_SNAKE:      .FILL x0000  ; TailOff +1
		.FILL x0002  ; size +2
        .FILL x4     ; GrowCount +3
        .FILL x3     ; Direction +4
        .FILL x8AA8  ; Color +5
        .FILL 20     ; Start of Position Queue +6
        .FILL 10
        .BLKW 254 ;2x128-2
