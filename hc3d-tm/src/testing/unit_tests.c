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
#include "util.h"

#include "drivers/driver_pwm.h"
#include "drivers/driver_sleep.h"
#include "drivers/driver_relay.h"
#include "drivers/driver_clock.h"
#include "drivers/driver_temp.h"
#include "drivers/driver_tach.h"
#include "drivers/driver_uart.h"

#include "libraries/str/str.h"
#include "stdbool.h"

#include "business_logic/temp_validator.h"
#include "business_logic/temp_watchdog.h"
#include "business_logic/data_reader.h"
#include "business_logic/data_reporter.h"

#include "temperature_dataset.h"

#include "stdio.h"

#if HC3D_TEST_MODE==HC3D_TEST_MODE_SERIAL

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_SERIAL");
	str("%i", 69);
	str("%f", 101.1005);
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_SLEEP

int main(void){
	driver_uart_init();
	str("HC3D_UNIT_TEST_SLEEP");
	
	int time = 0;
	while(true){
		time += 100;
		str("Sleeping %i ms.\n", time);
		driver_sleep(time);
	}
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_CLOCK

int main(void){
	driver_uart_init();
	str("HC3D_UNIT_TEST_CLOCK");
	driver_clock_init();
	uint16_t sleep = 0;
	uint16_t last_time = 0;
	while(true){
		sleep += 500;
		uint16_t time = driver_clock_time();
		str("Sleeping %u ms. Time: %u. Delta: %u\n", sleep, time, util_time_offset(last_time, time));
		driver_sleep(sleep);
		last_time = time;
	}
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_PWM

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_DRIVER_PWM");
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
	driver_uart_init();
	str("HC3D_TEST_MODE_DRIVER_RELAY");
	
	driver_relay_init();
	
	int8_t toggle = 1;
	while(true){
		toggle *= -1;
		str("Setting relay to %i\n", toggle == 1);
		driver_relay_set(toggle == 1);
		driver_sleep(1000);
	}
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_PWM_AND_CLOCK

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_PWM_AND_CLOCK");
	
	driver_relay_init();
	driver_pwm_init();
	driver_clock_init();
	
	int8_t toggle = 1;

	while(true){ // Every 1000ms. 
		

		toggle *= -1;
		uint16_t time = driver_clock_time();
		if(toggle == 1){
			driver_pwm_set_pwm(15);
			str("Setting pwm to %i. Time: %lu.\n", 15, time);
		}else{
			driver_pwm_set_pwm(75);
			str("Setting pwm to %i. Time: %lu.\n", 75, time);
		}
		
		driver_relay_set(toggle == 1);	
		driver_sleep(1000);
	}
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_TEMP

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_DRIVER_TEMP");
	
	
	int16_t temperatures[HC3D_CONFIG_TEMP_SENSOR_COUNT];
	
	while(true){
		driver_temp_read(temperatures);
		str("Temperatures");
		for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
			str(" | %i", temperatures[i]);
		}
		driver_sleep(1000);
		str("\n");
	}
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_TACH

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_TACH");
	driver_tach_init();
	uint16_t val;
	while(true){
		val = driver_tach_get();
		str("Tach value: %lu.\n", val);
		
		driver_sleep(1000);
	}
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_TEMP_FAILSAFE

int main(void){
   	driver_uart_init();
	str("HC3D_TEST_MODE_TEMP_FAILSAFE\n");
	fflush(stdout);
	temperature_dataset_init();
	driver_clock_init();
	
	temp_validator_init();
	temp_watchdog_init();
	
	while(data_reader_frame < HC3D_TEMPERATURE_DATASET_SIZE){
		// Record tick start time to later calculate the correct sleep time
		uint16_t time_tick_start = driver_clock_time();

		data_reader_tick();
		temp_validator_tick();
		temp_watchdog_tick();
        data_reporter_tick(time_tick_start);

		uint16_t time_taken = util_time_offset(time_tick_start, driver_clock_time());
		driver_sleep(HC3D_INTERVAL - time_taken); // Ensure constant interval
  	}	
	
	// Turn off MCU, PWM, etc. Test session over. Debugger will be detached.
	while(1);
}

#endif
