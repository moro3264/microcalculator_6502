.org    $8000

.include "driver_lcd.asm"

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

    JSR LCD_INIT        ;   initializare LCD

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
