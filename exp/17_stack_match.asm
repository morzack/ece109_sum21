;
; stack_match.asm - uses a stack to ensure matching open/close parenthesis
;

.ORIG x3000

        LD R6, STACK    ; load starting point of stack

AGAIN   GETC            ; get character from user
        OUT             ; echo

        ; check if LF
        LD R1, LF
        NOT R1, R1
        ADD R1, R1, #1  ; negate R1 for comparison
        ADD R1, R0, R1  ; perform comparison for LF
        BRz END         ; found LF so branch to end

        ; check if open parentheses
        LD R1, OPEN
        NOT R1, R1
        ADD R1, R1, #1  ; negate R1 for comparison
        ADD R1, R0, R1  ; perform comparison for '('
        BRz OPN_DET     ; detected '('

        ; check if close parentheses
        LD R1, CLOSE
        NOT R1, R1
        ADD R1, R1, #1  ; negate R1 for comparison
        ADD R1, R0, R1  ; perform comparison for ')'
        BRz CLS_DET     ; detected ')'
        BRnzp AGAIN

OPN_DET JSR PUSH        ; call push subroutine
        BRnzp CHECK     ; branch to check for under/overflow
CLS_DET JSR POP         ; call pop subroutine

CHECK   ADD R5, R5, #0  ; check condition codes of R5 for under/overflow
        BRp ERROR       ; if positive, then there was an error
        BRnzp AGAIN     ; unconditional branch to collect next value

ERROR   LEA R0, ST_ERR  ; load stack error string
        PUTS            ; print stack error string
        HALT            ; halt program

END     LD R1, EMPTY    ; load -x4000 to check if stack is empty
        ADD R1, R1, R6  ; add to compare
        BRz SUCC        ; if zero, success

        LEA R0, NOMATCH ; otherwise, it failed
        PUTS            ; print failure string
        HALT            ; halt

SUCC    LEA R0, MATCH   ; load string for successful match
        PUTS            ; print success string
        HALT            ; halt

; ----------------------- PUSH/POP STACK SUBROUTINES ------------------------- ;
; Description: push/pop subroutines for stack
; Inputs: R6 - stack pointer
; PUSH input: R0 - value to be pushed on stack
; Outputs: R5 - 0 (success) or 1 (failure)
; POP output: R0 - value popped off of stack
; NOTE: update FULL/EMPTY based on starting point and size of stack
POP     ST R1, PP_R1    ; save registers
        ST R2, PP_R2
        AND R5, R5, #0  ; assume no underflow
        LD R1, EMPTY    ; check whether R6 is at bottom, negative x4000
        ADD R1, R6, R1  ; compare stack pointer to x4000
        BRz PP_FAIL     ; branch if stack is empty

        ; the actual 'pop'
        LDR R0, R6, #0  ; if no underflow, get data
        ADD R6, R6, #1  ; increment stack pointer
        BRnzp PP_SUCC

PUSH    ST R1, PP_R1    ; save registers
        ST R2, PP_R2
        AND R5, R5, #0  ; assume no overflow
        LD R1, FULL     ; check whether R6 is at top, negative x3FFB
        ADD R1, R6, R1  ; compare stack pointer to x3FFB
        BRz PP_FAIL     ; branch if stack is full

        ; the actual 'push'
        ADD R6, R6, #-1 ; if no overflow, push
        STR R0, R6, #0

PP_SUCC LD R1, PP_R1    ; restore registers
        LD R2, PP_R2    ; restore registers
        RET             ; return with R5=0

PP_FAIL LD R1, PP_R1    ; restore registers
        LD R2, PP_R2    ; restore registers
        ADD R5, R5, #1  ; set R5 to indicate failure
        RET             ; return with R5=1

FULL    .FILL xC005     ; negative of x3FFB
EMPTY   .FILL xC000     ; negative of x4000

PP_R1   .BLKW 1
PP_R2   .BLKW 1

; ----------------------- RAW VALUES STORED IN MEMORY ------------------------ ;
STACK   .FILL x4000     ; beginning of stack

OPEN    .FILL x0028     ; ASCII representation of '('
CLOSE   .FILL x0029     ; ASCII representation of ')'
LF      .FILL x000A     ; ASCII representation of a linefeed '\n'

ST_ERR  .STRINGZ "Stack error!\n"
MATCH   .STRINGZ "Parentheses match!\n"
NOMATCH .STRINGZ "Parentheses do not match!\n"

.END
