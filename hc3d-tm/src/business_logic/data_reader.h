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

// Moving buffer of raw data
extern uint16_t data_reader_last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE][HC3D_CONFIG_TEMP_SENSOR_COUNT];

// Frame counter
extern uint16_t data_reader_frame;
// Settled when buffer is full
extern bool data_reader_settled;

// Returns true when all sensors are settled, false otherwise
// Reads out all sensors and update the moving buffer found 
void data_reader_tick(void);
