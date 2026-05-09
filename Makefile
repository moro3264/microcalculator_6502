.SUFFIXES: .c .asm .s

AS 			= ca65
AS_FLAGS 	= -v --cpu W65C02

LD		 	= ld65
LD_FLAGS 	= -v

ASM_SRC = reset.asm driver_lcd.asm adrese.asm
ASM_OBJ = $(ASM_SRC:%.asm=%.o)
FINAL	= firmware.out

$(TARGET): $(ASM_OBJ)
	$(LD) $(LD_FLAGS) -C memory.map -o $(FINAL) $(ASM_OBJ)

.asm.o:
	$(AS) $(AS_FLAGS) -o $@ $<

up: $(TARGET)
	doas minipro -p AT28C256 -w $(TARGET) -s -u
dump:
	doas minipro -p AT28C256 -r $(TARGET).dmp
erase:
	doas minipro -p AT28C256 -E


clr:
	rm $(ASM_OBJ) $(FINAL)

.PHONY: clr
