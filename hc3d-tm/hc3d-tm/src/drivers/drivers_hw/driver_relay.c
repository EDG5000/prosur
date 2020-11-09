
/*
 * driver_relay.c
 *
 * Created: 2020-10-23 9:12:04 PM
 *  Author: Joel
 
	Uses pin configuration set in config.h
 */ 

#include "config.h"
#if HC3D_TEST_MODE!=HC3D_TEST_MODE_SITL

#include "drivers/driver_relay.h" 

#include "config.h"
#include "avr/io.h"

uint8_t relay_pin = HC3D_CONFIG_PIN_RELAY;

void driver_relay_init(void){
	HC3D_SET_HIGH(config_ddr(&relay_pin), &relay_pin);  // Set relay pin to output
}

void driver_relay_set(bool val){
	if(val){
		HC3D_SET_HIGH(config_port(&relay_pin), &relay_pin);
	}else{
		HC3D_SET_LOW(config_port(&relay_pin), &relay_pin);
	}
}

#endif