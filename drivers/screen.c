#include "screen.h"

unsigned short* vmem;
struct Cursor crs = {0, 0};

void set_cursor() {
    outb(0x3D4, 14);
    outb(0x3D5, crs.y * SCREEN_WIDTH + (crs.x >> 8));
    outb(0x3D4, 15);
    outb(0x3D5, crs.y * SCREEN_WIDTH + crs.x);
}

void clear_screen() {
    memset(vmem, 0x00000000, (SCREEN_WIDTH * SCREEN_HEIGHT) * 2);
    crs.x = 0;
    crs.y = 0;
    set_cursor();
}

void scroll() {
    if (crs.y >= SCREEN_HEIGHT) {
        memcpy(vmem, vmem + (SCREEN_WIDTH), (SCREEN_WIDTH * 2) * SCREEN_HEIGHT - 1 );
        crs.y -= 1;
    }
}

void putc(char c) {
    unsigned short attribute = 0x05 << 8;
    unsigned short* where = vmem + ((crs.y * SCREEN_WIDTH) + crs.x);
    unsigned short ch = attribute | c;

    if (c == '\n') {
        crs.y++;
        crs.x = 0;
    } else {
        *where = ch;
        crs.x++;
    }

    if (crs.x >= SCREEN_WIDTH) {
        crs.y++;
        crs.x = 0;
    }

    scroll();
    set_cursor();
}

void print(char* s) {
    char c = *s;
    while (c != '\0') {
        putc(c);
        s += 1;
        c = *s;
    }
}

// best print c:
void print_hex(int c) {
    const char* hex = "0123456789ABCDEF";
    char* result = "0x00000000";
    for (int result_i = 9;
         result_i >= 2;
         result_i--) {
        char bit = (c & 0x000000F);
        c = c >> 4;
        *(result + result_i) = *(hex + bit);
    }
    print(result);
}

void init() {
    vmem = (unsigned short*) VGA_VIDEO_MEMORY;
    crs.x = 0;
    crs.y = 0;
}
