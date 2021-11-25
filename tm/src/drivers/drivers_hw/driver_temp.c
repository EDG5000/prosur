/*
	driver_temp

	Writes to supplied array upon calling of read function
	Expected to be called at around 1Hz.
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

// Arduino digital pin 3. AVR port D, pin 3.
#define PORT PORTD
#define DDR DDRD
#define PIN PIND
#define PINNO 3

uint8_t driver_temp_roms_found;
uint8_t driver_temp_roms[HC3D_MAX_TEMP_SENSORS][DRIVER_TEMP_ROM_SIZE];
uint16_t driver_temp_last_readings[HC3D_MAX_TEMP_SENSORS];

uint8_t error_status = DS18B20_ERROR_OTHER;

void process_raw_reading(int sensor_index, int16_t raw_reading_p){
	uint16_t value = raw_reading_p < 0 ? 0 : raw_reading_p;
	driver_temp_last_readings[sensor_index] = value;
}

// Try to read into driver_temp_roms, populate first driver_temp_roms_found values
// Abort if any failure occurs. bus will be rescanned on next cycle
void driver_temp_read(void){
	if(error_status != DS18B20_ERROR_OK){
		// Status invalid, scan bus.
		error_status = ds18b20search(&PORT, &DDR, &PIN, 1 << PINNO, &driver_temp_roms_found, (uint8_t*)driver_temp_roms, HC3D_MAX_TEMP_SENSORS * DRIVER_TEMP_ROM_SIZE);
	}

	// Conversion
	for(int i = 0; i < driver_temp_roms_found; i++){
		error_status = ds18b20convert(&PORTD, &DDRD, &PIND, 1 << PINNO, &driver_temp_roms[i*DRIVER_TEMP_ROM_SIZE]);
		if(error_status != DS18B20_ERROR_OK){
			// Abort, rescan bus next cycle
			return;
		}
	}

	// Read
	for(int i = 0; i < driver_temp_roms_found; i++){
		int16_t raw_reading;
		error_status = ds18b20read(&PORTD, &DDRD, &PIND, 1 << PINNO, &driver_temp_roms[i*DRIVER_TEMP_ROM_SIZE], &raw_reading);
		if(error_status != DS18B20_ERROR_OK){
			// Abort, rescan bus next cycle
			return;
		}
		process_raw_reading(i, raw_reading);
	}
}

#endif
