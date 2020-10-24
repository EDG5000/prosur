/*
 * temp_watchdog.h
 *
 * Created: 2020-10-23 10:41:40 PM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"

void temp_watchdog_init(void);
void temp_watchdog_tick(uint16_t temps[]);