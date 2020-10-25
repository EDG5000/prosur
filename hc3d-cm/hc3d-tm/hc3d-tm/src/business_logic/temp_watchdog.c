/*
 * temp_watchdog.c
 *
 * Created: 2020-10-23 10:41:27 PM
 *  Author: Joel
 */ 

#include "stdint.h"
#include "config.h"
#include "stdbool.h"

#include "stdio.h"
#include "drivers/driver_uart.h"
#include "business_logic/temp_watchdog.h"
#include "business_logic/failsafe.h"
#include "business_logic/data_reader.h"
extern uint16_t last_temperatures[HC3D_TM_CONFIG_TEMP_BUF_SIZE][HC3D_TM_CONFIG_TEMP_SENSOR_COUNT];

// Store safety state per sensor
// Primary output of temp_watchdog

enum safety_state_t{
	INVALID,
	SAFE,
	UNSAFE
};
typedef enum safety_state_t safety_state_t;
safety_state_t sensor_safety_state[HC3D_TM_CONFIG_TEMP_SENSOR_COUNT]; 

// Safety limit per sensor, copied from config constants
// Used for easy access from loop
uint16_t sensor_safety_limit[HC3D_TM_CONFIG_TEMP_SENSOR_COUNT];

// Secondary output: Store last valid temperature per sensor
// Will stay at 0 and will only change when a new valid value is detected
// Only used for reporting to other modules
uint16_t sensor_last_valid_temperature[HC3D_TM_CONFIG_TEMP_SENSOR_COUNT];

void temp_watchdog_init(void){
	// Copy safety limits to array
	sensor_safety_limit[HC3D_TM_TEMP_SENSOR_X] = HC3D_TM_TEMP_SENSOR_X_LIMIT;
	sensor_safety_limit[HC3D_TM_TEMP_SENSOR_Y] = HC3D_TM_TEMP_SENSOR_Y_LIMIT;
	sensor_safety_limit[HC3D_TM_TEMP_SENSOR_Z] = HC3D_TM_TEMP_SENSOR_Z_LIMIT;
	sensor_safety_limit[HC3D_TM_TEMP_SENSOR_E] = HC3D_TM_TEMP_SENSOR_E_LIMIT;
	sensor_safety_limit[HC3D_TM_TEMP_SENSOR_CHAMBER0] = HC3D_TM_TEMP_SENSOR_CHAMBER0_LIMIT;
	sensor_safety_limit[HC3D_TM_TEMP_SENSOR_CHAMBER1] = HC3D_TM_TEMP_SENSOR_CHAMBER1_LIMIT;
}

static safety_state_t check_safety_state(uint16_t value, uint8_t sensor_index){
	// Check if the current reading is invalid
	if(value < HC3D_TM_CONFIG_TEMP_VALID_MIN || value > HC3D_TM_CONFIG_TEMP_VALID_MAX){
		// Sample is invalid, mark it as such
		return INVALID;
	}

	// Sample is valid, check if it exceeds the saffety limit
	return value > sensor_safety_limit[sensor_index] ? UNSAFE : SAFE;
}

// Returns false when one ore more channels has an unsafe value
bool temp_watchdog_tick(void){
	// Update sensor_safety_state for all sensors
	for(int sensor_index = 0; sensor_index < HC3D_TM_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		// Start checking the second-to-oldest sample, since we will be comparing it with the prevous sample
		for(int sample_index = 1; sample_index<HC3D_TM_CONFIG_TEMP_BUF_SIZE; sample_index++){
			safety_state_t current_sample_safety_state = check_safety_state(last_temperatures[sensor_index][sample_index], sensor_index);
			safety_state_t last_sample_safety_state = check_safety_state(last_temperatures[sensor_index][sample_index-1], sensor_index);

			if(current_sample_safety_state != last_sample_safety_state){
				// The state is inconsistent for the last X samples, consider the state safe for now and stop checking newer samples for this sensor
				// NOTE: If the sensor would oscillate between safe/unsafe/invalid states, this will be considered safe.
				// NOTE: If the sensor is faulty as such that it will report invalid data every few readings, the state will be considered safe
				sensor_safety_state[sensor_index] = SAFE;
				break;			
			}

			if(sample_index == HC3D_TM_CONFIG_TEMP_BUF_SIZE-1){
				// Last sample reached. The samples must have had a consistent safety state
				// Copy whatever state the last reading had
				sensor_safety_state[sensor_index] = current_sample_safety_state;
			}
		}
	}

	// Trigger failsafe when a sensor is in INVALID or UNSAFE state
	bool failsafe_tripped = false;
	for(int sensor_index = 0; sensor_index < HC3D_TM_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		if(sensor_safety_state[sensor_index] != SAFE){
			failsafe_trigger();
			failsafe_tripped = true;
			break;
		}
	}

	for(int sensor_index = 0; sensor_index < HC3D_TM_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		if(sensor_safety_state[sensor_index] != SAFE){
			// There was an unsafe sensor. This means the failsafe was tripped
			// Report details about the sensor to UART for diag. purposes
			// Report details about why the failsafe tripped
			driver_uart_write("Sensor ");
			char str_sensor_index[10];
			sprintf(str_sensor_index, "%d", sensor_index);
			driver_uart_write(str_sensor_index);
			if(sensor_safety_state[sensor_index] == UNSAFE){
				driver_uart_write("has state UNSAFE.");
			}else if(sensor_safety_state == INVALID){
				driver_uart_write("has state INVALID.");
			}
		}else{
			// Update last valid temperature for each sensor considered safe
			sensor_last_valid_temperature[sensor_index] = last_temperatures[HC3D_TM_CONFIG_TEMP_BUF_SIZE-1][sensor_index];
		}
	}

	return failsafe_tripped;
}
