;
; sequence.asm
; Description: Chapter 6 example that adds together a sequence of 10 values starting at x3100.
;

; R4 decrementing 10 counter
; R3 value at address
; R2 is address

.ORIG x3000

        AND R1, R1, #0  ; clear R1
        AND R4, R4, #0  ; clear R4
        ADD R4, R4, #10 ; set R4 to be 10
        LD R2, START    ; load starting memory address
REPEAT  LDR R3, R2, #0  ; load value at memory address
        ADD R2, R2, #1  ; increment memory address
        ADD R1, R1, R3  ; add value to accumulator R1
        ADD R4, R4, #-1 ; decrement counter
        BRp REPEAT      ; branch unless zero
        HALT            ; stop

START   .FILL x3100

.END
