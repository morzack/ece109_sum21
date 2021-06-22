;
; ld.asm - load demonstration
; use with ld_data.asm
;

.ORIG x3000

; Retrieve both of the values to multiply and convert to integers
        ; LD R1, DATA     ; loads x4000 into R1
        ; LDI R2, DATA    ; loads value at x4000 into R2 - Method 1 - 1 step
        ; LDR R3, R1, #0  ; loads value at x4000 into R3 - Method 2 - 2 steps

        LD R1, DATA     ; loads x4000 into R1
REPEAT  LDR R0, R1, #0  ; loads value at x4000 into R3 - Method 2 - 2 steps
        BRz END
        OUT
        ADD R1, R1, #1
        BRnzp REPEAT
END     HALT

DATA    .FILL x4000

.END
