.SUFFIXES: .c .asm .s

AS 			= ca65
AS_FLAGS 	= -v --cpu W65C02

LD		 	= ld65
LD_FLAGS 	= -v

ASM_S 	= src/reset.asm src/driver_lcd.asm src/adrese.asm
ASM_O 	= $(ASM_S:%.asm=%.o)
FINAL	= firmware.out

$(FINAL): $(ASM_O)
	$(LD) $(LD_FLAGS) -C src/memory.map -o bin/$(FINAL) $(ASM_O)
	rm $(ASM_O)

.asm.o:
	$(AS) $(AS_FLAGS) -o $@ $<

up: $(TARGET)
	doas minipro -p AT28C256 -w bin/$(FINAL) -s -u
dmp:
	doas minipro -p AT28C256 -r bin/$(FINAL).dmp
erase:
	doas minipro -p AT28C256 -E

clr:
	rm $(ASM_O) $(FINAL)

.PHONY: clr
