
/*
 * driver_relay.c
 *
 * Created: 2020-10-23 9:12:04 PM
 *  Author: Joel
 
	Uses pin configuration set in config.h
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==0

#include "driver_relay.h" 
#include "driver_reg.h"

#include "config.h"
#include "avr/io.h"

uint8_t relay_pin = HC3D_driver_reg_pin_RELAY;

void driver_relay_init(void){
	HC3D_SET_HIGH(driver_reg_ddr(&relay_pin), &relay_pin);  // Set relay pin to output
}

void driver_relay_set(bool val){
	if(val){
		HC3D_SET_HIGH(driver_reg_port(&relay_pin), &relay_pin);
	}else{
		HC3D_SET_LOW(driver_reg_port(&relay_pin), &relay_pin);
	}
}

#endif
