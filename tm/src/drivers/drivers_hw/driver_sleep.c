#include "drivers/driver_sleep.h"

#include <util/delay.h>
#include <stdint.h>

#include <avr/io.h>

// Max delay is uint16_t max ms. (6.5535s)
void driver_sleep(uint16_t ms){
	while(ms--) {
		_delay_ms(1);
	}
}
