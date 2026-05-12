
.include "adrese.asm"
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
<<<<<<< HEAD
    ;STA DDRA            ;   DDRA, DDRB sunt iesiri
    ;STA DDRB            ;

=======
    STA DDRA            ;   DDRA, DDRB sunt iesiri
    STA DDRB            ;
>>>>>>> 3080f3b5ed004c1b624c229fc31af8b6d1abd540
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
