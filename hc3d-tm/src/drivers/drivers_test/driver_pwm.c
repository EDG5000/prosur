
/*
 * driver_pwm.c
 *
 * Created: 2020-10-25 11:41:13 AM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "drivers/driver_pwm.h"

// Used by other test drivers to allow simulating temperature and tachometer response
uint8_t last_percentage = 0;

void driver_pwm_init(void){
	; // NOP in test mode
}

void driver_pwm_set_pwm(uint8_t percentage){
	last_percentage = percentage;
}

#endif