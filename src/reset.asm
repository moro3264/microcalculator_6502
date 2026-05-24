.include "adrese_io.inc"
.INCLUDE "VIA.inc"
.INCLUDE "ACIA.inc"
.INCLUDE "LCD.inc"

.define ZP_ADR_PRG $007F
.define UART_ANTET $0030

.RODATA

MSG_SYS_INIT:
    .ASCIIZ "SYS INIT"
MSG_LD_PRG:
    .ASCIIZ "ASTEPT PROGRAM!"

.CODE
IRQ:
    SEI
    PHA
    PHX
    PHY

    PLY
    PLX
    PLA
    CLI
    RTI

NMI:
    SEI
    PHA
    PHX
    PHY

    JSR LCD_CLEAR
    LDA #<MSG_LD_PRG
    LDY #>MSG_LD_PRG
    JSR LCD_STR

    LDY #$00
    STZ ZP_ADR_PRG
    LDA #$2F
    STA ZP_ADR_PRG + 1
NMI_INC_P:
    INC ZP_ADR_PRG + 1
NMI_POLL:                   ;
    LDA ACIA_STATUS_REG     ;
    BIT #$08                ;
    BEQ NMI_POLL            ;   polling date ACIA
    LDA ACIA_DATA_REG       ;
    STA (ZP_ADR_PRG), Y     ;   stocare byte curent in RAM
    CMP #$DB                ;
    BEQ NMI_FINAL           ;   la instructiunea STP se opreste copierea programului
    INY                     ;
    BEQ NMI_INC_P           ;   Y = 0 => incrementeaza pagina
    BRA NMI_POLL            ;   citeste urmatorul byte
NMI_FINAL:
    TSX                     ;
    LDA #$30                ;
    STA $0106, X            ;
    STZ $0105, X            ;   adresa de revenire va fi cea a programului incarcat

    PLY
    PLX
    PLA
    RTI                     ;   iesire din intrerupere, salt la programul incarcat

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

    WAI                     ;   asteapta primul NMI
LOOP:
    BRA LOOP

;   NMI e folosit strict pentru incarcarea datelor de program
;   Subrutina incarca programe prin ACIA.
;   Structura antetului UART:
;   byte 4   -   CMD (comanda primita)
;   byte 3   -   DLH (high byte din lungimea datelor)
;   byte 2   -   DLL (low byte din lungimea datelor)
;   byte 1   -   CSH (high byte din checksum)
;   byte 0   -   CSH (low byte din checksum)

.SEGMENT "VEC"
.WORD NMI
.WORD RESET
.WORD IRQ
