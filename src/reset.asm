.include "adrese.asm"
.include "driver_lcd.asm"
.include "driver_6522.asm"
.include "driver_6551.asm"

.CODE

RESET:
    SEI                 ;   ==========================================
    CLD                 ;                SECVENTA DE RESET 
    LDX #$FF            ;   * dezactivare intreruperi si mod BCD
    TXS                 ;   * init stiva 
    LDA #$00            ;   * init registre: A = X = Y = 0x00        
    TAX                 ;   
    TAY                 ;   ==========================================

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
