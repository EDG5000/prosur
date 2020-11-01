/*
 * driver_temp.h
 *
 * Created: 2020-10-23 11:14:40 PM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "drivers/driver_temp.h"
#include "config.h"
#include "stdint.h"
#include "string.h"

#include "unit_test_dataset/temperature_dataset.h"
extern uint16_t temperature_dataset[][HC3D_CONFIG_TEMP_SENSOR_COUNT];

// Wraps around at HC3D_TEMPERATURE_DATASET_SIZE
uint8_t unit_test_data_frame = 0;

void driver_temp_init(void){
	// NOP
}

// Generate fake data. Use the config value to determine the amount of temperature sensors present.
// TODO feed crafted data set as part of unit test. With the dataset, watchdog should trigger at a certain time
void driver_temp_read(uint16_t* arr, uint8_t length){
	if(unit_test_data_frame == HC3D_TEMPERATURE_DATASET_SIZE-1){
		// Wrap around frame counter
		unit_test_data_frame = 0;
	}
	
	// Copy data from dataset table into supplied array
	memcpy(arr, temperature_dataset[unit_test_data_frame], HC3D_CONFIG_TEMP_SENSOR_COUNT);

	unit_test_data_frame++;
}

#endif