#ifndef __CMOS_H_
#define __CMOS_H_

#include "../kernel/low_level_io.h"

struct datetime {
    unsigned char seconds;
    unsigned char minutes;
    unsigned char hours;
    unsigned char weekday;
    unsigned char day_of_month;
    unsigned char month;
    unsigned char year;
} datetime;

unsigned char cmos_read_seconds();


#endif // __CMOS_H_
