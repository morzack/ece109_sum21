;;;This test checks for the proper placement
;;;of the first 5 random apples.

.ORIG x6000

LD R6, APPLE_COLOR

JSRR R3
TRAP x41
SUB R4, R5, R6

JSRR R3
TRAP x41
SUB R4, R5, R6

JSRR R3
TRAP x41
SUB R4, R5, R6

JSRR R3
TRAP x41
SUB R4, R5, R6

JSRR R3
TRAP x41
SUB R4, R5, R6
HALT

APPLE_COLOR     .FILL x7C00
