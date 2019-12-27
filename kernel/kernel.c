#include "kernel.h"

void cmain(unsigned long magic, unsigned long addr) {
    init();
    if (magic == 0x2badb002) {
        print("Magic value was good!\n");
    } else {
        print("Magic value was bad!\n");
    }
    print_hex(0xCAFEBABE);
    outb(0x70, 0x8A);
    unsigned char cmos = inb(0x71);
    return;
}
