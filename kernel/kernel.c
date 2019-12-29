#include "kernel.h"

void cmain(unsigned long magic, unsigned long addr) {
    init();
    if (magic == 0x2badb002) {
        print("Magic value was good!\n");
    } else {
        print("Magic value was bad!\n");
    }

    unsigned char now = cmos_read_seconds();
    unsigned char wait_time = 109;
    while(wait_time) {
        if(now != cmos_read_seconds()) {
            wait_time--;
            now = cmos_read_seconds();
            print_hex(now);
            putc('\n');
        }
    }

    return;
}
