;
; os_subroutines.asm - demonstration of OS subroutines
;

.ORIG x3000

        ; get inputs
        IN              ; gets character, stores in R0, provides prompt/echo
        OUT             ; already echoed above, print again so it's on next line
        ADD R1, R0, #0  ; moves value from R0 to R1

        LEA R0, OP      ; loads effective address of starting point of string
        PUTS            ; prints entire string to console

        GETC            ; gets character from user, stores in R0
        OUT             ; prints character stored in R0
        ADD R2, R0, #0  ; moves value from R0 to R2

        ; convert values to integer
        LD R3, ZERO     ; load value for conversion to integer
        NOT R3, R3
        ADD R3, R3, #1  ; negates value
        ADD R1, R1, R3  ; converts to integer
        ADD R2, R2, R3  ; converts to integer

        ; compute sum and convert to ASCII
        LEA R0, RESULT  ; loads effective address of starting point of string
        PUTS            ; print string to console
        ADD R0, R1, R2  ; compute sum
        LD R3, ZERO     ; load value for conversion to integer
        ADD R0, R0, R3  ; convert to ascii character
        OUT             ; output result

        HALT            ; stop execution of program


ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
OP      .STRINGZ " + "
RESULT  .STRINGZ "\n The resulting sum is: "

.END
