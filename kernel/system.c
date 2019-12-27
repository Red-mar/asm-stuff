#include "system.h"

void memcpy(void* dest, const void* src, int n) {
    for(int i = 0; i <= n; i++) {
        *(unsigned char*)dest = *(unsigned char*)src;
        src++;
        dest++;
    }
}

void memset(void* dest, int b , int n) {
    unsigned char byte = (unsigned char) b;

    for(int i = 0; i <= n; i++) {
        *(unsigned int*)dest = byte;
        dest++;
    }
}
