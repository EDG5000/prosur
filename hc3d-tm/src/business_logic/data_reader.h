/*
 * data_reader.h
 *
 * Created: 2020-10-23 10:42:34 PM
 *  Author: Joel
 */ 

#pragma once

#include "business_logic/data_reader.h"
#include "stdint.h"
#include "stdbool.h"
#include "config.h"

extern uint8_t data_reader_last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE][HC3D_CONFIG_TEMP_SENSOR_COUNT];

// Returns true when all sensors are settled, false otherwise
// Reads out all sensors and update the moving buffer found 
bool data_reader_tick(void);
