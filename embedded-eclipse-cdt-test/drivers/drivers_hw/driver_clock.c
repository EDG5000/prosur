
/*
 * clock.c
 *
 * Created: 2020-10-25 7:45:10 AM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==0

#include "drivers/driver_clock.h"
#include "stdint.h"
#include "avr/io.h"

volatile uint32_t time = 0;

void driver_clock_init(void){
	// Note: Be carefull as to ensure not to interfere with Tach and PWM interrupt (driver_pwm, driver_tach).
	// Note: Interference will not occur in UNIT_TEST mode!
	// TODO check!!
	OCR1A = 15999;
}

uint32_t driver_clock_time(void){
	return time;
}

ISR(TIMER0_COMPA_vect){
	if(time == UINT32_MAX){
		time = 0;
	}
	time++;
}

#endif