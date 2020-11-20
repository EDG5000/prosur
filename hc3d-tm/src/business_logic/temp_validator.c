/*
 * temp_validator.c
 *
 * Created: 2020-10-23 10:41:27 PM
 *  Author: Joel
	Optionally produces new valid temperatures each tick
	Temperatures published at temp_validator_sensor_last_valid_temperature, timestamp at
	temp_validator_sensor_last_update_time.
 
	Flow diagram:
	RAW (1Hz)-> VALID (opt) -> UNSAFE (OPT) -> FAILSAFE
							-> TIMEOUT (OPT) -> FAILSAFE
 
	Validation critera:
	- No zeroes in buffer
	- No values outside VALID_MIN & VALID_MAX
	- At least one value changed in the buffer
	- Current reading delta with last valid reading does not exceed 0.5 (arb. val.)
	
 */  

#include "config.h"
#include "stdint.h"
#include "stdbool.h"
#include "stdlib.h"
#include "libraries/str/str.h"
#include "drivers/driver_clock.h"

#include "business_logic/temp_validator.h"
#include "business_logic/failsafe.h"
#include "business_logic/data_reader.h"

// Secondary outputs: Store last valid temperature per sensor
// Will stay at 0 and will only change when a new valid value is detected
// Only used for reporting to other modules
uint8_t temp_validator_sensor_last_valid_temperature[HC3D_CONFIG_TEMP_SENSOR_COUNT];
// Output timestamps of when new reading were received
uint16_t temp_validator_sensor_last_update_time[HC3D_CONFIG_TEMP_SENSOR_COUNT];

void temp_validator_init(void){
	;
}

// Returns false when one ore more channels has an unsafe value
void temp_validator_tick(void){
	uint16_t time = driver_clock_time();
	
	// Update sensor_safety_state for all sensors
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		// At least one delta has to be observed in the buffer. Set high when found.
		bool delta_found = false;
		// Set high when an invalid condition is detected and the sensor is to be skipped for further checking
		bool sensor_invalidated = false;
		// All fields need to be non-zero and be within valid range. (2-120, defined in config)
		for(int sample_index = 0; sample_index < HC3D_CONFIG_TEMP_BUF_SIZE; sample_index++){
			uint8_t val = data_reader_last_temperatures[sample_index][sensor_index];
			if(val == 0 || val < HC3D_CONFIG_TEMP_VALID_MIN || val > HC3D_CONFIG_TEMP_VALID_MAX){
				// Do not emit new value for this sensor, continue checking next sensor
				sensor_invalidated = true;
				break;
			}
			if(sample_index > 0 && val != data_reader_last_temperatures[sample_index-1][sensor_index]){
				delta_found = true;
			}
		}
		if(!delta_found){
			// When no single delta was found, invalidate sensor channel
			sensor_invalidated = true;
		}

		// Check delta between last value and last valid value; has to be below the limit
		uint8_t last_valid_value = temp_validator_sensor_last_valid_temperature[sensor_index];
		bool last_valid_delta_acceptable = last_valid_value == 0 || abs(last_valid_value - data_reader_last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][sensor_index]) < HC3D_CONFIG_TEMP_MAX_DELTA;

		if(!last_valid_delta_acceptable){
			sensor_invalidated = true;
		}

		// Check when sensor was invalid or no delta
		if(sensor_invalidated){
			// Do not emit new value for this sensor, continue checking next sensor
			continue;
		}else{
			// Sensor is considered valid, emit new value
			temp_validator_sensor_last_valid_temperature[sensor_index] = data_reader_last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][sensor_index];
			// Update timestamp
			temp_validator_sensor_last_update_time[sensor_index] = time;
		}
	}
}
