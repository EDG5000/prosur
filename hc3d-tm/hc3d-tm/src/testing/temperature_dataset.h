/*
 * temperature_dataset.c
 *
 * Created: 2020-10-24 6:58:59 AM
 *  Author: Joel
 
	When temperatures are 0, a simulated temperature is calculated by drivers_test/driver_temp.c
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

#define HC3D_TEMPERATURE_DATASET_SIZE 50

int16_t temperature_dataset[][HC3D_CONFIG_TEMP_SENSOR_COUNT] = {
	/* 00 */ {20, 20, 20, 20, 20, 20, 20, 20}, // driver_temp: fake heater on, temp ramping up
	/* 01 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 02 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 03 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 04 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 05 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 06 */ {00, 00, 00, 00, 00, 00, 00, 00}, 
	/* 07 */ {00, 00, 00, 00, 00, 00, 00, 00}, 
	/* 08 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 09 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 10 */ {00, 00, 00, 00, 00, 00, 00, 00}, // cooing becoming active gradually and reaching steady state
	/* 11 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 12 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 13 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 14 */ {00, 00, 00, 00, 00, 00, 00, 00}, 
	/* 15 */ {00, 00, 00, 00, 00, 00, 00, 00}, 
	/* 16 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 17 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 18 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 19 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 20 */ {00, 00, 00, 00, 00, 00, 00, 00}, // driver_temp: fake heater off; temp dropping and cooling dropping
	/* 21 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 22 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 23 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 24 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 25 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 26 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 27 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 28 */ {00, 00, 00, 00, 00, 00, 00, 00}, 
	/* 29 */ {00, 00, 00, 00, 00, 00, 00, 00}, // driver_temp: fake heater on
	/* 30 */ {126, 00, 00, 00, 00, 00, 00, 00}, // reading 0 exceeding valid limit abruptly
	/* 31 */ {60, 00, 00, 00, 00, 00, 00, 00}, // reading 0 back to normal
	/* 32 */ {0, 00, 00, 00, 00, 00, 00, 00},
	/* 33 */ {0, 00, 00, 00, 00, 00, 00, 00},
	/* 34 */ {0, 00, 00, 00, 00, 00, 00, 00},
	/* 35 */ {0, 00, 00, 00, 00, 00, 00, 00}, // reading 0 exceeding valid limit abruptly
	/* 36 */ {126, 00, 00, 00, 00, 00, 00, 00},
	/* 37 */ {126, 00, 00, 00, 00, 00, 00, 00},
	/* 38 */ {126, 00, 00, 00, 00, 00, 00, 00},
	/* 39 */ {126, 00, 00, 00, 00, 00, 00, 00},
	/* 40 */ {126, 00, 00, 00, 00, 00, 00, 00}, 
	/* 41 */ {126, 00, 00, 00, 00, 00, 00, 00},
	/* 42 */ {126, 00, 00, 00, 00, 00, 00, 00},
	/* 43 */ {126, 00, 00, 00, 00, 00, 00, 00},
	/* 44 */ {126, 00, 00, 00, 00, 00, 00, 00},
	/* 45 */ {126, 00, 00, 00, 00, 00, 00, 00}, // failsafe should trigger
	/* 46 */ {60, 00, 00, 00, 00, 00, 00, 00}, // back to normal
	/* 47 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 48 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 49 */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {61, 00, 00, 00, 00, 00, 00, 00}, // temperature ramping up due to cooling failure
	/* -- */ {62, 00, 00, 00, 00, 00, 00, 00},		
	/* -- */ {64, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {68, 00, 00, 00, 00, 00, 00, 00},		
	/* -- */ {72, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {76, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {80, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {84, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {88, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {92, 00, 00, 00, 00, 00, 00, 00},	// failsafe should trigger due to overtemp	
	/* -- */ {96, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},		
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},		
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},		
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},		
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* -- */ {00, 00, 00, 00, 00, 00, 00, 00},
	/* 99 */ {00, 00, 00, 00, 00, 00, 00, 00},		
};