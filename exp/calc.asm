;
; calc.asm - Performs addition/subtraction/multiplication/division/modulus
; between 2 single-digit, user-entered values.
; in class example - june 30
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

        ; check operation type
        ; check for subtraction
        LD R6, MINUS
        NOT R6, R6,
        ADD R6, R6, #1  ; negate
        ADD R6, R5, R6  ; subtract to compare
        BRz SUBIT
        ; check for addition
        LD R6, PLUS
        NOT R6, R6,
        ADD R6, R6, #1  ; negate
        ADD R6, R5, R6  ; subtract to compare
        BRz ADDIT
        ; check for multiply
        LD R6, STAR
        NOT R6, R6,
        ADD R6, R6, #1  ; negate
        ADD R6, R5, R6  ; subtract to compare
        BRz MULIT
        ; check for divide
        LD R6, SLASH
        NOT R6, R6,
        ADD R6, R6, #1  ; negate
        ADD R6, R5, R6  ; subtract to compare
        BRz DIVIT
        ; check for modulo
        LD R6, PERC
        NOT R6, R6,
        ADD R6, R6, #1  ; negate
        ADD R6, R5, R6  ; subtract to compare
        BRz MODIT

        ; perform subtraction R1 = R4 - R3
SUBIT   NOT R3, R3
        ADD R3, R3, #1  ; negated R3
ADDIT   ADD R1, R4, R3  ; R1 = R4 + (-R3)
        BRnzp END       ; unconditionally branch to displaying result

        ; perform multiplication R1 = R4 * R3
MULIT   AND R1, R1, #0  ; clear R1
MULT    ADD R1, R1, R4  ; add R4 to R1 accumulator
        ADD R3, R3, #-1 ; subtract one from R3 (factor 2)
        BRp MULT        ; more additions remaining, repeat
        BRnzp END       ; unconditionally branch to displaying result

        ; perform division R1 = R4 // R3
        ; integer division - drops fractional portion
        ; R1 = R4 // R3  aka integer division - drops fractional portion
        ; R4 = R4 % R3  aka modulo or remainder
DIVIT   AND R1, R1, #0  ; clear R1
        NOT R3, R3
        ADD R3, R3, #1  ; negate R3
DIV     ADD R4, R4, R3  ; continually subtract divisor R3 from dividend R4
        ADD R1, R1, #1  ; increment R1
        ADD R2, R4, R3  ; check if we can subtract divisor again
        BRzp DIV        ; repeat subtraction for division
        BRnzp END       ; unconditionally branch to displaying result

        ; perform modulo or remainder R1 = R4 % R3
MODIT   NOT R3, R3
        ADD R3, R3, #1  ; negate R3
DIV2    ADD R4, R4, R3  ; R4 = R4 - R3
        ADD R2, R4, R3  ; R2 = R4 - R3
        BRzp DIV2       ; repeat
        ADD R1, R4, #0  ; move R4 to R1

        ; output a equals sign
END     LD R0, EQUALS   ; load an equals sign
        OUT             ; output an equals sign
        ; output a space
        LD R0, SP       ; load a Space
        OUT             ; output a Space
        ; output difference - convert to ascii (only works for single digit)
        LD R2, ZERO     ; load ASCII Base for zero
        ADD R0, R1, R2  ; add ASCII Offset to count
        OUT             ; output count to console
        LD R0, LF       ; load Linefeed
        OUT             ; output Linefeed
        HALT            ; halt program


EQUALS  .FILL x003D     ; ASCII representation of an equals sign '='
PLUS    .FILL x002B     ; ASCII representation of a plus sign '+'
MINUS   .FILL x002D     ; ASCII representation of a minus sign '-'
STAR    .FILL x002A     ; ASCII representation of a minus sign '*'
SLASH   .FILL x002F     ; ASCII representation of a minus sign '/'
PERC    .FILL x0025     ; ASCII representation of a minus sign '%'

SP      .FILL x0020     ; ASCII representation of a space ' '
ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
LF      .FILL x000A     ; ASCII representation of linefeed '\n'

.END
