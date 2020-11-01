/*
 * temp_watchdog.h
 *
 * Created: 2020-10-23 10:41:40 PM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"
#include "stdbool.h"

void temp_watchdog_init(void);
bool temp_watchdog_tick(void);