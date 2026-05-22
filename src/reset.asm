.INCLUDE "VIA.asm"
.INCLUDE "ACIA.asm"
.INCLUDE "LCD.asm"

.RODATA
MSG_SYS_INIT: 
    .ASCIIZ "SYSTEM INIT..."

.define ZP_ADR_PRG $7F

.CODE
RESET:
    SEI
    CLD
    LDX #$FF
    TXS
    LDA #$00
    TAX
    TAY

    STZ ZP_ADR_PRG
    LDA #$2F
    STA ZP_ADR_PRG + 1

    JSR VIA_INIT
    JSR LCD_INIT
    JSR ACIA_INIT

    LDA #<MSG_SYS_INIT
    STA _LCD_L1_STR
    LDA #>MSG_SYS_INIT
    STA _LCD_L1_STR + 1
    JSR LCD_STR
    
    STZ $FE
    LDA #$30
    STA $FF

    CLI
    WAI
LOOP:
    JMP LOOP

;   -   UART_ANTET[0] - SECVENTA DE START (0x42)
;   -   UART_ANTET[1] - CHECKSUM LOW
;   -   UART_ANTET[2] - CHECKSUM HIGH CRC16
;   -   UART_ANTET[3] - COMANDA
;   -   UART_ANTET[4] - LUNGIMEA DATELOR LOW
;   -   UART_ANTET[5] - LUNGIMEA DATELOR HIGH
.DEFINE UART_ANTET $0030
NMI:
    SEI
    PHA
    PHX
    PHY

    STZ ZP_ADR_PRG
    LDA #$2F
    STA ZP_ADR_PRG + 1

    LDX #$00
@ACIA_CITESTE_ANTET:
    LDA ACIA_STATUS_REG
    AND #$08
    BEQ @ACIA_CITESTE_ANTET
    
    LDA ACIA_DATA_REG
    STA UART_ANTET, X
    INX
    CPX #$06
    BEQ @LOAD_PROGRAM_IN_RAM
    JMP @ACIA_CITESTE_ANTET

@LOAD_PROGRAM_IN_RAM:

    LDX #$03                    ;   intrucat incepem de la $3000
    LDA ZP_ADR_PRG              ;   si dimensiunea maxima de program e 16KiB, 
    ADC ACIA_DATA_REG, X        ;   nu are rost sa ne facem griji de overflow
    STA ZP_ADR_PRG + 2          ;   stocheaza in ZP_ADR_PRG[2] low byte pentru adresa de final
    INX                         ;
    LDA ZP_ADR_PRG + 1          ;
    ADC ACIA_DATA_REG, X        ;   
    STA ZP_ADR_PRG + 3          ;   stocheaza in ZP_ADR_PRG[3] high byte pentru adresa de final
@INC_PAG:
    LDX #$03
    LDA ZP_ADR_PRG + 1
    CMP ZP_ADR_PRG, X
    BNE @CONTINUA_INCARCAREA    ;   daca nu am ajuns la ultima pagina, continua sa incarci
    DEX
    LDA ZP_ADR_PRG
    CMP ZP_ADR_PRG, X
    BNE @CONTINUA_INCARCAREA    ;   daca nu am ajuns la ultimul byte din pagina, continua sa incarci
    JMP @FINAL_INCARCARE
@CONTINUA_INCARCAREA:
    LDY #$00                    ;
    INC ZP_ADR_PRG              ;   clear Y si incrementeaza pagina
@ACIA_CITESTE_DATE:
    LDA ACIA_STATUS_REG         ;
    AND #$08                    ;
    BEQ @ACIA_CITESTE_DATE      ;   polling porno ACIA

    LDA ACIA_DATA_REG           ;
    STA (ZP_ADR_PRG), Y         ;   date valide, stocheaza byte
    INY                         ;   incrementeaza pozitia in pagina
    BNE @ACIA_CITESTE_DATE      ;   daca Y != 0 continua pagina, altfel incrementeaza pagina si continua
    JMP @INC_PAG                ;

@FINAL_INCARCARE:

    PLY
    PLX
    PLA
    CLI
    RTI

IRQ:
    SEI
    CLI
    RTI

.SEGMENT "VECTORI"
.WORD NMI
.WORD RESET
.WORD IRQ
