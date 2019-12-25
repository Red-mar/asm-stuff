##
# Project Title
#
# @file
# @version 0.1

all: os-image

run: all
	qemu-system-x86_64 -drive format=raw,file=os-image,if=floppy

os-image: boot_sect.bin kernel.bin
	cat $^ > os-image

kernel.bin: kernel_entry.o kernel.o
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.o: kernel.c
	gcc -ffreestanding -c $< -o $@

kernel_entry.o: kernel_entry.asm
	nasm $< -f elf64 -o $@

boot_sect.bin: boot_sect.asm
	nasm -f bin $<  -I '.' -o $@

clean:
	rm *.bin *.o os-image
# end
