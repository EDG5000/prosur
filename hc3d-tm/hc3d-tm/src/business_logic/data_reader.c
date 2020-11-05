/*
 * data_reader.c
 *
 * Created: 2020-10-23 10:42:58 PM
 *  Author: Joel
 */ 

#include "data_reader.h"
#include "stdint.h"
#include "config.h"
#include "drivers/driver_temp.h"

// Moving buffer keeping the last 10 values.
uint16_t last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE][HC3D_CONFIG_TEMP_SENSOR_COUNT];

// Poll latest temperatures from driver_temp.
// Insert frame into moving buffer.
// Note: Caller should take processing time of 1 call to driver_temp into account when timing this call.
void data_reader_tick(void){
	// Copy values over to buffer and back to shift them all one back.
	// Start at position 1. Copy to position before it.
	for(int frame_index = 1; frame_index < HC3D_CONFIG_TEMP_BUF_SIZE; frame_index++){
		// Copy each value from this frame to the preceding frame
		for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
			last_temperatures[frame_index-1][sensor_index] = last_temperatures[frame_index][sensor_index];
		}	
	}

	// Get a new value for each sensor.
	uint16_t new_reading[HC3D_CONFIG_TEMP_SENSOR_COUNT];
	driver_temp_read(new_reading);

	// Overwrite last frame, which is already copied to the frame preceding it.
	// Write the newly retrieved data to it.
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][sensor_index] = new_reading[sensor_index];
	}
}