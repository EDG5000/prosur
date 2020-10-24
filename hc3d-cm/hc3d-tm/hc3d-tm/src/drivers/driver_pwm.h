
/*
 * driver_pwm.h
 *
 * Created: 2020-10-23 10:32:34 PM
 *  Author: Joel
 */ 

#pragma once

void driver_pwm_init(void);
void driver_pwm_set_pwm(uint8_t percentage);
uint8_t driver_pwm_get_pwm();