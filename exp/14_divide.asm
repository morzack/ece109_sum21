;
; divide.asm
; Description: Chapter 8 example performs division between two values
;

; R4 - factor 1
; R3 - factor 2

.ORIG x3000

; ------------------------------- MAIN ROUTINE ------------------------------- ;
        ; retrieve factor 1 from user - convert to integer value
        GETC            ; retrieve character entered
        OUT             ; echo it back to user
        ADD R4, R0, #0  ; move value from R0 to R4
        LD R1, ZERO     ; load ASCII Base for zero
        NOT R1, R1
        ADD R1, R1, #1  ; negate ASCII base
        ADD R4, R4, R1  ; add negated base to produce numerical value
        ; output a space
        LD R0, SP       ; load a Space
        OUT             ; output a Space
        ; retrieve factor 2 from user - convert to integer value
        GETC            ; retrieve character entered
        OUT             ; echo it back to user
        ADD R3, R0, #0  ; move value from R0 to R3
        ADD R3, R3, R1  ; add negated base to produce numerical value
        ; output a space
        LD R0, SP       ; load a Space
        OUT             ; output a Space

        JSR DIVIDE      ; call division subroutine
        JSR INT2CHR     ; call subroutine to convert 1/2 digit int to char
        HALT            ; halt program


; ------------------------ MULTIPLICATION SUBROUTINE ------------------------- ;
; Description: performs multiplication between two values - R1 = R3 * R4
; Inputs: R3 - factor 1, R4 - factor 2
; Outputs: R1 - product
DIVIDE  ST R2, D_R2    ; save register values
        ST R3, D_R3
        ST R4, D_R4

        ; perform division R1 = R4 / R3
        ; integer division - drops fractional portion
        AND R1, R1, #0  ; clear R1
        NOT R3, R3
        ADD R3, R3, #1  ; negate R3
DIV     ADD R4, R4, R3  ; continually subtract divisor R3 from dividend R4
        ADD R1, R1, #1  ; increment R1
        ADD R2, R4, R3  ; check if we can subtract divisor again
        BRzp DIV        ; repeat subtraction for division

        LD R2, D_R2     ; restore register values
        LD R3, D_R3
        LD R4, D_R4
        RET             ; return

D_R2    .BLKW 1
D_R3    .BLKW 1
D_R4    .BLKW 1

; ----------------------- INTEGER TO ASCII SUBROUTINE ------------------------ ;
; Description: converts 1-2 digit integer to ASCII char and prints to console.
; Input: R1 - integer value to convert
; Output: No registers. Prints resulting ASCII characters to console.
INT2CHR ST R2, CONV_R2  ; save register values
        ST R3, CONV_R3
        ST R4, CONV_R4
        ST R5, CONV_R5
        ST R6, CONV_R6
        ST R7, CONV_R7  ; calls OUT subroutine! save and restore R7

        ; check how many digits
        ADD R6, R1, #0  ; move value from R1 to R6
        ADD R5, R6, #-9 ; if less than or equal to 9, than single digit
        BRnz ONEDIG     ; branch to one digit

        ; two bits! what do we do? perform division by 10!
        ; quotient is tens digit (R1), remainder is ones digit (R4)
        ; R1 = R4 / R3
        ADD R4, R6, #0  ; move sum from R6 to R4 - dividend
        AND R1, R1, #0  ; clear R1
        AND R3, R3, #0  ; clear R3
        ADD R3, R3, #-10 ; set R3 to 10 - divisor
        JSR DIVIDE
; DIV     ADD R4, R4, R3  ; continually subtract divisor R3 from dividend R4
;         ADD R1, R1, #1  ; increment our quotient R1
;         ADD R2, R4, R3  ; check if we can subtract divisor again
;         BRzp DIV        ; more subtractions left, repeat

        ; output tens digit
        LD R0, ZERO     ; load ascii offset
        ADD R0, R0, R1  ; add ascii offset
        OUT             ; print tens digit character
        ; output ones digit
        LD R0, ZERO     ; load ascii offset
        ADD R0, R0, R4  ; add ascii offset
        OUT             ; print ones digit character
        BRnzp STOP      ; unconditionally branch to halt

        ; one digit value
ONEDIG  LD R0, ZERO     ; load ascii offset
        ADD R0, R0, R6  ; add ascii offset
        OUT             ; prints one digit value

STOP    LD R0, LF       ; load linefeed
        OUT
        LD R2, CONV_R2  ; restore register values
        LD R3, CONV_R3
        LD R4, CONV_R4
        LD R5, CONV_R5
        LD R6, CONV_R6
        LD R7, CONV_R7  ; calls OUT subroutine! restore R7
        RET

CONV_R2    .BLKW 1
CONV_R3    .BLKW 1
CONV_R4    .BLKW 1
CONV_R5    .BLKW 1
CONV_R6    .BLKW 1
CONV_R7    .BLKW 1

SP      .FILL x0020     ; ASCII representation of a space ' '
ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
LF      .FILL x000A     ; ASCII representation of linefeed '\n'

.END
