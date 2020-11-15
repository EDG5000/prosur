/*
 * driver_sleep
 * SITL implementation of driver_sleep
 */

#include "drivers/driver_sleep.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "stdint.h"
#include <time.h>
#include <errno.h>

void driver_sleep(uint16_t time){
	int64_t time_long = (int64_t) time;
    struct timespec ts;
    int res;
    ts.tv_sec = time_long / 1000;
    ts.tv_nsec = (time_long % 1000) * 1000000;
    do {
        res = nanosleep(&ts, &ts);
    } while (res && errno == EINTR);
}

#endif
