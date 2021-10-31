
/*
	Pin 2 (D2)
 */ 

#include "config.h"
#if HC3D_SITL_MODE==0

#include "avr/io.h"
#include "libraries/str/str.h"

#include "drivers/driver_tach.h"
#include "avr/interrupt.h"

uint8_t ticks = 0;

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
uint8_t driver_tach_get(void){
	uint8_t ticks_old = ticks;
	ticks = 0;
	return ticks_old;
}

// External Interrupt Request 0
ISR(INT0_vect){
	ticks++;
};


#endif