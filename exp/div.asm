;
; division - Performs dvision between 2 single-digit, user-entered values.
; in class example - june 29
;

; R4 - dividend
; R3 - divisor

.ORIG x3000

        ; retrieve dividend value from user - convert to integer value
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
        ; retrieve divisor value from user - convert to integer value
        GETC            ; retrieve character entered
        OUT             ; echo it back to user
        ADD R3, R0, #0  ; move value from R0 to R3
        ADD R3, R3, R1  ; add negated base to produce numerical value
        ; output a space
        LD R0, SP       ; load a Space
        OUT             ; output a Space

        ; R1 = R4 // R3  aka integer division - drops fractional portion
        ; R4 = R4 % R3  aka modulo or remainder
        AND R1, R1, #0  ; clear R1
        NOT R3, R3
        ADD R3, R3, #1  ; negated R3
DIV     ADD R4, R4, R3  ; R4 = R4 - R3
        ADD R1, R1, #1  ; increment R1
        ADD R2, R4, R3  ; R2 = R4 - R3
        BRzp DIV

        ; Output quotient/remainder - convert to ascii (only works for single digit)
DONE    LD R5, ZERO     ; load ASCII Base for zero
        ADD R0, R1, R5  ; add ASCII Offset to count
        OUT             ; output count to console
        LD R0, S        ; load a Space
        OUT             ; output a Space
        ADD R0, R4, R5  ; add ASCII Offset to count
        OUT             ; output count to console
        LD R0, LF       ; load Linefeed
        OUT             ; output Linefeed
        HALT            ; halt program


SP      .FILL x0020     ; ASCII representation of a space ' '
ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
LF      .FILL x000A     ; ASCII representation of linefeed '\n'

.END
