/*
 * driver_sleep.c
 *
 * Created: 2020-10-23 10:57:48 PM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "drivers/driver_sleep.h"

void driver_sleep(uint32_t time){
	// Sleep is for the weak (not sleeping in HC3D_UNIT_TEST mode)
}

#endif