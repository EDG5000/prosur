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

// Returns true when all sensors are settled, false otherwise
// Reads out all sensors and update the moving buffer found 
bool data_reader_tick(void);