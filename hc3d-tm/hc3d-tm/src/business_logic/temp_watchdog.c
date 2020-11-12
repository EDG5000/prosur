
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

// Safety limit per sensor, copied from config constants
// Used for dyanmic access from loop
uint16_t sensor_safety_limit[HC3D_CONFIG_TEMP_SENSOR_COUNT];

void temp_watchdog_init(void){
	// Copy safety limits to array
	sensor_safety_limit[HC3D_TEMP_SENSOR_X] = HC3D_CONFIG_TEMP_SENSOR_X_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_Y] = HC3D_CONFIG_TEMP_SENSOR_Y_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_Z] = HC3D_CONFIG_TEMP_SENSOR_Z_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_E] = HC3D_CONFIG_TEMP_SENSOR_E_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_CHAMBER0] = HC3D_CONFIG_TEMP_SENSOR_CHAMBER0_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_CHAMBER1] = HC3D_CONFIG_TEMP_SENSOR_CHAMBER1_LIMIT;
}

bool temp_watchdog_tick(void){
	// Check if any sensors are currently exceeding their maximum temperature limit
	bool failure = false;
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		int16_t val = temp_validator_sensor_last_valid_temperature[sensor_index];
		if(val > sensor_safety_limit[sensor_index]){
			printf("Sensor %i failed at temperature %i", sensor_index, val);	
			failure = true;
		}
	}
	
	if(failure){
		failsafe_trigger();
	}
	
	// Check for timeouts
	uint32_t time = driver_clock_time();
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		uint32_t age = util_time_offset(temp_validator_sensor_last_update_time[sensor_index], time);
		if(age > HC3D_CONFIG_TEMP_WATCHDOG_TIMEOUT){
			printf("Sensor %i has timed out. Age: %lu ms", sensor_index, age);
			failure = true;
		}
	}
	
	if(failure){
		failsafe_trigger();
	}
	return !failure;
}