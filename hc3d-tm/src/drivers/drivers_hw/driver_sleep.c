/*
	driver_sleep
 */

#include "config.h"
#if HC3D_SITL_MODE==0

#include <avr/io.h>
#include <util/delay.h>
#include "drivers/driver_sleep.h" 
#include "stdint.h"

// Max delay is 6.5535s
void driver_sleep(uint16_t time){
	while(time--) {
		_delay_ms(1);
	}
}

#endif
