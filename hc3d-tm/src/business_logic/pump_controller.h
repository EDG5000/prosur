/*
 * pump_controller.h
 *
 * Created: 2020-10-23 10:40:20 PM
 *  Author: Joel
 */ 

#pragma once

extern struct PIControl pump_controller_state;

void pump_controller_init(void);
void pump_controller_tick(void);
