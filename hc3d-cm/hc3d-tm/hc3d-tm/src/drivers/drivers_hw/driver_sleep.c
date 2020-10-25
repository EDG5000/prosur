/*
 * driver_sleep.c
 *
 * Created: 2020-10-24 4:50:46 PM
 *  Author: Joel
 */ 

#ifndef HC3D_TM_UNIT_TEST

#include "delay.h"
#include "drivers/driver_sleep.h" 
#include "stdint.h"

void driver_sleep(uint32_t time){
	_delay_ms(time);
}

#endif