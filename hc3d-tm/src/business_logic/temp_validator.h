/*
 * temp_validator.h
 *
 * Created: 2020-10-23 10:41:40 PM
 *  Author: Joel
 */ 

#pragma once

#include "config.h"
#include "stdint.h"
#include "stdbool.h"

extern uint8_t temp_validator_sensor_last_valid_temperature[HC3D_CONFIG_TEMP_SENSOR_COUNT];
extern uint16_t temp_validator_sensor_last_update_time[HC3D_CONFIG_TEMP_SENSOR_COUNT];

void temp_validator_init(void);
void temp_validator_tick(void);
