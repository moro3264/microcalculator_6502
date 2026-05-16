.ifndef __MODUL_ACIA_H__
__MODUL_ACIA_H__ = 1

;   Driver pentru 65C51 (WDC) Asynchronous Communications Interface Adapter (ACIA)

;   Adrese pentru ACIA
.define ACIA_DATA_REG       $8000
.define ACIA_STATUS_REG     $8001
.define ACIA_COMMAND_REG    $8002
.define ACIA_CONTROL_REG    $8003

.CODE
ACIA_INIT:
    RTS

.endif
