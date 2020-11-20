/*
 * driver_clock
 * SITL implementation
 */

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#define _POSIX_C_SOURCE 200809L
#include "drivers/driver_clock.h"
#include <stdio.h>
#include "sys/time.h"
#include <math.h>
#include "stdint.h"
#include <inttypes.h>
#include <stdio.h>

void driver_clock_init(void){
	;
}
uint16_t driver_clock_time(void){
    struct timeval te;
    gettimeofday(&te, NULL); // get current time
    long long milliseconds = te.tv_sec*1000LL + te.tv_usec/1000; // calculate milliseconds
    // printf("milliseconds: %lld\n", milliseconds);
    // Wraps around every ~60 sec due to 16 bit limit. This expected by util_time_offset. Also wraps around every day, this is OK for test code. Do not run around midnight!
    uint16_t retval = (uint16_t) milliseconds%UINT16_MAX;
    return retval;
}

#endif
