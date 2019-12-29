##
# Project Title
#
# @file
# @version 0.1

ARCH=i386-elf
GCC=$(ARCH)-gcc
LD=$(ARCH)-ld

ASM_SOURCES = $(wildcard boot/*.asm)
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.c drivers/*.c)

OBJ = ${C_SOURCES:.c=.o}

all: os-image

run: all
	qemu-system-i386 -drive format=raw,file=os-image,if=floppy

os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

kernel.bin: kernel/kernel_entry.o ${OBJ}
	$(LD) -o $@ -Ttext 0x1000 $^ --oformat binary

%.o: %.c ${HEADERS}
	$(GCC) -nostdlib -lgcc -ffreestanding -c $< -o $@

%.o : %.asm
	nasm $< -f elf32 -o $@

%.bin : $(ASM_SOURCES)
	nasm $< -f bin -I 'boot/' -o $@

clean:
	rm */*.bin */*.o os-image
# end
