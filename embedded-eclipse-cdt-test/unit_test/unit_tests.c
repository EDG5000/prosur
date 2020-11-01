/*
	SERIAL
		SLEEP	
			CLOCK
				DRIVER_TACH
			DRIVER_PWM
			DRIVER_RELAY	
 */ 

#include "config.h"

#include "drivers/driver_pwm.h"
#include "drivers/driver_sleep.h"
#include "drivers/driver_relay.h"
#include "drivers/driver_clock.h"

#include "libraries/avr_printf/avr_printf.h"
#include "stdio.h"
#include "stdbool.h"

#if HC3D_UNIT_TEST==HC3D_UNIT_TEST_SERIAL

int main(void){
	avr_printf_init();
	printf("HC3D_UNIT_TEST_SERIAL");
	printf("%i", 69);
	printf("%f", 101.1005);
}

#elif HC3D_UNIT_TEST==HC3D_UNIT_TEST_DRIVER_SLEEP

int main(void){
	avr_printf_init();
	printf("HC3D_UNIT_TEST_SLEEP");
	
	int time = 0;
	while(true){
		time += 100;
		printf("Sleeping %i ms.\n", time);
		driver_sleep(time);
	}
}

#elif HC3D_UNIT_TEST==HC3D_UNIT_TEST_DRIVER_CLOCK

int main(void){
	avr_printf_init();
	printf("HC3D_UNIT_TEST_CLOCK");
	driver_clock_init();
	
	int time = 0;
	while(true){
		time += 100;
		printf("Sleeping %i ms. Time: %lu\n", time, driver_clock_time());
		driver_sleep(time);
	}
}

#elif HC3D_UNIT_TEST==HC3D_UNIT_TEST_DRIVER_PWM

int main(void){
	avr_printf_init();
	printf("HC3D_UNIT_TEST_DRIVER_PWM");
	
	driver_pwm_init();
	
	while(true){
		driver_pwm_set_pwm(15);
		driver_sleep(1000);
		driver_pwm_set_pwm(100);
		driver_sleep(1000);
		driver_pwm_set_pwm(75);
		driver_sleep(1000);
	}
}

#elif HC3D_UNIT_TEST==HC3D_UNIT_TEST_DRIVER_RELAY

int main(void){
	avr_printf_init();
	printf("HC3D_UNIT_TEST_DRIVER_RELAY");
	
	driver_relay_init();
	
	int toggle = 1;
	
	while(true){
		toggle *= -1;
		printf("Setting relay to %i", toggle == 1);
		driver_relay_set(toggle == 1);
	}
}

#endif
