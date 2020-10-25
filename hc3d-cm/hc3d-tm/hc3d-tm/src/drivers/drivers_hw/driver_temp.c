/*
 * driver_temp.c
 *
 * Created: 2020-10-24 4:50:08 PM
 *  Author: Joel
 */ 

#ifndef HC3D_TM_UNIT_TEST

#include "drivers/driver_temp.h"
#include "libraries/avr-ds80b20/ds18b20.h"
#include "stdint.h"

/*

	while(true){
		//Start conversion (without ROM matching)
		ds18b20convert( &PORTB, &DDRB, &PINB, ( 1 << 0 ), NULL );

		//Delay (sensor needs time to perform conversion)
		//_delay_ms( 1000 );
		driver_sleep(1000);

		//Read temperature (without ROM matching)
		ds18b20read( &PORTB, &DDRB, &PINB, ( 1 << 0 ), NULL, &temp );

		//Somehow use data stored in `temp` variable
	}

*/

void driver_temp_init(void){
	// TODO
}

void driver_temp_read(uint16_t* arr, uint8_t length){
	// TODO
}


#endif