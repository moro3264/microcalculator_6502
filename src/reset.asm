.include "modul_via.asm"
.include "modul_acia.asm"
.include "modul_lcd.asm"

.CODE

RESET:
    SEI                 ;   ==========================================
    CLD                 ;                SECVENTA DE RESET 
    LDX #$FF            ;   * dezactivare intreruperi si mod BCD
    TXS                 ;   * init stiva 
    LDA #$00            ;   * init registre: A = X = Y = 0x00        
    TAX                 ;   
    TAY                 ;   ==========================================

    JSR ACIA_INIT
    JSR VIA_INIT

    BRK

LOOP:
    JMP LOOP

NMI:
    RTI
IRQ:
    RTI

.SEGMENT "VECTORI"
.word   NMI
.word   RESET
.word   IRQ
