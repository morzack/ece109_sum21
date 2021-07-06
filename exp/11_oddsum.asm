;
; oddsum.asm - computes the sum of the odd numbers entered by the user.
;

; R6 - sum

.ORIG x3000

        AND R6, R6, #0
AGAIN   LEA R0, PROMPT  ; load starting address of prompt
        PUTS            ; print the string
        GETC            ; get character from user
        ADD R1, R0, #-10    ; check if newline
        BRz END

        ; check if valid number
        LD R1, NINE     ; ascii for 9 to check if its a number
        NOT R1, R1
        ADD R1, R1, #1  ; negate
        ADD R1, R0, R1  ; check if a number
        BRp AGAIN       ; not a valid number
        LD R1, ZERO     ; ascii for 0 to check if its a number
        NOT R1, R1
        ADD R1, R1, #1  ; negate
        ADD R1, R0, R1  ; check if a number
        BRn AGAIN       ; not a valid number

        ; it's valid!
        OUT             ; valid number so echo out
        LD R0, LF       ; load linefeed value
        OUT             ; print linefeed

        ; check if odd
        LD R2, ODDMASK  ; load mask
        AND R2, R2, R1  ; check if odd
        BRz AGAIN       ; if zero, it's even so skip
        ADD R6, R6, R1  ; it's odd so add to sum
        BRnzp AGAIN     ; unconditional branch to to

END     LEA R0, ENDMSG  ; load starting address of end message
        PUTS            ; print the string

        ; check how many digits
        ADD R5, R6, #-9 ; if less than or equal to 9, than single digit
        BRnz ONEDIG     ; branch to one digit

        ; two bits! what do we do? perform division by 10!
        ; quotient is tens digit (R1), remainder is ones digit (R4)
        ; R1 = R4 / R3
        ADD R4, R6, #0  ; move sum from R6 to R4 - dividend
        AND R1, R1, #0  ; clear R1
        AND R3, R3, #0  ; clear R3
        ADD R3, R3, #-10 ; set R3 to 10 - divisor
DIV     ADD R4, R4, R3  ; continually subtract divisor R3 from dividend R4
        ADD R1, R1, #1  ; increment our quotient R1
        ADD R2, R4, R3  ; check if we can subtract divisor again
        BRzp DIV        ; more subtractions left, repeat

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
STOP    HALT


SP      .FILL x0020     ; ASCII representation of a space ' '
ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
NINE    .FILL x0039     ; ASCII offset for ASCII->Integer conversions
LF      .FILL x000A     ; ASCII representation of linefeed '\n'
ODDMASK .FILL x0001     ; bitmask for checking if odd
PROMPT  .STRINGZ "Enter Number (0-9):  "
ENDMSG  .STRINGZ "\nThe sum of the odd numbers: "

.END
