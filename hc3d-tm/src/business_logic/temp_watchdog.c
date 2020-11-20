
/*
 * temp_watchdog.c
 *
 * Created: 2020-11-10 6:41:22 AM
 *  Author: Joel

	// Check output of temp validator for any invalid values or timeouts in producing new values
 */ 

#include "business_logic/temp_watchdog.h"
#include "util.h"
#include "drivers/driver_clock.h"
#include "business_logic/failsafe.h"
#include "business_logic/temp_validator.h"
#include "business_logic/data_reader.h"
#include "libraries/str/str.h"
#include "stdbool.h"
#include "config.h"


// Safety limit per sensor, copied from config constants
// Used for dyanmic access from loop
uint8_t sensor_safety_limit[HC3D_CONFIG_TEMP_SENSOR_COUNT];

void temp_watchdog_init(void){
	// Copy safety limits to array
	sensor_safety_limit[HC3D_TEMP_SENSOR_X] = HC3D_CONFIG_TEMP_SENSOR_X_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_Y] = HC3D_CONFIG_TEMP_SENSOR_Y_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_Z] = HC3D_CONFIG_TEMP_SENSOR_Z_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_E] = HC3D_CONFIG_TEMP_SENSOR_E_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_CHAMBER0] = HC3D_CONFIG_TEMP_SENSOR_CHAMBER0_LIMIT;
	sensor_safety_limit[HC3D_TEMP_SENSOR_CHAMBER1] = HC3D_CONFIG_TEMP_SENSOR_CHAMBER1_LIMIT;
}

void temp_watchdog_tick(void){
	if(!data_reader_settled){
		// Skip unless data reader settled (buffer full)
		return;
	}

	// Check if any sensors are currently exceeding their maximum temperature limit
	bool failure = false;
	uint16_t time = driver_clock_time();
	for(uint8_t sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		uint8_t val = temp_validator_sensor_last_valid_temperature[sensor_index];
		uint8_t limit = sensor_safety_limit[sensor_index];
		uint16_t last_time = temp_validator_sensor_last_update_time[sensor_index];
		uint16_t age = util_time_offset(last_time, time);

		if(val == 0){
			// After sensor has been given time to settle, there should be a previous reading.
			str("Sensor %u has no valid reading.\n", sensor_index);
			failure = true;
		}else if(val > limit){
			str("Sensor %u exceeded limit of %u at temperature %u.\n", sensor_index, limit, val);
			failure = true;
		}else if(last_time == 0 || age > HC3D_CONFIG_TEMP_WATCHDOG_TIMEOUT){
			// If the previous timestamp is 0, then
			str("Sensor %u has timed out. Age: %u ms.\n", (uint16_t) sensor_index, age);
			failure = true;
		}
	}
	
	if(failure){
		failsafe_trigger();
	}

	return;
}
