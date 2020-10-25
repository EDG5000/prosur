
/*
 * clock.c
 *
 * Created: 2020-10-25 7:45:10 AM
 *  Author: Joel
 */ 

#include "clock.h"
#include "stdint.h"
#include "asf.h"

volatile uint32_t time;

void clock_init(void){
	// Note: Be carefull as to ensure not to interfere with Tach and PWM interrupt (driver_pwm, driver_tach).
	// Note: Interference will not occur in UNIT_TEST mode!
	OCR1A = 15999;
}

uint32_t clock_time(void){
	return time;
}

ISR (TIMER0_COMPA_vect){
	time++;
}