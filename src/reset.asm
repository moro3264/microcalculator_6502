.org    $8000

.include "driver_lcd.asm"
.include "driver_6522.asm"
.include "driver_6551.asm"

RESET:
    SEI                 ;   ==========================================
    CLD                 ;                SECVENTA DE RESET 
    LDX #$FF            ;   ~ dezactivare intreruperi si mod BCD
    TXS                 ;   ~ init stiva 
    LDA #$00            ;   ~ init registre: A = X = Y = 0x00        
    TAX                 ;   
    TAY                 ;   ==========================================

    LDA #$FF            ;
    STA DDRA            ;   DDRA, DDRB sunt iesiri
    STA DDRB            ;
LOOP:
    JMP LOOP

NMI:
    RTI
IRQ:
    RTI


.org    $FFFA
.word   NMI
.word   RESET
.word   IRQ
