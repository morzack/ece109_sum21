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
; Description: insert/remove subroutines for queue.
; Inputs:
;   R3 - front/head
;   R4 - rear/tail
;   R0 - value to be inserted into queue at rear (INSERT only)
; Outputs:
;   R5 - 0 (success) or 1 (failure)
;   R0 - value to be remove from queue at front (REMOVE only)
; NOTE: update FIRST/LAST based on start point and end point of queue

; insert - increment (with wraparound) rear pointer and store value
INSERT  ST R1, Q_R1     ; save registers
        ST R2, Q_R2     ; save registers
        AND R5, R5, #0  ; set R5 to success code
        ADD R2, R4, #0  ; R2=rear to restore if overflow (changed from book)
        LD R1, NEG_LST  ; load negated last memory location
        ADD R1, R1, R4  ; R1 = rear - last
        BRnp SKIP1      ; skip wrap around
        LD R4, FIRST    ; wraparound, rear = first memory location
        BRnzp SKIP2     ; unconditional branch
SKIP1   ADD R4, R4, #1  ; if no wrap, increment rear
SKIP2   NOT R1, R4      ; negate rear, move to R1
        ADD R1, R1, #1  ; negate rear
        ADD R1, R1, R3  ; compare front and rear
        BRz FULL        ; if zero, queue is full overflow
        STR R0, R4, #0  ; perform insert
        BRnzp DONE      ; unconditional branch
FULL    ADD R4, R2, #0  ; restore initial rear in R2 (changed from book)
        ADD R5, R5, #1  ; return error value
        BRnzp DONE

; remove - increment (with wraparound) front pointer and remove value
REMOVE  ST R1, Q_R1     ; save registers
        ST R2, Q_R2     ; save registers
        AND R5, R5, #0  ; set R5 to success code
        NOT R1, R4      ; negate rear, move to R1
        ADD R1, R1, #1  ; negate rear
        ADD R1, R1, R3  ; compare front and rear
        BRz EMPTY       ; if zero, queue is empty, underflow
        LD R1, NEG_LST  ; not empty, load negated last
        ADD R1, R1, R3  ; R1 = front - last
        BRnp SKIP5      ; front!=last, no need to wraparound
        LD R3, FIRST    ; wraparound, rear = first memory location
        BRnzp SKIP6     ; skip increment
SKIP5   ADD R3, R3, #1  ; increment front
SKIP6   LDR R0, R3, #0  ; perform remove
        BRnzp DONE      ; skip failure code
EMPTY   ADD R5, R5, #1  ; set failure code
DONE    LD R1, Q_R1     ; restore register
        LD R2, Q_R2     ; restore register
        RET

Q_R1    .BLKW 1
Q_R2    .BLKW 1

FIRST   .FILL x4000     ; starting address of queue storage
NEG_1ST .FILL xC000     ; negative of FIRST
LAST    .FILL x4005     ; ending address of queue storage
NEG_LST .FILL xBFFB     ; negative of LAST
