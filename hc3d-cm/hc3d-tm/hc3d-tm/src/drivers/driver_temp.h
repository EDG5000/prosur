/*
 * driver_temp.h
 *
 * Created: 2020-10-23 11:14:28 PM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"

void driver_temp_init(void);
uint16_t* driver_temp_read(uint16_t* arr, uint8_t length);

