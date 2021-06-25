;
; add_sub.asm - Performs addition or subtraction between 2 single-digit, user-entered values.
; in class example - june 23
;

; R5 - operation type
; R4 - operand 1
; R3 - operand 2

.ORIG x3000

        ; retrieve operand 1 value from user - convert to integer value
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
        ; retrieve operation
        GETC            ; retrieve character entered
        OUT             ; echo it back to user
        ADD R5, R0, #0  ; move value from R0 to R5
        ; output a space
        LD R0, SP       ; load a Space
        OUT             ; output a Space
        ; retrieve operand value from user - convert to integer value
        GETC            ; retrieve character entered
        OUT             ; echo it back to user
        ADD R3, R0, #0  ; move value from R0 to R3
        ADD R3, R3, R1  ; add negated base to produce numerical value
        ; output a space
        LD R0, SP       ; load a Space
        OUT             ; output a Space

        ; check operation type - '+' = x2B or '-' = x2D
        LD R6, MINUS
        NOT R6, R6,
        ADD R6, R6, #1  ; negate '-'
        ADD R6, R5, R6  ; subtract '-' from
        BRn ADDIT

        ; perform subtraction R1 = R4 - R3
        NOT R3, R3
        ADD R3, R3, #1  ; negated R3
ADDIT   ADD R1, R4, R3  ; R1 = R4 + (-R3)

        ; output a equals sign
        LD R0, EQUALS   ; load an equals sign
        OUT             ; output an equals sign
        ; output a space
        LD R0, SP       ; load a Space
        OUT             ; output a Space
        ; Output difference - convert to ascii (only works for single digit)
        LD R2, ZERO     ; load ASCII Base for zero
        ADD R0, R1, R2  ; add ASCII Offset to count
        OUT             ; output count to console
        LD R0, LF       ; load Linefeed
        OUT             ; output Linefeed
        HALT            ; halt program


EQUALS  .FILL x003D     ; ASCII representation of an equals sign '='
DASH    .FILL x002D     ; ASCII representation of a minus sign '-'
SP      .FILL x0020     ; ASCII representation of a space ' '
ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
LF      .FILL x000A     ; ASCII representation of linefeed '\n'

.END
