;
; draw_lines_starter.asm - draw horizontal/vertical lines for graphics display
;
; In addition to these devices, the video output is also memory-mapped from
; address location xC000 to xFDFF. The video display is 128 by 124 pixels
; (15,872 pixels total) and the coordinate system starts from (0,0) at the top
; left corner of the display.
;
; Since each row is 128 pixels long, in order to find the location exactly one
; row below a given location, at x0080 to it. For example, if you are outputting
; to pixel (3, 10), whose memory location is xC18A, then one row immediately
; below it would be xC20A (=xC18A + x0080).
;
; As a general rule, this is the formula to find the memory location associated
; with a given (row, col):
; addr = xC000 + row*x0080 + col
;
; Each video output memory location represents one pixel, which means that the
; value it contains must be formatted as a pixel would be (i.e. RGB format):
;  N/A      R        G        B
; [15]   [14:10]   [9:5]    [4:0]
;
; R1 - address argument to pass to V_LINE/H_LINE
; R2 - color
; R3 - row address - starting memory address of the row
; R4 - column address - starting memory address of the row
;

.ORIG x3000

; ------------------------------- MAIN ROUTINE ------------------------------- ;
        ; print string to fudge PSR privilege bit due to faulty lc3os
        LEA R0, WELC
        PUTS

        ; place main code here
        HALT            ; halt the program


; ---------------------------- H_LINE SUBROUTINE ----------------------------- ;
; Description: draws a horizontal line
; Inputs:
;       R1 - first memory address of row
;       R2 - color - N/A[15]  R[14:10]  G[9:5]  B[4:0]
; Outputs:
;       Output to graphics display
H_LINE
        ST R0, H_R0    ; save registers
        ST R1, H_R1
        ST R2, H_R2
        ST R3, H_R3
        ST R4, H_R4
        ST R5, H_R5
        ST R6, H_R6
        ST R7, H_R7

        ; place code here to draw a horizontal line

        LD R0, H_R0    ; restore registers
        LD R1, H_R1
        LD R2, H_R2
        LD R3, H_R3
        LD R4, H_R4
        LD R5, H_R5
        LD R6, H_R6
        LD R7, H_R7
        RET

; register storage
H_R0  .BLKW 1
H_R1  .BLKW 1
H_R2  .BLKW 1
H_R3  .BLKW 1
H_R4  .BLKW 1
H_R5  .BLKW 1
H_R6  .BLKW 1
H_R7  .BLKW 1


; ---------------------------- V_LINE SUBROUTINE ----------------------------- ;
; Description: draws a vertical line
; Inputs:
;       R1 - first memory address of column
;       R2 - color - N/A[15]  R[14:10]  G[9:5]  B[4:0]
; Outputs:
;       Output to graphics display
V_LINE
        ST R0, V_R0    ; save registers
        ST R1, V_R1
        ST R2, V_R2
        ST R3, V_R3
        ST R4, V_R4
        ST R5, V_R5
        ST R6, V_R6
        ST R7, V_R7

        ; place code here to draw a vertical line

        LD R0, V_R0    ; restore registers
        LD R1, V_R1
        LD R2, V_R2
        LD R3, V_R3
        LD R4, V_R4
        LD R5, V_R5
        LD R6, V_R6
        LD R7, V_R7
        RET

; register storage
V_R0  .BLKW 1
V_R1  .BLKW 1
V_R2  .BLKW 1
V_R3  .BLKW 1
V_R4  .BLKW 1
V_R5  .BLKW 1
V_R6  .BLKW 1
V_R7  .BLKW 1

; ---------------------------- RANDOM SUBROUTINE ----------------------------- ;
; Description: generates a pseudo-random number, borrowed from Douglas Blank.
; Don't need to focus on how it , just how to use it. If you are curious:
; eses Schrage's method for Lehmer random number generation described below:
; https://en.wikipedia.org/wiki/Lehmer_random_number_generator#Schrage's_method
; Inputs:
;       None
; Outputs:
;       R2 - pseudo-random number
RANDOM  ST R0, Ran_R0       ; save registers
        ST R1, Ran_R1
        ST R3, Ran_R3
        ST R4, Ran_R4
        ST R5, Ran_R5
        ST R6, Ran_R6
        ST R7, Ran_R7
        LD R0, M
        LD R1, A
        JSR RanDiv          ; R0 / R1
        ; q = m / a
        LD R0, QUOTIENT     ; R0 / R1
        ST R0, Q
        ; r = m mod a
        LD R0, REMAINDER    ; R0 mod R1
        ST R0, R
        ; x / q
        LD R0, X
        LD R1, Q
        JSR RanDiv          ; R0 / R1
        LD R1, QUOTIENT
        ST R1, TEMP2
        LD R1, REMAINDER    ; x mod q
        ST R1, TEMP1
        ; a * TEMP1 - r * TEMP2
        LD R0, A
        JSR RanMult         ; R2 <- R0 * R1
        ST R2, TEMP1
        ; a * TEMP1 - r * TEMP2
        LD R0, R
        LD R1, TEMP2
        JSR RanMult         ; R2 <- r * TEMP2
        NOT R2, R2          ; -R2
        ADD R2, R2, #1
        ST R2, TEMP2
        LD R1, TEMP1
        ADD R2, R2, R1      ; TEMP1 - TEMP2
TEST    BRzp DONE           ; if x < 0 then
        LD R1, M
        ADD R2, R2, R1
DONE    ST R2, X
        LD R0, Ran_R0       ; restore registers
        LD R1, Ran_R1
        LD R3, Ran_R3
        LD R4, Ran_R4
        LD R5, Ran_R5
        LD R6, Ran_R6
        LD R7, Ran_R7
        RET

A       .FILL #7            ; a , the multiplicative constant is given
M       .FILL #32767        ; m = 2 ^ 15 - 1, the modulus is given
X       .FILL #10           ; x, the seed is given
R       .FILL #0
Q       .FILL #0
TEMP1   .FILL #0
TEMP2   .FILL #0
; register storage
Ran_R0  .BLKW 1
Ran_R1  .BLKW 1
Ran_R3  .BLKW 1
Ran_R4  .BLKW 1
Ran_R5  .BLKW 1
Ran_R6  .BLKW 1
Ran_R7  .BLKW 1

; -----------------------------------------------------
; R2 <- R0 * R1
; Also uses R3 to store SIGN
RanMult  AND R2, R2, #0
          AND R3, R3, #0
          ADD R0, R0, #0        ; compare R0
          BRn MultNEG1
          BR  MultCont
MultNEG1 NOT R3, R3             ; flip SIGN
          NOT R0, R0
          ADD R0, R0, #1
MultCONT ADD R1, R1, #0         ; compare R1
          BRn MultNEG2
          BR MultInit
MultNEG2 NOT R3, R3             ; flip SIGN
          NOT R1, R1
          ADD R1, R1, #1
MultInit ADD R0, R0, #0         ; have R0 set the condition codes
MultLoop BRz MultDone
          ADD R2, R2, R1
          ADD R0, R0, #-1
          BR MultLoop
MultDone ADD R0, R3, #0
          BRzp MultRet
          NOT R2, R2
          ADD R2, R2, #1
MultRet  RET                    ; R2 has the sum

; -----------------------------------------------------
; R0 / R1
; Also uses R3 to store SIGN
;           R4 to store -R1
;           R5 is QUOTIENT
;           R6 is REMAINDER
;           R2 temp
RanDiv   AND R3, R3, #0
          ST R3, QUOTIENT
          ST R3, REMAINDER
          ADD R0, R0, #0         ; compare R0
          BRn DivNEG1
          BR  DivCont
DivNEG1  NOT R3, R3             ; flip SIGN
          NOT R0, R0
          ADD R0, R0, #1
DivCONT  ADD R1, R1, #0         ; compare R1
          BRn DivNEG2
          BR DivInit
DivNEG2  NOT R3, R3             ; flip SIGN
          NOT R1, R1
          ADD R1, R1, #1
DivInit  ADD R4, R1, #0
          NOT R4, R4
          ADD R4, R4, #1
DivLoop  ADD R2, R0, R4         ; have R2 set the condition codes
          BRn DivDone
          ADD R0, R0, R4
          LD R2, QUOTIENT
          ADD R2, R2, #1
          ST R2, QUOTIENT
          BR DivLoop
DivDone  ADD R3, R3, #0         ; Negative?
          BRzp DivRet
          LD R2, QUOTIENT       ; Yes, then negate R2
          NOT R2, R2
          ADD R2, R2, #1
          ST R2, QUOTIENT
DivRet   ST R0, REMAINDER
          RET                   ; R2 has the sum
QUOTIENT .FILL #0
REMAINDER .FILL #0

; ----------------------- RAW VALUES STORED IN MEMORY ------------------------ ;
TOPLT   .FILL xC000
TOPRT   .FILL xC07F
BOTLT   .FILL xFD80
BOTRT   .FILL xFDFF
N_TOPLT .FILL x4000
N_TOPRT .FILL x3F81
N_BOTLT .FILL x0280
N_BOTRT .FILL x0201

WIDTH   .FILL x0080
HEIGHT  .FILL x007C
NEG_WTH .FILL xFF80
NEG_HGT .FILL xFF84

WELC    .STRINGZ "\nWelcome! Updates privilege in the PSR.\n"

.END
