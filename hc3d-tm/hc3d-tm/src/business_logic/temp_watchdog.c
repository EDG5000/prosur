
/*
 * temp_watchdog.c
 *
 * Created: 2020-11-10 6:41:22 AM
 *  Author: Joel

	// Check output of temp validator for any invalid values or timeouts in producing new values
 */ 

#include "temp_watchdog.h"
#include "util.h"
#include "drivers/driver_clock.h"
#include "failsafe.h"
#include "temp_validator.h"
#include "stdio.h"
#include "stdbool.h"
#include "config.h"

#include "temp_validator.h"

void temp_watchdog_init(void){
	; // NOP for now
}

bool temp_watchdog_tick(void){
	// Check if any sensors are currently marked as unsafe or invalid
	bool failure = false;
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		if(sensor_safety_state[sensor_index] == UNSAFE && sensor_safety_state[sensor_index] == INVALID){
			// There was an unsafe sensor. This means the failsafe was tripped
			// Report details about the sensor to UART for diag. purposes
			// Report details about why the failsafe tripped
			printf("Sensor %i", sensor_index);
			if(sensor_safety_state[sensor_index] == UNSAFE){
				printf(" has state UNSAFE.");
			}else if(sensor_safety_state == INVALID){
				printf(" has state INVALID.");
			}
			failure = true;
		}
	}
	
	// Check for timeouts
	uint32_t time = driver_clock_time();
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		uint32_t age = util_time_offset(temp_validator_sensor_last_update_time[sensor_index], time);
		if(age > HC3D_CONFIG_TEMP_WATCHDOG_TIMEOUT){
			printf("Sensor %i has timed out. Age: %lu", sensor_index, age);
			failure = true;
		}
	}
	
	if(failure){
		failsafe_trigger();
	}
	return !failure;
}