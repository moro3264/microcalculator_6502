;   Driver pentru 65C51 (WDC) Asynchronous Communications Interface Adapter (ACIA)
;       Scopul e folosirea lui ca mediu prin care sa pot incarca programele din calculator in SRAM.
;       Astfel, scap de reprogramarea memoriei ROM de fiecare data cand fac o schimbare.
;
;       Subrutine:
;   *   ACIA_INIT       -   initializare periferic
;   *   ACIA_WRITE      -   scriere data
;   *   ACIA_READ       -   citire data
;
;       Pe viitor:
;   *   sa ma hotarasc dracului odata daca folosesc sau nu ceilalti pini, pe langa RxD si TxD.
;   *   sa scriu un program prin care sa pot incarca date fara 
;   *   sa scriu subrutinele necesare incarcarii in RAM a datelor primite

.ifndef __MODUL_ACIA_H__
__MODUL_ACIA_H__ = 1

.include "LCD.asm"

;   Adrese pentru ACIA
.define ACIA_DATA_REG       $8000
.define ACIA_STATUS_REG     $8001
.define ACIA_COMMAND_REG    $8002
.define ACIA_CONTROL_REG    $8003

.define _ACIA_CURRENT_STATUS  $7FFE

.CODE
ACIA_INIT:
    PHA

    STZ ACIA_STATUS_REG         ;   reset soft (nu e nevoie la inceput)

    LDA #$10                    ;
    STA ACIA_CONTROL_REG        ;   115200bps, word de 8 biti, 1 stop bit

    LDA #$0B                    ;
    STA ACIA_COMMAND_REG        ;   fara parity, fara echo, fara IRQ, DTR = 1

    PLA
    RTS

ACIA_WRITE:
    PHA

@ASTEAPTA_TX:                   ;
    LDA ACIA_STATUS_REG         ;
    AND #$10                    ;
    BEQ @ASTEAPTA_TX            ;   verifica daca TX e gol

    STA ACIA_DATA_REG           ;   scrie valoarea lui A pe TX

    PLA
    RTS

ACIA_READ:
    PHA

@ASTEAPTA_RX:                   ;
    LDA ACIA_STATUS_REG         ;
    AND #$08                    ;
    BEQ @ASTEAPTA_RX            ;   verifica daca RX e plin

    LDA ACIA_DATA_REG
    JSR LCD_CHR

    JMP ACIA_READ               ;   loop infinit pentru test
    PLA

    RTS

.endif
