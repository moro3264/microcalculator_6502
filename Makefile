.SUFFIXES: .c .asm .s .o

AS 			= ca65
AS_FLAGS 	= -v --cpu W65C02

LD		 	= ld65
LD_FLAGS 	= -v --no-utf8

CC			= cc65
CC_FLAGS	= -v -t none --cpu W65C02

DIR_SRC 	= src
DIR_BIN 	= bin

#C_S 		= 
#C_O 		= $(C_S:%.c=%.o)

ASM_S 		= $(DIR_SRC)/reset.asm\
			  $(DIR_SRC)/driver_lcd.asm\
			  $(DIR_SRC)/adrese.asm

ASM_O 		= $(ASM_S:%.asm=%.o)
FIRMWARE	= firmware.bin

$(FIRMWARE): $(ASM_O)
	$(LD) $(LD_FLAGS) -C src/memory.map -o bin/$(FIRMWARE) $(ASM_O)
	rm $(ASM_O)

.asm.o:
	$(AS) $(AS_FLAGS) -o $@ $<

.c.o:
	$(CC) $(CC_FLAGS) -o $@ $<

up: $(FIRMWARE)
	minipro -p AT28C256 -w bin/$(FIRMWARE) -s -u
dmp:
	minipro -p AT28C256 -r bin/$(FIRMWARE).d
erase:
	minipro -p AT28C256 -E

clr:
	rm $(ASM_O) $(FIRMWARE)

.PHONY: clr
