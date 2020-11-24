
/*
 * driver_tach.c
 *
 * Created: 2020-10-25 11:40:58 AM
 *  Author: Joel
	
	Simulates a relationship between driver_pwm setpoint (the setpoint is stolen from the implementation at runtime)
	Tach output relates to PWM setpoint percentage with +-10 random deviation each reading
 */ 

#include "config.h"
#if HC3D_SITL_MODE==1

#include "stdlib.h"
#include "drivers/driver_tach.h"
#include "drivers/driver_pwm.h"

void driver_tach_init(void){
	; // NOP in test mode	
}

// Simulated tach RPM is 10+- of the pump PWM duty cycle percentage
// 50% pump = ~50RPM tach
uint8_t driver_tach_get(void){
	return driver_pwm_value - 5 + (rand() % 10);
}

#endif
