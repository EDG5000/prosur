/*
 * driver_sleep.c
 *
 * Created: 2020-10-23 10:57:48 PM
 *  Author: Joel
 */ 

#ifdef HC3D_TM_UNIT_TEST

#include "drivers/driver_sleep.h"

void driver_sleep(uint32_t time){
	// Sleep is for the weak (not sleeping in HC3D_TM_UNIT_TEST mode)
}

#endif