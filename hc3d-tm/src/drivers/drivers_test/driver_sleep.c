/*
 * driver_sleep
 * SITL implementation of driver_sleep
 */

#include "drivers/driver_sleep.h"
#if HC3D_SITL_MODE==1

#include "stdint.h"
#include <time.h>
#include <errno.h>

void driver_sleep(uint16_t time){
  uint16_t ms_remaining = time % 1000;
  long usec = ms_remaining * 1000;
  struct timespec ts_sleep;

  ts_sleep.tv_sec = (int32_t) (time/1000);
  ts_sleep.tv_nsec = (int32_t) (1000*usec);
  nanosleep(&ts_sleep, NULL);
}

#endif
