;   Driver pentru 65C22 (WDC) Versatile Interface Adapter (VIA)


.ifndef __MODUL_VIA_H__
__MODUL_VIA_H__ = 1

;   Adrese pentru VIA
.define VIA_PORTB           $8010
.define VIA_PORTA           $8011
.define VIA_DDRB            $8012
.define VIA_DDRA            $8013
.define VIA_T1CL            $8014
.define VIA_T1CH            $8015
.define VIA_T1LL            $8016
.define VIA_T1LH            $8017
.define VIA_T2CL            $8018
.define VIA_T2CH            $8019
.define VIA_SR              $801A
.define VIA_ACR             $801B
.define VIA_PCR             $801C
.define VIA_IFR             $801D
.define VIA_IER             $801E
.define VIA_PORTA_NH        $801F

.CODE
VIA_INIT:
    PHA

    LDA #$FF        ;
    STA VIA_DDRB    ;
    STA VIA_DDRA    ;   PORTA / PORTB sunt iesiri

    PLA

    RTS

.endif
