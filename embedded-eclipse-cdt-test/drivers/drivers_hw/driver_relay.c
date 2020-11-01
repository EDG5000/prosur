
/*
 * driver_relay.c
 *
 * Created: 2020-10-23 9:12:04 PM
 *  Author: Joel
 
	Uses pin configuration set in config.h
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==0

#include "drivers/driver_relay.h" 

#include "config.h"
#include "avr/io.h"

// B0 is selected as relay pin
#define PORT PORTB
#define DDR DDRB
#define PIN 0

void driver_relay_init(void){
	DDR |= 1 << PIN; // Set B0 to output
}

void driver_relay_set(bool val){
	if(val){
		PORT |= 1 << PIN;
	}else{
		PORT &= ~(1 << PIN);
	}
}

#endif