
/*
 * temp_watchdog.h
 *
 * Created: 2020-11-10 6:41:29 AM
 *  Author: Joel
 
 Triggers failsafe when either:
	- Temp validator has not produced a new reading within the configured timeout
	- Temp validator has found invalid or unsafe values

 */ 

#pragma once

#include "stdbool.h"
#include "temp_watchdog.h"

void temp_watchdog_init(void);
// Return false when failsafe was triggered. Checks output fields of temp_validator
bool temp_watchdog_tick(void);