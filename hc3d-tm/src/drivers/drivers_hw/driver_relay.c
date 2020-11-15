/*
	driver_relay

	Set digital pin high or low
	Uses pinout as described in main.c comment.
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==0

#include "drivers/driver_relay.h"
#include "libraries/str/str.h"
#include "config.h"
#include "avr/io.h"

#define B0 0

void driver_relay_init(void){
	HC3D_SBI(DDRB, B0);
}

void driver_relay_set(bool val){
	if(val){
		HC3D_SBI(PORTB, B0);
	}else{
		HC3D_CBI(PORTB, B0);
	}
}

#endif
