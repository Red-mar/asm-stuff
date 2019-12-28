#include "kernel.h"

void cmain(unsigned long magic, unsigned long addr) {
    init();
    if (magic == 0x2badb002) {
        print("Magic value was good!\n");
    } else {
        print("Magic value was bad!\n");
    }

    // Go through the multiboot info structure
    for (int i = 0; i <= 34; i++) {
        print_hex(*((int*)addr + i));
        putc('\n');
    }

    outb(0x70, 0x8A);
    unsigned char cmos = inb(0x71);
    return;
}
