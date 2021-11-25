/*
 * driver_temp.h
 *
 * Created: 2020-10-23 11:14:28 PM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"

#define DRIVER_TEMP_ROM_SIZE 8

extern uint8_t driver_temp_roms_found;
extern uint16_t driver_temp_last_readings[HC3D_MAX_TEMP_SENSORS];
extern uint8_t driver_temp_roms[HC3D_MAX_TEMP_SENSORS][DRIVER_TEMP_ROM_SIZE];

void driver_temp_read(void);
