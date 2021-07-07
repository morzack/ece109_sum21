;
; Subroutines for carrying out the PUSH and POP functions. This
; program works with a stack consisting of memory locations x3FFF
; through x3FFB. R6 is the stack pointer.
;
; NOTE: Not an actual program, just a passage of code!
;

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
