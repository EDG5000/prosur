/*
 * driver_temp.h
 *
 * Created: 2020-10-23 11:14:40 PM
 *  Author: Joel
 */ 

#include "drivers/driver_temp.h"
#include "config.h"
#include "stdint.h"

#pragma once

void driver_temp_init(void){
	// NOP
}

// Generate fake data. Use the config value of determine the amount of temperature sensors present.
// TODO feed crafted data set as part of unit test. With the dataset, watchdog should trigger at a certain time
uint16_t* driver_temp_read(uint16_t arr*, uint8_t length){
	uint16_t values[HC3D_TM_CONFIG_PIN_TEMP_COUNT];
	for(int i = 0; i < HC3D_TM_CONFIG_PIN_TEMP_COUNT; i++){
		values[i] = rand() / (RAND_MAX/HC3D_TM_CONFIG_PIN_TEMP_COUNT);
	}
	return values;
}