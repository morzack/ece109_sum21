;
; multiply.asm
; Description: Chapter 6 example that multiplies two values.
;

; R4 - factor 1
; R3 - factor 2

.ORIG x3000

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

        ; Perform multiplication
        AND R2, R2, #0  ; clear R2
MULT    ADD R2, R2, R4  ; add R4 to R2 accumulator
        ADD R3, R3, #-1 ; subtract one from R3 (factor 2)
        BRp MULT        ; more additions remaining, repeat

        ; Output product - convert to ascii (only works for single digit)
        LD R1, ZERO     ; load ASCII Base for zero
        ADD R0, R1, R2  ; add ASCII Offset to count
        OUT             ; output count to console
        LD R0, LF       ; load Linefeed
        OUT             ; output Linefeed
        HALT            ; halt program


SP      .FILL x0020     ; ASCII representation of a space ' '
ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
LF      .FILL x000A     ; ASCII representation of linefeed '\n'

.END
