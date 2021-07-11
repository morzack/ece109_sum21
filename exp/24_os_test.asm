;
; os_test.asm - test user program for contrivedOS.asm
;

.ORIG x3000

        TRAP x26    ; OS BSOD service routine
        HALT        ; halt processor

.END
