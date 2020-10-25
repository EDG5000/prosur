
/*
 * driver_pwm.c
 *
 * Created: 2020-10-25 11:41:35 AM
 *  Author: Joel
 */ 

#ifndef HC3D_TM_UNIT_TEST

#include "drivers/driver_pwm.h"
#include "ioport.h"

void driver_pwm_init(void){
		/*
			Setup PWM output on pin 10 (OCR1A) and 9 (OCR1B) (both use timer1)
			Should be ~25KHz
			Changing PWM is done by setting the register to 0-320
		*/

		/*
			Info

			pin 3 = OC2B (timer 2 PWM output B)
			pin 11 = OC2A (timer 2 PWM output A)
			pin 10 = OC1B (timer 1 PWM output B)
			pin 9 = OC1A (timer 1 PWM output A)
			pin 5 = OC0B (timer 0 PWM output B)
			pin 6 = OC0A (timer 0 PWM output A)
		*/
		
		// TODO check pin number! Constant might be needed
		ioport_set_pin_dir(HC3D_TM_CONFIG_PIN_RELAY, IOPORT_DIR_OUTPUT);
		
		https://arduinotoavr.wordpress.com/pinmode-2/
		//DDRB &= ~(1<<DDB1);??
		
		pinMode(9, OUTPUT);  //OCR1B
		pinMode(10, OUTPUT); //OCR1A

		TCCR1A = 0;            // Clear timer registers
		TCCR1B = 0;
		TCNT1 = 0;

		TCCR1B |= _BV(CS10);   // No prescaler
		ICR1 = 320;            // PWM mode counts up 320 then down 320 counts (25kHz)

		//OCR1A = pwmA;        // 0-320 = 0-100% duty cycle
		TCCR1A |= _BV(COM1A1); // Output A clear rising/set falling

		//OCR1B = pwmB;        // 0-320 = 0-100% duty cycle
		TCCR1A |= _BV(COM1B1); // Output B clear rising/set falling

		TCCR1B |= _BV(WGM13);  // PWM mode with ICR1 Mode 10
		TCCR1A |= _BV(WGM11);  // WGM13:WGM10 set 1010

}

void driver_pwm_set_pwm(uint8_t percentage){
	// 0-320 = 0-100% duty cycle
	// Scale percentage to desired range. Will discard fractional part
	OCR1A (percentage * 32) / 10;
}


#endif