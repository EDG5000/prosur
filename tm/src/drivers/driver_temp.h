/*
 * driver_temp.h
 *
 * Created: 2020-10-23 11:14:28 PM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"

extern uint16_t driver_temp_last_readings[HC3D_CONFIG_TEMP_SENSOR_COUNT];

extern uint8_t driver_temp_roms_found;

void driver_temp_read(void);
void driver_temp_init(void);
