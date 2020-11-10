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

#include "business_logic/temp_validator.h"
#include "business_logic/data_reader.h"
extern uint16_t last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE][HC3D_CONFIG_TEMP_SENSOR_COUNT];

#include "temperature_dataset.h"
extern int16_t temperature_dataset[][HC3D_CONFIG_TEMP_SENSOR_COUNT];

#if HC3D_TEST_MODE==HC3D_TEST_MODE_SERIAL

int main(void){
	avr_printf_init();
	printf("HC3D_TEST_MODE_SERIAL");
	printf("%i", 69);
	printf("%f", 101.1005);
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_SLEEP

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

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_CLOCK

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

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_PWM

int main(void){
	avr_printf_init();
	printf("HC3D_TEST_MODE_DRIVER_PWM");
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

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_RELAY

int main(void){
	avr_printf_init();
	printf("HC3D_TEST_MODE_DRIVER_RELAY");
	
	driver_relay_init();
	
	int8_t toggle = 1;
	while(true){
		toggle *= -1;
		printf("Setting relay to %i\n", toggle == 1);
		driver_relay_set(toggle == 1);
		driver_sleep(1000);
	}
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_PWM_AND_CLOCK

int main(void){
	avr_printf_init();
	printf("HC3D_TEST_MODE_PWM_AND_CLOCK");
	
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

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_TEMP

int main(void){
	avr_printf_init();
	printf("HC3D_TEST_MODE_DRIVER_TEMP");
	
	
	int16_t temperatures[HC3D_CONFIG_TEMP_SENSOR_COUNT];
	
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

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_TACH

int main(void){
	avr_printf_init();
	printf("HC3D_TEST_MODE_TACH");
	driver_tach_init();
	uint32_t val;
	while(true){
		val = driver_tach_get();
		printf("Tach value: %lu.\n", val);
		
		driver_sleep(1000);
	}
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_TEMP_FAILSAFE

int main(void){
	avr_printf_init();
	printf("HC3D_TEST_MODE_TACH");
	
	driver_clock_init();
	
	temp_validator_init();
	temp_watchdog_init();
	
	// Use last_temperatures from data_reader to inject input in what driver_temp is reading
	//last_temperatures;
		
	/*
	 Features:
	 - Handles single out-of-valid-range events gracefully, as well as sensors permanently entering out-of-valid-range state
	 
	 Shortcomings
	 - Does not detect failure when sensors oscillate in and out of valid ranges within a 10-sec (10-frame) timeframe
	 - Does not detect single in-valid-range high-delta event; emits new "valid" reading on such an event
	 */
	
	uint16_t test_data_frame = 0;
	
	while(true){
		// Record tick start time to later calculate the correct sleep time
		uint32_t time_start = driver_clock_time();
			
		// Manually move the rotating input buffer (last_temperatures) used by temp watchdog one tick forward
		// Normally data_reader is performing this operation as well as invoking driver_temp
		for(int frame_index = 1; frame_index < HC3D_CONFIG_TEMP_BUF_SIZE; frame_index++){
			// Copy each value from this frame to the preceding frame
			for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
				last_temperatures[frame_index-1][sensor_index] = last_temperatures[frame_index][sensor_index];
			}	
		}
		
		// Copy next value from test dataset into moving buffer, unless it is 0, in which case, we use the last available value for that sensor
		for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
			int16_t value = temperature_dataset[test_data_frame][sensor_index];
			if(value == 0 && test_data_frame > 0){
				// Use previous value from dataset when a zero value is provided
				value = temperature_dataset[test_data_frame-1][sensor_index];
			}
			last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][sensor_index] = value;
		}
		
		// Run temp validator
		temp_validator_tick();
		
		volatile int a = 0;
		// Run temp_validator, which also calculates validated temperatures used later
		if(!temp_watchdog_tick()){
			// temp_validator has invoked the failsafe
			// Abort excecution of program
			while(true){
				;
			}
		}

		uint32_t time_taken = util_time_offset(time_start, driver_clock_time());
		driver_sleep(1000 - time_taken); // 1 sec delay + data reader time duration
		
		test_data_frame++;
	}	
}

#endif