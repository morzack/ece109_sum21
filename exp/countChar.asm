;
; countChar.asm - Chapter 5/6 example
; Description: Counts occurrences of user-entered character in memory
; in class example - june 30
;

; R3 - address of first character to read from file
; R2 - counter
; R1 - first character from file
; R0 - character from keyboard

.ORIG x3000

        ; ; prints all characters in memory until the end
        ; LEA R0, PANGRAM
        ; PUTS
        ; HALT

        ; character counting program
        AND R2, R2, #0  ; clear R0
        LEA R3, PANGRAM ; load starting memory location into R3
        GETC            ; retrieve character from user to check for
AGAIN   LDR R1, R3, #0  ; Load character from first/next memory location
        BRz END         ; if zero, found end of string

        NOT R1, R1
        ADD R1, R1, #1  ; negate R1
        ADD R1, R1, R0  ; Subtract character from user's character
        BRnp SKIP       ; if zero, then we found a match, don't branch
        ADD R2, R2, #1  ; found character increment counter
SKIP    ADD R3, R3, #1  ; increment memory location to load next value
        BRnzp AGAIN     ; unconditional branch

END     LD R0, ZERO     ; load ASCII offset to convert integer to ASCII
        ADD R0, R0, R2  ; convert count to integer
        OUT             ; print count to console
        HALT            ; halt program

ZERO    .FILL x0030     ; ASCII offset for ASCII->Integer conversions
PANGRAM .STRINGZ "Waltz, bad nymph, for quick jigs vex. The quick brown fox jumps over the lazy dog. Glib jocks quiz nymph to vex dwarf. How vexingly quick daft zebras jump! The five boxing wizards jump quickly."

.END
