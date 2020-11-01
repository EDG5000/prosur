/*
 * unit_test.c
 *
 * Created: 2020-10-27 6:31:29 AM
 *  Author: Joel
 */ 

#include "config.h"
#include "asf.h"
#include "drivers/driver_pwm.h"

static void bootstrap(void){
	// Call ASF bootstrap functions. Not sure if needed.
	sysclk_init();
	board_init();
}

#if HC3D_UNIT_TEST==HC3D_UNIT_TEST_DRIVER_PWM

int main(void){
	bootstrap();
	
	driver_pwm_init();
	driver_pwm_set_pwm(50);
	
	while(true){}
}

#elif HC3D_UNIT_TEST==HC3D_UNIT_TEST_LED

#define OUTPUT_RUN_ID   (4)  // The run-indication LED: 0 = LED off, 1 = LED on
#define F_CPU 1000000UL // Clock frequency (as unsigned long)
#include <avr/io.h>     // Recognizes pins, ports, registers, etc.
#include <util/delay.h> // Required for _delay_ms function

int main(void)
{
	DDRB = (1<<OUTPUT_RUN_ID);		// Set run indication LED to output mode

	while (1)
	{
		PORTB |= (1<<OUTPUT_RUN_ID);   // LED on
		_delay_ms(500);                // Hold for approx. 500 ms
		PORTB &= ~(1<<OUTPUT_RUN_ID);  // LED off
		_delay_ms(500);                // Hold for approx. 500 ms
	}
}

#endif