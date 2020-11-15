/*
 driver_sleep
 Contrary to other drivers, this driver does not have a separate test implementation
 */

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==0

#include <avr/io.h>
#include <util/delay.h>
#include "drivers/driver_sleep.h" 
#include "stdint.h"

// Max delay is 6.5535s
// Internally the value is converted to 32-bit float, losing precision, also losing precision due to prescaler etc.
void driver_sleep(uint32_t time){
	_delay_ms( time);
}

#endif
