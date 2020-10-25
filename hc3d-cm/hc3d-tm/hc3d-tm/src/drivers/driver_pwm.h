
/*
 * driver_pwm.h
 *
 * Created: 2020-10-23 10:32:34 PM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"

void driver_pwm_init(void);
void driver_pwm_set_pwm(uint8_t percentage);
