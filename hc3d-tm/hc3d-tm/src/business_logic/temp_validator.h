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

// Public enum
// Store safety state per sensor
// Primary output of temp_validator
typedef enum{
	INVALID,
	SAFE,
	UNSAFE,
	INITIAL
} safety_state_t;
extern safety_state_t sensor_safety_state[HC3D_CONFIG_TEMP_SENSOR_COUNT];

extern uint16_t temp_validator_sensor_last_valid_temperature[HC3D_CONFIG_TEMP_SENSOR_COUNT];
extern uint32_t temp_validator_sensor_last_update_time[HC3D_CONFIG_TEMP_SENSOR_COUNT];

void temp_validator_init(void);
void temp_validator_tick(void);