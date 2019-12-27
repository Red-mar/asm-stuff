#ifndef __SCREEN_H_
#define __SCREEN_H_

#define VGA_VIDEO_MEMORY 0xb8000

#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25

#include "../kernel/low_level_io.h"
#include "../kernel/system.h"

void putc(char c);
void print(char* s);
void print_hex(int c);
void init();

struct Cursor {
    int x;
    int y;
};


#endif // __SCREEN_H_
