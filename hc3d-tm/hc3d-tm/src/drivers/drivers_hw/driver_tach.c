
/*
 * driver_tach.c
 *
 * Created: 2020-10-25 11:41:26 AM
 *  Author: Joel
 */ 

#include "config.h"
#include "avr/io.h"
#include "stdio.h"

#include "drivers/driver_tach.h"
#include "avr/interrupt.h"

#if HC3D_USE_TEST_DRIVERS==0

uint32_t ticks = 0; 

void driver_tach_init(void){
	// Set D2 to input
	DDRD &= ~(1UL << PORTD2);
	// Enable pullup on D2
	PORTD |= 1 << PORTD2;
	
	// External interrupt 0, falling edge
	// Interrupt 0 is hardware bound to pin D2 (PORT D PIN 2)
	EICRA = (EICRA & ~((1 << ISC00) | (1 << ISC01))) | (2 << ISC00);
	EIMSK |= (1 << INT0);
	
	sei();
}

/// Has to be called at exactly 1Hz
uint32_t driver_tach_get(void){
	uint32_t ticks_old = ticks;
	ticks = 0;
	return ticks_old;
}

// External Interrupt Request 0
ISR(INT0_vect){
	ticks++;
};


#endif