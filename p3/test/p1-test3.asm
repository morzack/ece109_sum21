;;;This test checks to see how your random apple subroutine
;;;behaves if the block at which to draw the apple isn't empty

.ORIG x6000

LD R6, APPLE_COLOR

; AND R0, R0, 0
; ADD R0, R0, 13
; AND R1, R1, 0
; ADD R1, R1, 15
; ADD R1, R1, 4
LD R0, TESTX_COORD
LD R1, TESTY_COORD
AND R2, R2, 0
ADD R2, R2, -1
TRAP x40

JSRR R3
TRAP x41
SUB R4, R5, R6
HALT

APPLE_COLOR:		.FILL x7C00

TESTX_COORD .FILL x002D
TESTY_COORD .FILL x0053
