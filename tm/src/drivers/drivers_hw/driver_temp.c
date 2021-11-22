/*
	driver_temp

	Writes to supplied array upon calling of read function
	Expected to be called at around 1Hz
	Uses arbitrary waiting period to give sensors time to process calculation
	Uses pinout as described in main.c


	AVR PIN		D3
	BOARD PIN	03

 */ 

#include "config.h"
#if HC3D_SITL_MODE==0

#include <stdint.h>
#include <stdlib.h>

#include "avr/io.h"
#include "libraries/str/str.h"
#include "ds18b20/ds18b20.h"
#include "ds18b20/romsearch.h"

#include "drivers/driver_temp.h"
#include "drivers/driver_sleep.h"
#include "util.h"

uint16_t driver_temp_last_readings[HC3D_CONFIG_TEMP_SENSOR_COUNT];

#define ROM_SIZE 	8

// Arduino digital pin 3. AVR port D, pin 3.
#define PORT 		PORTD
#define DDR 		DDRD
#define PIN 		PIND
#define PINNO		3

uint64_t roms[HC3D_CONFIG_TEMP_SENSOR_COUNT * ROM_SIZE];
uint8_t driver_temp_roms_found;

void driver_temp_init(){
	uint8_t result = ds18b20search(&PORT, &DDR, &PIN, 1 << PINNO, &driver_temp_roms_found, (uint8_t*)roms, HC3D_CONFIG_TEMP_SENSOR_COUNT * ROM_SIZE);
	if(result != DS18B20_ERROR_OK){
		str("Error detecting temperature sensors. Error code: %u\n", result);
		while(1){}
	}
}

void process_raw_reading(int sensor_index, int16_t raw_reading_p){
	uint16_t value = raw_reading_p < 0 ? 0 : raw_reading_p;
	driver_temp_last_readings[sensor_index] = value;
}

void driver_temp_read(void){
	// Conversion
	for(int i = 0; i < driver_temp_roms_found; i++){
		ds18b20convert(&PORTD, &DDRD, &PIND, 1 << PINNO, &roms[i*ROM_SIZE]);
	}

	// Read
	for(int i = 0; i < driver_temp_roms_found; i++){
		int16_t raw_reading;
		ds18b20read(&PORTD, &DDRD, &PIND, 1 << PINNO, &roms[i*ROM_SIZE], &raw_reading);
		process_raw_reading(i, raw_reading);
	}
}

#endif
