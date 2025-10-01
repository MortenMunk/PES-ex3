CC			= arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
CFLAGS	= -mcpu=cortex-m3 -mthumb -O0 -g
LDFLAGS = -nostdlib -T stm32f103rb.ld
SRC			= main.c led.c startup.s
OBJ			= $(SRC:.c=.o)

all: firmware.bin

firmware.elf: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

firmware.bin: firmware.elf
	$(OBJCOPY) -O binary $< $@

flash: firmware.bin
	st-flash write firmware.bin 0x8000000

clean:
	rm -f $(OBJ) firmware.elf firmware.bin
