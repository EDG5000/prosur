/*
 * temperature_dataset.c
 *
 * Created: 2020-10-24 6:58:59 AM
 *  Author: Joel
 
	When temperatures are 0, a simulated temperature is calculated by drivers_sitl/driver_temp.c
	Simulated values are based on driver_pwm setpoint, which is pump_control output which is based on temperature readings.
	When a temperature is specified, this temperature overrides the would-be calculated value
	
	Desired scripted scenario overview
	
	Event										Expected behaviour
	
						- Heating up sequence -
	
	Start at 20 deg C, all motors				Pump at off
	Chamber heater is turned on					-
	Motors start ramping up rapidly				Pump inactive
	Motors approach set temperature				Pump starts ramping up
	Motors reach temperature					Pump reaches peak control output
	Motors experience slight overshoot			Pump drops below peak
	Motor temperature stabilizes				Pump stabilizes
	Motors become active						-
	Motors exceed slightly below setpoint		Pump setpoint increases 
	Stable condition reached					Pump fluctuates around steady-state setpoint
	
					- Printer idle after operation
	Chamber at 70 deg C							Pump at steady state
	Motors + chamber heater turned off			Pump starts dropping setpoint
	Chamber drops below 60						Pump ramps to near-zero as motors drop below 60
	Chamber drops below 50						Pump completely off
	
				- A temperature channel gets out of valid range  -
				
	A reading exceeding valid lim. is received	No action yet no new valid reading produced
	10 such consecutive reachings received		Failsafe triggered, reason printed to UART
	
				- A temperature sensor ceases functioning  -
	
	Sensor leaves 3-120 deg C range				No action yet no new valid reading produced
	Sensor recovers								No action yet no new valid reading produced
	Sensor leaves 3-120 deg C range				No action yet no new valid reading produced
	Left 3-120 deg C range 10 consc. fr.		Failsafe triggered, reson printed to UART.
	
				- A temperature sensor reports a single erroneous value -
				
	Sensor reports sudden 						!!!!
	
 */ 

#pragma once

#include "config.h"
#define HC3D_TEMPERATURE_DATASET_SIZE 100

// Will  turn all values into their raw equivalents
void temperature_dataset_init();

extern uint16_t temperature_dataset[][HC3D_CONFIG_TEMP_SENSOR_COUNT];

