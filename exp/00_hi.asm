; hi.asm
; Description: prints "Hi!" to the console port.
; Starting point for ECE109 Program 0.

.ORIG	x3000

    LD R0, UPPER_H
    OUT
    LD R0, LOWER_I
    OUT
    LD R0, EXCLAIM
    OUT
    HALT

UPPER_H  .FILL x0048
LOWER_I  .FILL x0069
EXCLAIM  .FILL x0021

.END
