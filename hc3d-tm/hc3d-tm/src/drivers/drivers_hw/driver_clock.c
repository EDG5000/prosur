
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
#include "avr/interrupt.h"

volatile uint32_t time = 0;

void driver_clock_init(void){

	// This code sets up a timer0 for 4ms @ 16Mhz clock cycle
	// An interrupt is triggered each time the interval occurs.

	// Set the Timer Mode to CTC
	TCCR0A |= (1 << WGM01);

	// Set the value that you want to count to
	OCR0A = 0xF9;

	// Set the ISR COMPA vect
	TIMSK0 |= (1 << OCIE0A);    

	// Enable interrupts
	sei();         

	// Set prescaler to 256 and start the timer
	TCCR0B |= (1 << CS02);

}

// Will always be multiples of 4
uint32_t driver_clock_time(void){
	return time;
}

// Excecuted every 4ms
ISR(TIMER0_COMPA_vect){
	time+=4;
}




#endif