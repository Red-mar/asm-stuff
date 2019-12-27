void cmain(unsigned long magic, unsigned long addr) {
    char* video_memory = (char*) 0xb8000;
    *video_memory = 'X';
    if (magic == 0x2badb002) {
        *video_memory = 'O';
    }
    return;
}
