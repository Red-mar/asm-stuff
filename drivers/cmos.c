#include "cmos.h"

unsigned char cmos_read_rtc(unsigned char reg) {
    outb(0x70, reg);
    return inb(0x71);
}

unsigned char cmos_read_seconds() {
    return cmos_read_rtc(0x00);
}
