#include "low_level_io.h"

unsigned char inb(unsigned short port){
    unsigned char result;
    asm volatile("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

void outb(unsigned short port, unsigned char data) {
    asm volatile("out %%al, %%dx" : :"a" (data), "d" (port));
}
