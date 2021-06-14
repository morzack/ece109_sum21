;
; countOnes.asm
; Author: G. Byrd
; Revised: Michael D'Argenio
; Date: March 2013
; Description: This program counts number of ones in ASCII characters entered by user.
;

.ORIG x3000

MYSTART GETC                ; Retrieve character entered
        OUT                 ; Echo it back to user
        ADD R1, R0, #0      ; Move value from R0 to R1
        LD R0, SP           ; Load a Space
        OUT                 ; Output a Space
        AND R0, R0, #0      ; Set R0 to zero
        ADD R2, R0, #7      ; Set R2 to 7 - count 7 characters
        ADD R3, R0, #1      ; Set R3 to 1 - R3 is shifting bit mask
COUNT   AND R4, R1, R3      ; Increment our counter
        BRz NOTONE          ; Zero - Branch, no one detected
        ADD R0, R0, #1      ; Increment counter
NOTONE  ADD R3, R3, R3      ; Double R3 - i.e. shift bit mask to left
        ADD R2, R2, #-1     ; Decrement R2
        BRp COUNT           ; Still positive, check next bit
        LD R1, ZERO         ; Load ASCII Base for zero
        ADD R0, R0, R1      ; ADD ASCII Offset to count
        OUT                 ; Output count to console
        LD R0, LF           ; Load Linefeed
        OUT                 ; Output Linefeed
        HALT                ; Stop

SP      .FILL x0020
ZERO    .FILL x0030
LF      .FILL x000A

.END
