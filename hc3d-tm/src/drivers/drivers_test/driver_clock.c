/*
 * driver_clock
 * SITL implementation
 */

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "drivers/driver_clock.h"
#include <stdio.h>
#include "time.h"
#include "stdint.h"

void driver_clock_init(void){
	;
}
uint16_t driver_clock_time(void){
    struct timespec time;
    clock_gettime(CLOCK_MONOTONIC, &time);
    // To ms, cap at uint16_t max. Should loop around nicely.
    return (uint16_t) ((time.tv_nsec / 1000000) % UINT16_MAX);
}

#endif
