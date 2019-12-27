#include "kernel.h"

void cmain(unsigned long magic, unsigned long addr) {
    init();
    if (magic == 0x2badb002) {
        print("Magic value was good!");
    } else {
        print("Magic value was bad!\n");
    }
    unsigned char charac = '\n';
    while(1) {
        putc(charac);
        charac--;
        if (charac == '\n') charac = '0';

    }
    print("1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n");
    outb(0x70, 0x8A);
    unsigned char cmos = inb(0x71);
    return;
}
