;   Driver pentru afisaje LCD alfanumerice (HD44780)
;   Subrutine:
;   *   LCD_INIT
;   *   LCD_CMD
;   *   LCD_CHR
;   *   LCD_STR
;   *   LCD_CLEAR
;
;   Pe viitor:
;   *   se va renunta la metoda cu decalaj soft
;   *   se vor generaliza instructiunile pentru LCD-uri de diferite dimensiuni: 8x2, 16x2, 24

.include "adrese.asm"

.CODE

LCD_INIT:
    PHA

    LDA #$02
    JSR LCD_CMD
    LDA #$28
    JSR LCD_CMD
    LDA #$06
    JSR LCD_CMD
    LDA #$0C
    JSR LCD_CMD
    JSR LCD_CLEAR

    PLA
    RTS

;   PORTB ~ LCD
;   7   6   5   4   3   2   1   0
;   7   6   5   4   X   RS  E   X
LCD_CMD:
    PHA 

    STA _LCD_VAL_TMP
    AND #$F0
    ORA #$02           ;   E = 1
    STA PORTB

    LDA #$80
    JSR DELAY

    AND #$F0
    STA PORTB           ;E = 0

    LDA #$80
    JSR DELAY

    LDA _LCD_VAL_TMP
    ROL A           
    ROL A           
    ROL A           
    ROL A           
    AND #$F0
    ORA #$02        
    STA PORTB       

    LDA #$80
    JSR DELAY

    AND #$F0
    STA PORTB

    LDA #$80
    JSR DELAY
    
    PLA
    RTS

;   PORTB
;   7   6   5   4   3   2   1   0
;   7   6   5   4   X   RS  E   X

LCD_CHR:
    PHA

    STA _LCD_VAL_TMP    ;
    AND #$F0            ;
    ORA #$06            ;   RS = 1 si E = 1

    STA PORTB
    LDA #$80
    JSR DELAY

    AND #$F4            ;   RS = 1 si E = 0

    STA PORTB
    LDA #$80
    JSR DELAY

    LDA _LCD_VAL_TMP
    ROL A
    ROL A
    ROL A
    ROL A
    AND #$F0
    ORA #$06        ;   RS = 1 si E = 1

    STA PORTB
    LDA #$80
    JSR DELAY

    AND #$F4        ;   RS = 1 si E = 0

    STA PORTB
    LDA #$80
    JSR DELAY

    PLA
    RTS

LCD_STR: 
    PHA
    PHY
    LDY #$00
@LCD_STR_AFISARE_CHR:
    LDA (_STR_ADDR), Y
    BEQ @LCD_STR_FINAL
    JSR LCD_CHR
    INY
    JMP @LCD_STR_AFISARE_CHR
@LCD_STR_FINAL:
    PLY
    PLA

    RTS
    
DELAY:
    PHA
    PHX
    LDA #$FF
@DELAY_1:
    TAX
@DELAY_0:
    DEX
    BNE @DELAY_0
    DEC
    BNE @DELAY_1
    PLX
    PLA
    RTS

LCD_CLEAR:
    PHA
    LDA #$01
    JSR LCD_CMD
    LDA #$80
    JSR LCD_CMD
    PLA
    RTS
