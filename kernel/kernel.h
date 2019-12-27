#ifndef __KERNEL_H_
#define __KERNEL_H_

#include "low_level_io.h"
#include "../drivers/screen.h"

void cmain(unsigned long magic, unsigned long addr);

#endif // __KERNEL_H_
