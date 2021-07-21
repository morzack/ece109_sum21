;;;This test checks several consecutive dequeues
;;;and the circuluar queue wrap-around condition

	.ORIG x6000
	LEA R0, TEST_SNAKE
	ADD R2, R0, 6
	AND R3, R3, 0
	ADD R3, R3, 6
	AND R7, R7, 0
	ADD R7, R7, 6

LOOP:	ADD R7, R7, -1
	BRn CONT
	ADD R4, R2, R7
	STR R3, R4, 0
	ADD R3, R3, -1
	BRnzp LOOP

CONT:	JSRR R1
	LDR R7, R0, 0 ;
	JSRR R1
	LDR R7, R0, 0 ;
	JSRR R1
	LDR R7, R0, 0 ;

	AND R3, R3, 0
	ADD R3, R3, 7
	LD R7, NEW_POSITION
	STR R7, R0, 0 ;
	ADD R4, R2, R7
	STR R3, R4, 0
	ADD R3, R3, 1
	STR R3, R4, 1

	JSRR R1
	LDR R7, R0, 0 ;

	HALT

NEW_POSITION:		.FILL x00FE

TEST_SNAKE:
        .FILL x0000  ; HeadOff +0
        .FILL x0000  ; TailOff +1
		.FILL x0002	 ; size +2
        .FILL x4     ; GrowCount +3
        .FILL x3     ; Direction +4
        .FILL x8AA8  ; Color +5
        .FILL 20     ; Start of Position Queue +6
        .FILL 10
        .BLKW 254 ;2x128-2
