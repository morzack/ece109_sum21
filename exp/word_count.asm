;
; word_count.asm - counts number of words in a string
; in class example - june 30
; string has 35 words
;

; R4 - counter
; R3 - address of first character to read from file
; R2 - first character from file

.ORIG x3000

        ; word counting program
        AND R4, R4, #0  ; clear R4
        ADD R4, R4, #1  ; set R4 to 1
        LEA R3, PANGRAM ; load starting memory location into R3
AGAIN   LDR R2, R3, #0  ; Load character from first/next memory location
        BRz END         ; if zero, found end of string

        LD R1 SPACE
        NOT R1, R1
        ADD R1, R1, #1  ; negate R1
        ADD R1, R2, R1  ; Subtract character from user's character
        BRnp SKIP       ; if zero, then we found a match, don't branch
        ADD R4, R4, #1  ; found character increment counter
SKIP    ADD R3, R3, #1  ; increment memory location to load next value
        BRnzp AGAIN     ; unconditional branch

        ; BELOW COPIED FROM oddsum.asm TO PRINT TWO DIGIT INTEGERS
        ; check how many digits
END     ADD R5, R4, #-9 ; if less than or equal to 9, than single digit
        BRnz ONEDIG     ; branch to one digit

        ; two bits! what do we do? perform division by 10!
        ; quotient is tens digit (R1), remainder is ones digit (R4)
        ; R1 = R4 / R3
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

ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
SPACE   .FILL x0020     ; ASCII hex code for a space or ' '
PANGRAM .STRINGZ "Waltz, bad nymph, for quick jigs vex. The quick brown fox jumps over the lazy dog. Glib jocks quiz nymph to vex dwarf. How vexingly quick daft zebras jump! The five boxing wizards jump quickly."

.END
