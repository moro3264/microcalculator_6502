.segment "ROM_TEST"

.include "LCD.inc"

;   program de test
START_PROGRAM:
    JSR LCD_CLEAR
    LDA #$40
REPETA:
    INC A
    CMP #$60
    BEQ FINAL
    JSR LCD_CHR
    BRA REPETA
FINAL:
    JSR LCD_CLEAR
    LDA #'F'
    JSR LCD_CHR
CATCH:
    BRA CATCH

    STP
