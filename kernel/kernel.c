#include "low_level_io.h"

void cmain(unsigned long magic, unsigned long addr) {
    char* video_memory = (char*) 0xb8000;
    if (magic == 0x2badb002) {
        *video_memory = 'G';
        video_memory += 1;
        *video_memory = 0x2;
        video_memory += 1;
        *video_memory = 'O';
        video_memory += 2;
        *video_memory = 'O';
        video_memory += 2;
        *video_memory = 'D';
    } else {
        *video_memory = 'B';
        video_memory += 2;
        *video_memory = 'A';
        video_memory += 2;
        *video_memory = 'D';
    }

    outb(0x70, 0x8A);
    unsigned char cmos = inb(0x71);

    video_memory += 6;
    if (cmos == 0) {
        *video_memory = 'X';
    } else {
        *video_memory = 'O';
    }

    return;
}
