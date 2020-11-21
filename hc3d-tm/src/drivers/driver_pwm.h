
/*
 * driver_pwm.h
 *
 * Created: 2020-10-23 10:32:34 PM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"

extern uint8_t driver_pwm_value;

void driver_pwm_init(void);
void driver_pwm_set(uint8_t percentage);
