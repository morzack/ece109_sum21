;;;This test checks advancing the snake
;;;into an apple

	.ORIG x6000
	LEA R3, TEST_SNAKE

	LDR R0, R3, 6
	LDR R1, R3, 7
	LDR R2, R3, 5
	TRAP x40

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
	AND R1, R1, 0	;R1 = left
	ADD R2, R1, 1	;R2 = up
	ADD R3, R1, 2	;R3 = right
	ADD R4, R1, 3	;R4 = down

	STR R2, R0, 4
	JSRR R5
	LDR R5, R0, 1		;R5 contains headoffset
	ADD R6, R5, R0
	ADD R6, R6, 6
	LDR R5, R6, 0		;R5 contains headx
	LDR R5, R6, 1		;R5 contains heady
	LDR R5, R0, 3		;R5 contains growcount
	LDR R5, R0, 0		;R5 contains tailcount
	HALT

			.FILL x0000
TEST_APPLE_COLOR     .FILL x7C00
ARBITRARY_COLOR:	.FILL x6354

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
