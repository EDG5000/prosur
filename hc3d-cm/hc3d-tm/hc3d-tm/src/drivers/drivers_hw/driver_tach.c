
/*
 * driver_tach.c
 *
 * Created: 2020-10-25 11:41:26 AM
 *  Author: Joel
 */ 

#include "asf.h"

#ifndef HC3D_TM_UNIT_TEST

void driver_tach_init(void){
	// Set up interrupts
	// Ensure no interference with interrupts from driver_pwm and clock
		
	// External interrupt 0, falling edge
	// Interrupt 0 is hardware bound to pin D2
	EICRA = (EICRA & ~((1 << ISC00) | (1 << ISC01))) | (2 << ISC00);
	EIMSK |= (1 << INT0);
}

uint32_t driver_tach_get(void){
	return 1; // TODO
}

// External Interrupt Request 0
ISR(INT0_vect){

};


#endif