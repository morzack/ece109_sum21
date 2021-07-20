;;;This tests the results of GetNext for all 4 directions

	.ORIG x6000
	LEA R0, TEST_SNAKE
	JSRR R1			;move down

	AND R2, R2, 0
	STR R2, R0, 4
	JSRR R1			;move left

	ADD R2, R2, 1
	STR R2, R0, 4
	JSRR R1			;move up

	ADD R2, R2, 1
	STR R2, R0, 4
	JSRR R1			;move right

	STR R2, R0, 1
	ADD R3, R2, 3
	STR R3, R0, 8
	ADD R3, R3, 1
	STR R3, R0, 9

	ADD R2, R2, 1
	STR R2, R0, 4
	JSRR R1			;move down

	ADD R2, R2, -1
	STR R2, R0, 4
	JSRR R1			;move right

	ADD R2, R2, -1
	STR R2, R0, 4
	JSRR R1			;move up

	ADD R2, R2, -1
	STR R2, R0, 4
	JSRR R1			;move left

	HALT

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
