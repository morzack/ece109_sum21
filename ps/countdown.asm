;
; countdown.asm - user program for countdownOS.asm
;

.ORIG x3000

AGAIN   TRAP x40        ; call GET_EVENT
        ADD R0, R5, #0  ; copy value from R5 to R0 for service routine
        BRn END         ; negative value means quit command received - halt
        TRAP x41        ; call OUT_NUM
        ADD R0, R0, #0  ; do nothing to check condition codes
        BRp AGAIN       ; repeat until zero

END     HALT            ; halt processor

.END
