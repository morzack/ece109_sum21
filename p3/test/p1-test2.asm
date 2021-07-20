;;;This test checks to see how your random apple subroutine
;;;behaves if the apple_y coordinate is >= 124

	.ORIG x6000

	LD R6, APPLE_COLOR
	AND R4, R4, 0
	ADD R4, R4, 13
	ADD R4, R4, 10
	AND R2, R2, 0

LOOP	SUB R7, R4, R2
	BRnz EXIT
	TRAP x43
	ADD R2, R2, 1
	BRnzp LOOP
EXIT
	JSRR R3
	TRAP x41
	SUB R4, R5, R6
	HALT

APPLE_COLOR:		.FILL x7C00
