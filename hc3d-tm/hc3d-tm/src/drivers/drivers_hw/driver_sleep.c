/*
 * driver_sleep.c
 *
 * Created: 2020-10-24 4:50:46 PM
 *  Author: Joel
 */ 

#include "config.h"
//#if HC3D_TEST_MODE!=HC3D_TEST_MODE_SITL 

#define __DELAY_BACKWARD_COMPATIBLE__
#include <avr/io.h>
#include <util/delay.h>
#include "drivers/driver_sleep.h" 
#include "stdint.h"

// Max delay is 6.5535s
// Internally the value is converted to 32-bit float, losing precision, also losing precision due to prescaler etc.
void driver_sleep(double time){
	_delay_ms( time);
}

//#endif