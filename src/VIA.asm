;   Driver pentru 65C22 (WDC) Versatile Interface Adapter (VIA)

.include "adrese_io.inc"

.CODE
VIA_INIT:
    PHA

    LDA #$FF        ;
    STA VIA_DDRB    ;
    STA VIA_DDRA    ;   PORTA / PORTB sunt iesiri

    PLA
    RTS

.export VIA_INIT
