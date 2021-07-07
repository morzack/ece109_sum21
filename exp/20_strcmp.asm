;
; Subroutine for comparing strings.
;
; Input: R0 pointer to first string, R1 pointer to second string.
; Output: R5=0 if they match, R5=1 if no match
;
; NOTE: Not an actual program, just a passage of code!
;

STRCMP  ST R0, STR_R0   ; save registers
        ST R1, STR_R1
        ST R2, STR_R2
        ST R3, STR_R3
        AND R5, R5, #0  ; assume a match

NXTCHAR LDR R2, R0, #0  ; char from string 1
        LDR R3, R1, #0  ; char from string 2
        BRnp COMPARE    ; check for end of string 2 - null
        ADD R2, R2, #0  ; do nothing set condition code for string 1
        BRz DONE        ; check for end of string 1 - null

CMP     NOT R2, R2
        ADD R2, R2, #1  ; negate character in string one
        ADD R2, R2, R3  ; compare characters
        BRnp FAIL       ; if zero, chars are equal
        ADD R0, R0, #1  ; increment string 1 pointer to check next char
        ADD R1, R1, #1  ; increment string 2 pointer to check next char
        BR NXTCHAR
FAIL    ADD R5, R5, #1  ; return error value
DONE    LD R0, STR_R0   ; restore registers
        LD R1, STR_R1
        LD R2, STR_R2
        LD R3, STR_R3
        RET

STR_R0  .BLKW 1         ; space to save reg
STR_R1  .BLKW 1         ; space to save reg
STR_R2  .BLKW 1         ; space to save reg
STR_R3  .BLKW 1         ; space to save reg
