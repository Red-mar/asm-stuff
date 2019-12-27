#ifndef __LOW_LEVEL_IO_H_
#define __LOW_LEVEL_IO_H_

unsigned char inb(unsigned short port);
void outb(unsigned short port, unsigned char data);

#endif // __LOW_LEVEL_IO_H_
