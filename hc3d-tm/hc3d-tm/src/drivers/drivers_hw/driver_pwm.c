
/*
 * driver_pwm.c
 *
 * Created: 2020-10-25 11:41:35 AM
 *  Author: Joel
 */ 


#include "config.h"

#if HC3D_USE_TEST_DRIVERS==0

#include "avr/io.h"
#include "drivers/driver_pwm.h"
#include "avr/io.h"

void driver_pwm_init(void){
		/*
			Setup PWM output on pin 9 (OCR1A) and 10 (OCR1B) (both use timer1)
			Only pin 9 actively used.
			Pin 10 reserved for second PWM channel.
			Should be ~25KHz
			Changing PWM is done by setting the register to 0-320
		*/
	

		DDRB |= (1 << PINB1); // Set bit 1 of Port B data direction register to output
		DDRB = 0xFF;
		
		TCCR1A = 0;            //clear timer registers
		TCCR1B = 0;
		TCNT1 = 0;

		TCCR1B |= _BV(CS10);   //no prescaler
		ICR1 = 320;            //PWM mode counts up 320 then down 320 counts (25kHz)

		//OCR1A = pwmA;          //0-320 = 0-100% duty cycle
		TCCR1A |= _BV(COM1A1); //output A clear rising/set falling

		//OCR1B = pwmB;          //0-320 = 0-100% duty cycle
		TCCR1A |= _BV(COM1B1); //output B clear rising/set falling

		TCCR1B |= _BV(WGM13);  //PWM mode with ICR1 Mode 10
		TCCR1A |= _BV(WGM11);  //WGM13:WGM10 set 1010
}

void driver_pwm_set_pwm(uint8_t percentage){
	// 0-320 = 0-100% duty cycle
	// Scale percentage to desired range. Will discard fractional part
	// Only change PWM for pin 9
	OCR1A = (percentage * 32) / 10;
}


#endif