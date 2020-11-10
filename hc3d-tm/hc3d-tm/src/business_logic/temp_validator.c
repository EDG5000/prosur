/*
 * temp_validator.c
 *
 * Created: 2020-10-23 10:41:27 PM
 *  Author: Joel
 
 Features:
	- Handles single out-of-valid-range events gracefully, as well as sensors permanently entering out-of-valid-range state
	
TODO
 Shortcomings
	- Does not detect failure when sensors oscillate in and out of valid ranges within a 10-sec (10-frame) timeframe
	- Does not detect single in-valid-range high-delta event; emits new "valid" reading on such an event
	
 New Concept
							   ->		   [FAILSAFE]
 [RAW] -> =1Hz -> [VALIDATION] -> =<1Hz -> [TIMEOUT] -> [FAILSAFE]
 
 - Somehow detect the aforementioned shortcomings and trigger failsafe on such occasions
 
 */  

#include "config.h"
#include "stdint.h"
#include "stdbool.h"
#include "stdio.h"
#include "drivers/driver_clock.h"

#include "business_logic/temp_validator.h"
#include "business_logic/failsafe.h"
#include "business_logic/data_reader.h"
extern uint16_t last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE][HC3D_CONFIG_TEMP_SENSOR_COUNT];


// Store safety state per sensor
// Primary output of temp_validator
enum safety_state_t{
	INVALID,
	SAFE,
	UNSAFE,
	INITIAL
};
typedef enum safety_state_t safety_state_t;
safety_state_t sensor_safety_state[HC3D_CONFIG_TEMP_SENSOR_COUNT]; 

// Safety limit per sensor, copied from config constants
// Used for dyanmic access from loop
uint16_t sensor_safety_limit[HC3D_CONFIG_TEMP_SENSOR_COUNT];

// Secondary output: Store last valid temperature per sensor
// Will stay at 0 and will only change when a new valid value is detected
// Only used for reporting to other modules
uint16_t sensor_last_valid_temperature[HC3D_CONFIG_TEMP_SENSOR_COUNT];
// Output timestamps of when new reading were received
// TODO how to handle timer wraparound?
uint32_t sensor_last_update_time[HC3D_CONFIG_TEMP_SENSOR_COUNT];


void temp_validator_init(void){
	// Copy safety limits to array
	sensor_safety_limit[HC3D_TEMP_SENSOR_X] = HC3D_CONFIG_TEMP_SENSOR_X_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_Y] = HC3D_CONFIG_TEMP_SENSOR_Y_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_Z] = HC3D_CONFIG_TEMP_SENSOR_Z_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_E] = HC3D_CONFIG_TEMP_SENSOR_E_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_CHAMBER0] = HC3D_CONFIG_TEMP_SENSOR_CHAMBER0_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_CHAMBER1] = HC3D_CONFIG_TEMP_SENSOR_CHAMBER1_LIMIT;

	// Set all channels to state INITIAL
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		sensor_safety_state[sensor_index] =  INITIAL;
	}
}

static safety_state_t check_safety_state(uint16_t value, uint8_t sensor_index){
	// Check if the current reading is invalid
	if(value < HC3D_CONFIG_TEMP_VALID_MIN || value > HC3D_CONFIG_TEMP_VALID_MAX){
		// Sample is invalid, mark it as such
		return INVALID;
	}

	// Sample is valid, check if it exceeds the saffety limit
	return value > sensor_safety_limit[sensor_index] ? UNSAFE : SAFE;
}

// Returns false when one ore more channels has an unsafe value
void temp_validator_tick(void){
	// Update sensor_safety_state for all sensors
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		
		// Check if any uninitialized values are found
		// If that is the case, skip this channel for now
		// If a sensor would never get settled, temp_watchdog will trigger a timeout
		bool skip_sensor = false;
		for(int sample_index = 0; sample_index<HC3D_CONFIG_TEMP_BUF_SIZE; sample_index++){
			if(last_temperatures[sample_index][sensor_index] == 0){
				skip_sensor = true;
				break;
			}
		}
		if(skip_sensor){
			// Check the next sensor. Do not produce a new reading for this channel (yet).
			continue;
		}
		
		// Start checking the second-to-oldest sample, since we will be comparing it with the prevous sample
		for(int sample_index = 1; sample_index<HC3D_CONFIG_TEMP_BUF_SIZE; sample_index++){
			safety_state_t current_sample_safety_state = check_safety_state(last_temperatures[sample_index][sensor_index], sensor_index);
			safety_state_t last_sample_safety_state = check_safety_state(last_temperatures[sample_index-1][sensor_index], sensor_index);

			if(current_sample_safety_state != last_sample_safety_state){
				// The state is inconsistent for the last X samples, consider the state safe for now and stop checking newer samples for this sensor
				// NOTE: If the sensor would oscillate between safe/unsafe/invalid states, this will be considered safe.
				// NOTE: If the sensor is faulty as such that it will report invalid data every few readings, the state will be considered safe
				sensor_safety_state[sensor_index] = SAFE;
				break;			
			}

			if(sample_index == HC3D_CONFIG_TEMP_BUF_SIZE-1){
				// Last sample reached. The samples must have had a consistent safety state
				// Copy whatever state the last reading had
				sensor_safety_state[sensor_index] = current_sample_safety_state;
			}
		}
	}
	
	uint32_t time = driver_clock_time();
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		if(sensor_safety_state[sensor_index] == SAFE){
			// Update last valid temperature for each sensor considered safe
			sensor_last_valid_temperature[sensor_index] = last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][sensor_index];
			// Update timestamp
			sensor_last_update_time[sensor_index] = time;
		}
	}
}
