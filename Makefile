.SUFFIXES: .c .asm .s .o

AS 			= ca65
AS_FLAGS 	= -v --cpu W65C02

LD		 	= ld65
LD_FLAGS 	= -v -S 0x8000 -C harta_de_memorie.cfg

CC			= cc65
CC_FLAGS	= -v -t none --cpu W65C02

DIR_SRC 	= src
DIR_BIN 	= bin

#C_S 		= 
#C_O 		= $(C_S:%.c=%.o)

DCD_MEM		=	dcd_mem.pld
ASM_S 		= \
	  $(DIR_SRC)/LCD.asm\
	  $(DIR_SRC)/VIA.asm\
	  $(DIR_SRC)/ACIA.asm\
	  $(DIR_SRC)/reset.asm\

ASM_O 		= $(ASM_S:%.asm=%.o)
FIRMWARE	= firmware.bin

$(FIRMWARE): $(ASM_O)
	$(LD) $(LD_FLAGS) -o bin/$(FIRMWARE) $(ASM_O)
	rm $(ASM_O)

.asm.o:
	$(AS) $(AS_FLAGS) -o $@ $<
.c.o:
	$(CC) $(CC_FLAGS) -o $@ $<

dcd: $(DCD_MEM)
	galette -c -f -p $(DCD_MEM)

up: $(FIRMWARE)
	doas minipro -p AT28C256 -w bin/$(FIRMWARE) -u
dmp:
	doas minipro -p AT28C256 -r bin/$(FIRMWARE).d
erase:
	doas minipro -p AT28C256 -E

clr:
	rm -f $(ASM_O) $(FIRMWARE)

.PHONY: clr
