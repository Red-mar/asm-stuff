##
# Project Title
#
# @file
# @version 0.1

ASM_SOURCES = $(wildcard boot/*.asm)
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.c drivers/*.c)

OBJ = ${C_SOURCES:.c=.o}

all: os-image

# TODO: crosscompiler
run: all
	qemu-system-i386 -drive format=raw,file=os-image,if=floppy

os-image: boot/boot_sect.bin kernel.bin
	cat $^ > os-image

kernel.bin: ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

%.o: %.c ${HEADERS}
	gcc -fno-pie -m32 -ffreestanding -c $< -o $@

%.o : %.asm
	nasm $< -f elf -o $@

%.bin : $(ASM_SOURCES)
	nasm $< -f bin -I 'boot/' -o $@

clean:
	rm */*.bin */*.o os-image
# end
