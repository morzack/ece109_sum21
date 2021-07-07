;
; Subroutines for carrying out the insert and remove functions for a queue.
; Queue begins at address x8000 and ends at address x8005. Size 5
; Described in detail in section 8.4 pg 298.
;
; Input: R0 for item to be inserted, R3 is front, R4 is rear
; Output: R0 for item to be removed, R5 is success code
;
; NOTE: Not an actual program, just a passage of code!
;

; --------------------- INSERT/REMOVE QUEUE SUBROUTINES ---------------------- ;
; Description: insert/remove subroutines for queue
; Inputs: R3 - front/head, R4 is rear/tail
; INSERT input: R0 - value to be inserted into queue
; Outputs: R5 - 0 (success) or 1 (failure)
; REMOVE output: R0 - value to be remove from queue
; NOTE: update FIRST/LAST based on start point and end point of queue
INSERT  ST R1, Q_R1    ; save registers
        AND R5, R5, #0 ; set R5 to success code
        LD R1, NEG_LST
        ADD R1, R1, R4  ; R1 = rear - x8005
        BRnp SKIP1      ; skip wrap around
        LD R4, FIRST    ; wraparound, R4 = x8000
        BRnzp SKIP2     ; unconditional branch
SKIP1   ADD R4, R4, #1  ; if no wrap, increment rear ptr
SKIP2   NOT R1, R4
        ADD R1, R1, #1  ; negate rear
        ADD R1, R1, R3  ; compare front to rear
        BRz FULL        ; match so queue is full
        STR R0, R4, #0  ; not full, perform insert
        BRnzp DONE      ; unconditional branch
FULL    LD R1, NEG_1ST  ; if full, undo rear ptr move
        ADD R1, R1, R4  ; R1 = rear - x8000
        BRnp SKIP3
        LD R4, LAST     ; undo wraparound
        BR SKIP4
SKIP3   ADD R4, R4, #-1 ; if no wrap, undo increment
SKIP4   ADD R5, R5, #1  ; return error value
        BRnzp DONE


REMOVE  ST R1, Q_R1    ; save registers
        AND R5, R5, #0 ; set R5 to success code
        NOT R1, R4
        ADD R1, R1, #1  ; negate rear
        ADD R1, R1, R3  ; compare front and rear
        BRz EMPTY
        LD R1, NEG_LST
        ADD R1, R1, R3  ;
        BRnp SKIP5
        LD R3, FIRST    ; R3 = x8000
        BRnzp SKIP6
SKIP5   ADD R3, R3, #1  ; increment front
SKIP6   LDR R0, R3, #0  ; perform remove
        BRnzp DONE
EMPTY   ADD R5, R5, #1  ; set failure code
DONE    LD R1, Q_R1     ; restore register
        RET

Q_R1    .BLKW 1

FIRST   .FILL x8000     ; starting address of queue storage
NEG_1ST .FILL x8000     ; negative of FIRST - causes overflow and will produce 0
LAST    .FILL x8005     ; ending address of queue storage
NEG_LST .FILL x7FFB     ; negative of LAST
