.include "VIA.asm"
.include "ACIA.asm"
.include "LCD.asm"

.RODATA
msg_sys_init: 
    .ASCIIZ "SYSTEM INIT"

.CODE
RESET:
    SEI
    CLD
    LDX #$FF
    TXS
    LDA #$00
    TAX
    TAY

    JSR VIA_INIT
    JSR LCD_INIT
    JSR ACIA_INIT

    LDA #<msg_sys_init
    STA _LCD_L1_STR
    LDA #>msg_sys_init
    STA _LCD_L1_STR + 1
    JSR LCD_STR
    
    JSR ACIA_READ       ;   testare ACIA
@LOOP:
    JMP @LOOP

NMI:
    RTI
IRQ:
    RTI

.SEGMENT "VECTORI"
.word   NMI
.word   RESET
.word   IRQ
