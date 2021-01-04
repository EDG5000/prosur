
/*
 * driver_pwm.c
 *
 * Created: 2020-10-25 11:41:13 AM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_SITL_MODE==1

#include "drivers/driver_pwm.h"

// Used by other test drivers to allow simulating temperature and tachometer response
uint8_t driver_pwm_value = 0;

void driver_pwm_init(void){
	; // NOP in test mode
}

void driver_pwm_set(uint8_t percentage){
	driver_pwm_value = percentage;
}

#endif
