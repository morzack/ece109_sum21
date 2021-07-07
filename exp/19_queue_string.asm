;
; queue_strings.asm - use a queue to store pointers to strings.
;
; It may seem as though this program is pointless; however, setting up a queue
; structure like this will be imperative when you move to incorporating
; interrupts into your program and moving to higher-level languages where you
; may want to enqueue data from multiple places within the program.
;

.ORIG x3000

        LD R2, START    ; starting memory address for storing strings
        LD R3, FIRST    ; initialize front/head
        LD R4, FIRST    ; initialize rear/tail
        ADD R0, R2, #0  ; move start address to R0
        JSR INSERT      ; insert pointer to first string, assume it starts at beginning

PROMPT  LD R0, PRMPT    ; load prompt character
        OUT             ; print prompt character

AGAIN   GETC            ; retrieve character from user
        OUT             ; echo user input
        STR R0, R2, #0  ; store character to string memory
        ADD R2, R2, #1  ; increment string memory address

        ; check if LF
        LD R1, LF       ; load linefeed
        NOT R1, R1
        ADD R1, R1, #1  ; negate R1 for comparison
        ADD R1, R0, R1  ; perform comparison for LF
        BRnp AGAIN      ; zero if found LF, don't repeate

        ; LF detected, end of string - store pointer to queue
ENDSTR  AND R0, R0, #0  ; clear R0
        STR R0, R2, #0  ; store null character
        ADD R2, R2, #1  ; increment memory address
        ADD R0, R2, #0  ; move start address to R0
        JSR INSERT      ; insert next memory address for string

CHECK   ADD R5, R5, #0  ; check condition codes of R5 for under/overflow
        BRnz PROMPT     ; if positive, then there was a overflow

        ; overflow meaning queue is full. print values!
PRINT   JSR REMOVE      ; remove a value
        ADD R5, R5, #0  ; check condition codes of R5 for under/overflow
        BRp STOP        ; if positive, then underflow stop!
        ADD R1, R0, #0  ; move R0 to R1
        LEA R0, NMSG    ; load new message string
        PUTS            ; print string
        ADD R0, R1, #0  ; move R1 back to R0
        PUTS            ; prints string, pointer already stored in R0
        BRnzp PRINT     ; unconditional branch to get next string

STOP    HALT

; --------------------- INSERT/REMOVE QUEUE SUBROUTINES ---------------------- ;
; Description: insert/remove subroutines for queue
; Inputs: R3 - front/head, R4 is rear/tail
; INSERT input: R0 - value to be inserted into queue
; Outputs: R5 - 0 (success) or 1 (failure)
; REMOVE output: R0 - value to be remove from queue
; NOTE: update FIRST/LAST based on start point and end point of queue
INSERT  ST R1, Q_R1     ; save registers
        AND R5, R5, #0  ; set R5 to success code
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

FIRST   .FILL x4000     ; starting address of queue storage
NEG_1ST .FILL xC000     ; negative of FIRST
LAST    .FILL x4005     ; ending address of queue storage
NEG_LST .FILL xBFFB     ; negative of LAST

; ----------------------- RAW VALUES STORED IN MEMORY ------------------------ ;

START   .FILL x5000     ; starting memory address for storing strings
LF      .FILL x000A     ; ASCII representation of a linefeed '\n'
PRMPT   .FILL x003E     ; ASCII representation of prompt character '>'
NMSG    .STRINGZ "New message: "

.END
