;
; calc_v2.asm
; Performs addition/subtraction/multiplication/division/modulus/exponentiation
; between 2 single-digit, user-entered values to produce 1-2 digit result.
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
        ; check for exponentiation
        LD R6, POW
        NOT R6, R6,
        ADD R6, R6, #1  ; negate
        ADD R6, R5, R6  ; subtract to compare
        BRz EXPIT

ADDIT   JSR ADDITION
        BRnzp END

SUBIT   JSR SUBTRACT
        BRnzp END

MULIT   JSR MULTIPLY
        BRnzp END

DIVIT   JSR DIVIDE
        BRnzp END

MODIT   JSR MODULUS
        BRnzp END

EXPIT   JSR EXPONENT
        BRnzp END

END     JSR INT2CHR
        HALT

; --------------------------- ADDITION SUBROUTINE ---------------------------- ;
; Description: performs addition between two values - R1 = R4 + R3
; Inputs: R4 - value 1, R3 - value 2
; Outputs: R1 - sum
ADDITION ADD R1, R3, R4  ; perform addition
         RET             ; return
         ; no need to save/restore registers. only R1 is modified

; ------------------------- SUBTRACTION SUBROUTINE -------------------------- ;
; Description: performs subtraction between two values - R1 = R4 - R3
; Inputs: R4 - minuend, R3 - subtrahend
; Outputs: R1 - difference
SUBTRACT ST R3, SUB_R3  ; save register values

        ; subtract values
        NOT R3, R3
        ADD R3, R3, #1  ; negated R3
        ADD R1, R4, R3  ; R1 = R4 + (-R3)

        LD R3, SUB_R3   ; restore register values
        RET             ; return

SUB_R3  .BLKW 1

; ------------------------ MULTIPLICATION SUBROUTINE ------------------------- ;
; Description: performs multiplication between two values - R1 = R4 * R3
; Inputs: R4 - factor 1, R3 - factor 2
; Outputs: R1 - product
MULTIPLY ST R3, M_R3    ; save register values
        ST R4, M_R4

        ; perform multiplication
        AND R1, R1, #0  ; clear R1
MULT    ADD R1, R1, R4  ; add R4 (factor 1) to R1 accumulator
        ADD R3, R3, #-1 ; subtract one from R3 (factor 2)
        BRp MULT        ; more additions remaining, repeat

        LD R3, M_R3     ; restore register values
        LD R4, M_R4
        RET             ; return

M_R3    .BLKW 1
M_R4    .BLKW 1

; --------------------------- DIVISION SUBROUTINE ---------------------------- ;
; Description: performs division between two values - R1 = R4 / R3
; Inputs: R4 - dividend, R3 - divisor
; Outputs: R1 - quotient
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

; --------------------------- MODULUS SUBROUTINE ---------------------------- ;
; Description: performs modulus between two values - R1 = R4 % R3
; Inputs: R4 - dividend, R3 - divisor
; Outputs: R1 - remainder
MODULUS ST R2, MOD_R2    ; save register values
        ST R3, MOD_R3
        ST R4, MOD_R4

        ; perform modulo or remainder R1 = R4 % R3
        NOT R3, R3
        ADD R3, R3, #1  ; negate R3
MOD     ADD R4, R4, R3  ; R4 = R4 - R3
        ADD R2, R4, R3  ; R2 = R4 - R3
        BRzp MOD        ; repeat
        ADD R1, R4, #0  ; move R4 to R1

        LD R2, MOD_R2   ; restore register values
        LD R3, MOD_R3
        LD R4, MOD_R4
        RET             ; return

MOD_R2    .BLKW 1
MOD_R3    .BLKW 1
MOD_R4    .BLKW 1

; ------------------------ EXPONENTIATION SUBROUTINE ------------------------- ;
; Description: performs exponentiation between two values - R1 = R4 ^ R3
; Inputs: R4 - value 1, R3 - value 2
; Outputs: R1 - result
EXPONENT ST R2, EXP_R2  ; save register values
        ST R3, EXP_R3
        ST R4, EXP_R4
        ST R7, EXP_R7   ; has subroutine call, save R7 for linkage

        ; perform exponentiation R1 = R4 ^ R3
        AND R1, R1, #0  ; clear R1
        ADD R1, R1, #1  ; R1=1 initially in case raised to the power 0
        ADD R2, R3, #0  ; copy R3 to R2 - counter for repeats
        BRz EXP_RET     ; if exponent is zero
        ADD R3, R4, #0  ; copy R4 to R3 - factor 2 for multiplication
        ADD R2, R2, #-1 ; decrement exponent counter, starting with R4^1
EXP_RPT JSR MULTIPLY    ; call multiplication subroutine
        ADD R4, R1, #0  ; copy R1 to R4
        ADD R2, R2, #-1 ; decrement exponent counter
        BRp EXP_RPT     ; repeat if not zero

EXP_RET LD R2, EXP_R2   ; restore register values
        LD R3, EXP_R3
        LD R4, EXP_R4
        LD R7, EXP_R7   ; has subroutine call, restore R7 for linkage
        RET             ; return

EXP_R2  .BLKW 1
EXP_R3  .BLKW 1
EXP_R4  .BLKW 1
EXP_R7  .BLKW 1

; ----------------------- INTEGER TO ASCII SUBROUTINE ------------------------ ;
; Description: converts 1-2 digit integer to ASCII char and prints to console.
; Input: R1 - integer value to convert
; Output: No registers. Prints resulting ASCII characters to console.
INT2CHR ST R0, CONV_R0  ; save register values
        ST R2, CONV_R2
        ST R3, CONV_R3
        ST R4, CONV_R4
        ST R5, CONV_R5
        ST R6, CONV_R6
        ST R7, CONV_R7  ; calls OUT subroutine! save and restore R7

        ; output a equals sign
        LD R0, EQUALS   ; load an equals sign
        OUT             ; output an equals sign
        ; output a space
        LD R0, SP       ; load a Space
        OUT             ; output a Space

        ; check how many digits
        ADD R6, R1, #0  ; move value from R1 to R6
        ADD R5, R6, #-9 ; if less than or equal to 9, than single digit
        BRnz ONEDIG     ; branch to one digit

        ; two bits! what do we do? perform division by 10!
        ; quotient is tens digit (R1), remainder is ones digit (R4)
        ; R1 = R4 / R3
        ADD R4, R6, #0  ; move value from R6 to R4 - dividend
        AND R3, R3, #0  ; clear R3
        ADD R3, R3, #10 ; set R3 to 10 - divisor
        JSR DIVIDE      ; product tens digit
        LD R0, ZERO     ; load ascii offset
        ADD R0, R0, R1  ; add ascii offset
        OUT             ; print tens digit character
        JSR MODULUS     ; produce ones digit
        LD R0, ZERO     ; load ascii offset
        ADD R0, R0, R1  ; add ascii offset
        OUT             ; print ones digit character
        BRnzp STOP      ; unconditionally branch to halt

        ; one digit value
ONEDIG  LD R0, ZERO     ; load ascii offset
        ADD R0, R0, R6  ; add ascii offset
        OUT             ; prints one digit value

STOP    LD R0, LF       ; load linefeed
        OUT
        LD R0, CONV_R0  ; restore register values
        LD R2, CONV_R2
        LD R3, CONV_R3
        LD R4, CONV_R4
        LD R5, CONV_R5
        LD R6, CONV_R6
        LD R7, CONV_R7  ; calls OUT subroutine! restore R7
        RET

CONV_R0    .BLKW 1
CONV_R2    .BLKW 1
CONV_R3    .BLKW 1
CONV_R4    .BLKW 1
CONV_R5    .BLKW 1
CONV_R6    .BLKW 1
CONV_R7    .BLKW 1

; ----------------------- RAW VALUES STORED IN MEMORY ------------------------ ;
EQUALS  .FILL x003D     ; ASCII representation of an equals sign '='
PLUS    .FILL x002B     ; ASCII representation of a plus sign '+'
MINUS   .FILL x002D     ; ASCII representation of a minus sign '-'
STAR    .FILL x002A     ; ASCII representation of a minus sign '*'
SLASH   .FILL x002F     ; ASCII representation of a minus sign '/'
PERC    .FILL x0025     ; ASCII representation of a minus sign '%'
POW     .FILL x005E     ; ASCII representation of a minus sign '^'

SP      .FILL x0020     ; ASCII representation of a space ' '
ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
LF      .FILL x000A     ; ASCII representation of linefeed '\n'

.END
