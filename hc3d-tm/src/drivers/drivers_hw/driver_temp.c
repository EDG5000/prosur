/*
	driver_temp

	Writes to supplied array upon calling of read function
	Expected to be called at around 1Hz
	Uses arbirtrary waiting period to give sensors time to process calculation
	Uses pinout as described in main.c

	SENSOR		00	01	02	03	04	05	06	07
	AVR PIN		D3  D4  D5  D6  D7  B3  B4  B5
	BOARD PIN	03  04  05  06  07  11  12  13



OLD-VS-NEW


OLD: 2-9
NEW: 3-7, 11-13

2: 11
8: 12
9: 3



 */ 

#include "config.h"
#if HC3D_SITL_MODE==0

#include "drivers/driver_temp.h"
#include "drivers/driver_sleep.h"

#include "libraries/avr-ds80b20/ds18b20.h"
#include "stdint.h"
#include "stdlib.h"
#include "avr/io.h"

uint16_t driver_temp_last_readings[HC3D_CONFIG_TEMP_SENSOR_COUNT];

// Reading is supposed to be 16x the value in celcius
// For now, round to whole celcius, treat any sub-zero temperature as 0
// Store in uint8_t

void process_raw_reading(uint8_t* sensor_index, int16_t* raw_reading_p){
	uint16_t value = *raw_reading_p < 0 ? 0 : *raw_reading_p;
	driver_temp_last_readings[*sensor_index] = value;
}

// For array length HC3D_TEMP_SENSOR_SOUND is used
void driver_temp_read(void){
	// Initiate conversion
	// D3-D7
	for(uint8_t i = 3; i < 7; i++){
		ds18b20convert(&PORTD, &DDRD, &PIND, 1 << i, NULL);
	}
	// B3-B5
	for(uint8_t i = 3; i < 5; i++){
		ds18b20convert(&PORTB, &DDRB, &PINB, 1 << i, NULL);
	}
	
	// Delay (sensor needs time to perform conversion)
	// Cannot be too close to 1000, because the main loop tries to keep 1hz pace
	driver_sleep(800);
	
	// Read values
	uint8_t sensor_index = 0;
	int16_t raw_reading;

	// D3-D7
	for(uint8_t i = 3; i < 7; i++){
		ds18b20read(&PORTD, &DDRD, &PIND, 1 << i, NULL, &raw_reading);
		process_raw_reading(&sensor_index, &raw_reading);
	}
	// B3-B5
	for(uint8_t i = 3; i < 5; i++){
		ds18b20read(&PORTB, &DDRB, &PINB, 1 << i, NULL, &raw_reading);
		process_raw_reading(&sensor_index, &raw_reading);
	}
}

#endif
