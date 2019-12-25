#!/usr/bin/env bash

nasm kernel_entry.asm -f elf64 -o kernel_entry.o

gcc -ffreestanding -c kernel.c -o kernel.o
ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

nasm -f bin boot_sect.asm -o boot_sect.bin
cat boot_sect.bin kernel.bin > os-image
qemu-system-x86_64 -drive format=raw,file=os-image,if=floppy
