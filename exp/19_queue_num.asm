;
; queue_num.asm - use queue to store only the 5 most recent one-digit numbers.
;

.ORIG x3000

        LD R3, FIRST    ; initialize front/head
        LD R4, FIRST    ; initialize rear/tail

AGAIN   GETC            ; retrieve character from user
        ; check if LF
        LD R1, LF       ; load linefeed
        NOT R1, R1
        ADD R1, R1, #1  ; negate R1 for comparison
        ADD R1, R0, R1  ; perform comparison for LF
        BRz END         ; found LF, branch ro end

        ; check if valid number
        LD R1, NEG_9    ; load negated ASCII '9'
        ADD R1, R0, R1  ; compare
        BRp AGAIN       ; if greater than ASCII '9', not valid. ignore
        LD R1, NEG_0    ; load negated ASCII '0'
        ADD R1, R0, R1  ; compare values
        BRn AGAIN       ; if less than ASCII '0', not valid. ignore

        ; valid number at this point so insert queue
        OUT             ; echo back out
        JSR INSERT      ; insert value into queue

        ADD R5, R5, #0  ; check condition codes of R5 for under/overflow
        BRnz AGAIN      ; if positive, the queue overflowed
        ADD R1, R0, #0  ; copy value to R1
        JSR REMOVE      ; remove a value from the queue to free up space
        ADD R0, R1, #0  ; restore value to R0
        JSR INSERT      ; insert value into queue
        BRnzp AGAIN     ; unconditional branch to collect next value

END     LD R0, LF       ; load LF to print
        OUT             ; print LF
REPEAT  JSR REMOVE      ; remove a value from the queue to free up space
        ADD R5, R5, #0  ; check condition codes of R5 for under/overflow
        BRp STOP        ; if positive, the queue underflowed -> done
        OUT             ; print dequeued character
        BRnzp REPEAT    ; unconditional branch to remove next char from queue

STOP    HALT            ; halt program

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
        LD R3, FIRST    ; wraparound, front = first memory location
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

; ----------------------- RAW VALUES STORED IN MEMORY ------------------------ ;
NUM_9   .FILL x0039     ; ASCII '9'
NUM_0   .FILL x0030     ; ASCII '0'
NEG_9   .FILL xFFC7     ; negated ASCII '9'
NEG_0   .FILL xFFD0     ; negated ASCII '0'
LF      .FILL x000A     ; ASCII representation of a linefeed '\n'

.END
