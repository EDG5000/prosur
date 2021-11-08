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

#include "drivers/driver_temp.h"
#include "drivers/driver_sleep.h"

#include <ds18b20/ds18b20.h>
#include "stdint.h"
#include "stdlib.h"
#include "libraries/str/str.h"
#include "avr/io.h"
#include <ds18b20/romsearch.h>
#include "util.h"

uint16_t driver_temp_last_readings[HC3D_CONFIG_TEMP_SENSOR_COUNT];

#define ROM_SIZE 8

uint64_t roms[HC3D_CONFIG_TEMP_SENSOR_COUNT * ROM_SIZE];
uint8_t roms_found;

void driver_temp_init(){
	uint8_t result = ds18b20search(&PORTD, &DDRD, &PIND, 1 << 3, &roms_found, (uint8_t*)roms, HC3D_CONFIG_TEMP_SENSOR_COUNT * ROM_SIZE);
	if(result != DS18B20_ERROR_OK){
		str("Error detecting temperature sensors. Error code: %u\n", result);
		while(1){}
	}

	// TODO by design all serial output should ideally be written by data_reporter for semantic reasons
	// Print CSV header
	for(int i = 0; i < roms_found; i++){
		char romString[21];
		uint64_to_str(roms[i], romString);
		str("\t");
		str(romString);
	}
}

void process_raw_reading(int sensor_index, int16_t raw_reading_p){
	uint16_t value = raw_reading_p < 0 ? 0 : raw_reading_p;
	driver_temp_last_readings[sensor_index] = value;
}

void driver_temp_read(void){
	// Conversion
	for(int i = 0; i < roms_found; i++){
		ds18b20convert(&PORTD, &DDRD, &PIND, 1 << 3, &roms[i*ROM_SIZE]);
	}

	// Read
	for(int i = 0; i < roms_found; i++){
		int16_t raw_reading;
		ds18b20read(&PORTD, &DDRD, &PIND, 1 << 3, &roms[i*ROM_SIZE], &raw_reading);
		process_raw_reading(i, raw_reading);
	}
}

#endif
