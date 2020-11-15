/*
 * driver_temp.c
 *
 * Created: 2020-10-24 4:50:08 PM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==0

#include "drivers/driver_temp.h"
#include "drivers/driver_sleep.h"

#include "libraries/avr-ds80b20/ds18b20.h"
#include "stdint.h"
#include "stdlib.h"
#include "avr/io.h"

uint8_t pins[] = HC3D_TEMP_PINS;

// For array length HC3D_TEMP_SENSOR_SOUND is used
void driver_temp_read(int16_t* return_arr){
	for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
		// Start conversion (without ROM matching)
		if(ds18b20convert(driver_reg_port(&pins[i]), driver_reg_ddr(&pins[i]), driver_reg_pin(&pins[i]), config_mask(&pins[i]), NULL) != 1){
			// TODO, errc non-zero
		}
	}
	
	// Delay (sensor needs time to perform conversion)
	// Cannot be too close to 1000, because the main loop tries to keep 1hz pace
	driver_sleep(800);
	
	for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
		// Read temperature (without ROM matching)
		if(ds18b20read(&PORTB, &DDRB, &PINB, (1 << 0), NULL, &return_arr[i]) != 0){
			// TODO, errc non-zero
		}
	}
}

#endif