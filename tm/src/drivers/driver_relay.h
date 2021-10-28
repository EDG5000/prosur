
/*
 * driver_relay.h
 *
 * Created: 2020-10-23 9:07:03 PM
 *  Author: Joel
 * 
 * init() will 
 * set(bool bal) will
 */ 

#pragma once

#include "stdbool.h"

// Set correct pin configuration and set pin LOW.
void driver_relay_init(void);

// Set pin LOW or HIGH
void driver_relay_set(bool val);

bool driver_relay_get(void);