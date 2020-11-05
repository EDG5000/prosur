/*
 * driver_temp.c
 *
 * Created: 2020-10-24 4:50:08 PM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==0

#include "drivers/driver_temp.h"
#include "libraries/avr-ds80b20/ds18b20.h"
#include "stdint.h"
#include "avr/io.h"

void driver_temp_init(void){
	// TODO
	
}

// For array length HC3D_TEMP_SENSOR_SOUND is used
void driver_temp_read(uint16_t* arr){
	uint32_t temp;
	
	/*
	// TODO
	for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
		arr[i] = i;
		// Start conversion (without ROM matching)
		ds18b20convert( &PORTB, &DDRB, &PINB, ( 1 << 0 ), NULL );
	}
	
	// Delay (sensor needs time to perform conversion)
	driver_sleep(1000);
	
	for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
		// Read temperature (without ROM matching)
		ds18b20read( &PORTB, &DDRB, &PINB, ( 1 << 0 ), NULL, &temp );
	}
	*/
			

}


#endif