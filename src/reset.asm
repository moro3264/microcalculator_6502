.include "modul_via.asm"
.include "modul_acia.asm"
.include "modul_lcd.asm"

.RODATA
    mesaj: .ASCIIZ "STARTING SYSTEM..."

.CODE
RESET:
    SEI                 ;   ==========================================
    CLD                 ;                SUBRUTINA DE RESET
    LDX #$FF            ;   * dezactivare intreruperi si mod BCD
    TXS                 ;   * initializare stiva 
    LDA #$00            ;   * initializare registre: A = X = Y = 0
    TAX                 ;
    TAY                 ;   ==========================================

    JSR ACIA_INIT
    JSR VIA_INIT
    JSR LCD_INIT

    LDA #<mesaj
    STA _STR_ADDR
    LDA #>mesaj
    STA _STR_ADDR + 1
    JSR LCD_STR
    
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
