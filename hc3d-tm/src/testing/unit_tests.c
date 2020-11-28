/*
	ALL
	SERIAL
		SLEEP	
			CLOCK
				DRIVER_TACH
				DRIVER_PWM
				PWM_AND_CLOCK
					TEMP_FAILSAFE
			DRIVER_RELAY	
			DRIVER_TEMP
				DATA_REPORTER
			PUMP_CONTROLLER
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
#include "drivers/driver_system.h"
#include "libraries/str/str.h"
#include "stdbool.h"

#include "business_logic/temp_validator.h"
#include "business_logic/temp_watchdog.h"
#include "business_logic/data_reader.h"
#include "business_logic/data_reporter.h"
#include "business_logic/pump_controller.h"

#include "temperature_dataset.h"
#include "stdlib.h"
#include "stdio.h"

#if HC3D_TEST_MODE==HC3D_TEST_MODE_SERIAL

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_SERIAL\n");
	fflush(stdout);
	str("%u", (uint16_t) 4534534);
	str("%u", (uint8_t) 213);

	driver_system_halt();
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

	driver_system_halt();
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

	driver_system_halt();
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_PWM

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_DRIVER_PWM");
	driver_pwm_init();
	while(true){
		driver_pwm_set(15);
		driver_sleep(1000);
		data_reporter_tick(0);

		driver_pwm_set(100);
		driver_sleep(1000);
		data_reporter_tick(0);

		driver_pwm_set(75);
		driver_sleep(1000);
		data_reporter_tick(0);
	}
	driver_system_halt();
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

	driver_system_halt();
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

	driver_system_halt();
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DRIVER_TEMP

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_DRIVER_TEMP\n");


	while(true){
		driver_temp_read();
		str("Temperatures");
		for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
			str(" | %u", driver_temp_last_readings[i]);
		}
		driver_sleep(1000);
		str("\n");
	}

	driver_system_halt();

}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_DATA_REPORTER

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_DATA_REPORTER\n");
	driver_clock_init();
	temp_validator_init();

	while(true){
		uint16_t time = driver_clock_time();
		driver_temp_read();
		data_reader_tick();
		temp_validator_tick();
		data_reporter_tick(time);
		driver_sleep(1000);
	}

	driver_system_halt();
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_TACH

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_TACH");
	driver_tach_init();
	driver_pwm_init();

	uint8_t pwm = 0;
	while(true){
		/*if(pwm != 100){
			pwm += 1;
		}else{
			pwm = 0;
		}*/

		driver_pwm_set(pwm);
		driver_sleep(500);
		data_reporter_tick(0); // Will fetch tach reading and display it
	}

	driver_system_halt();
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
	
	uint16_t time_tick_start = 0;

	while(data_reader_frame < HC3D_TEMPERATURE_DATASET_SIZE){
		// Record tick start time to later calculate the correct sleep time
		time_tick_start = driver_clock_time();
		driver_temp_read();
		data_reader_tick();
		temp_validator_tick();
		temp_watchdog_tick();
        data_reporter_tick();

		uint16_t time_taken = util_time_offset(time_tick_start, driver_clock_time());
		driver_sleep(HC3D_INTERVAL - time_taken); // Ensure constant interval
  	}	
	
	driver_system_halt();
}

#elif HC3D_TEST_MODE==HC3D_TEST_MODE_PUMP_CONTROLLER

int main(void){
	driver_uart_init();
	str("HC3D_TEST_MODE_PUMP_CONTROLLER\n");
	fflush(stdout);
	driver_clock_init();
	pump_controller_init();

	for(uint8_t sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		temp_validator_sensor_last_valid_temperature[sensor_index] = util_temp_raw(30);
	}

	uint16_t test_frame = 0;
	while(test_frame < 10000){
		for(uint8_t sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
			// Up to 8-16 of heating added when motors on
			int16_t heating = 8 + (rand() % 8);
			// 0-16 cooling substracted
			int16_t cooling = driver_pwm_value / 6;
			// Get delta
			int16_t delta = heating - cooling;
			// Cast to apply delta confidently
			int16_t temp_signed = ((int16_t) temp_validator_sensor_last_valid_temperature[sensor_index]) + delta;
			// Cast back to signed value to store new temperature
			temp_validator_sensor_last_valid_temperature[sensor_index] = (uint16_t) temp_signed;
		}

		// Report state
		driver_temp_read();
		data_reader_tick();
		data_reporter_tick(0);
		pump_controller_tick();
		test_frame++;
	}
	driver_system_halt();
}

#endif
