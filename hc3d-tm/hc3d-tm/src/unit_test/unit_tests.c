/*
	ALL
	SERIAL
		SLEEP	
			CLOCK
				DRIVER_TACH
			DRIVER_PWM
				PWM_AND_CLOCK
			DRIVER_RELAY	
			TEMP
			TACH
 */ 

#include "config.h"

#include "drivers/driver_pwm.h"
#include "drivers/driver_sleep.h"
#include "drivers/driver_relay.h"
#include "drivers/driver_clock.h"
#include "drivers/driver_temp.h"
#include "drivers/driver_tach.h"

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
	double sleep = 0;
	uint32_t time = 0;
	while(true){
		sleep += 500;
		uint32_t last_time = time;
		time = driver_clock_time();
		printf("Sleeping %i ms. Time: %lu. Delta: %lu\n", (int) sleep, time, time-last_time);
		driver_sleep(sleep);
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
	
	int8_t toggle = 1;
	while(true){
		toggle *= -1;
		printf("Setting relay to %i\n", toggle == 1);
		driver_relay_set(toggle == 1);
		driver_sleep(1000);
	}
}

#elif HC3D_UNIT_TEST==HC3D_UNIT_TEST_PWM_AND_CLOCK

int main(void){
	avr_printf_init();
	printf("HC3D_UNIT_TEST_PWM_AND_CLOCK");
	
	driver_relay_init();
	driver_pwm_init();
	driver_clock_init();
	
	int8_t toggle = 1;

	while(true){ // Every 1000ms. 
		

		toggle *= -1;
		uint32_t time = driver_clock_time();
		if(toggle == 1){
			driver_pwm_set_pwm(15);
			printf("Setting pwm to %i. Time: %lu.\n", 15, time);
		}else{
			driver_pwm_set_pwm(75);
			printf("Setting pwm to %i. Time: %lu.\n", 75, time);
		}
		
		driver_relay_set(toggle == 1);	
		driver_sleep(1000);
	}
}

#elif HC3D_UNIT_TEST==HC3D_UNIT_TEST_DRIVER_TEMP

int main(void){
	avr_printf_init();
	printf("HC3D_UNIT_TEST_DRIVER_TEMP");
	
	driver_temp_init();
	
	uint16_t temperatures[HC3D_CONFIG_TEMP_SENSOR_COUNT];
	
	while(true){
		driver_temp_read(temperatures);
		printf("Temperatures");
		for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
			printf(" | %i", temperatures[i]);
		}
		driver_sleep(1000);
		printf("\n");
	}
}

#elif HC3D_UNIT_TEST==HC3D_UNIT_TEST_TACH

int main(void){
	avr_printf_init();
	printf("HC3D_UNIT_TEST_TACH");
	driver_tach_init();
	uint32_t val;
	while(true){
		val = driver_tach_get();
		printf("Tach value: %lu.\n", val);
		
		driver_sleep(1000);
	}
}

#endif