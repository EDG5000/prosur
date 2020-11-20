/*
 * data_reporter.c
 *
 * Created: 2020-10-24 4:57:55 PM
 *  Author: Joel
 */ 

#include "config.h"
#include "business_logic/data_reporter.h"
#include "business_logic/data_reader.h"
#include "business_logic/temp_validator.h"
#include "libraries/str/str.h"

void data_reporter_tick(uint16_t time){
	str("[%u] (%u)", time, data_reader_frame);

	// Print raw temperatures
	for(uint8_t i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
		uint8_t raw_temp = data_reader_last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][i];
		str(" rt%u:%u", i, raw_temp);
	}

    // Print valid temperatures and update times
    for(uint8_t sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
    	uint8_t valid_temp = temp_validator_sensor_last_valid_temperature[sensor_index];
    	uint8_t update_time = temp_validator_sensor_last_update_time[sensor_index];
        str(" vt%u:%u ut%u:%u", sensor_index, valid_temp, sensor_index, update_time);
    }

    // TODO: pi controller state, pump controller setpoint, tach reading

    str("\n");
}
