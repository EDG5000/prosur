
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
#include "ioport.h"
#include "config.h"

void driver_relay_init(void){
	ioport_init();
	
	// TODO; use registers directly for consistency?
	//ioport_set_pin_dir(HC3D_CONFIG_PIN_RELAY, IOPORT_DIR_OUTPUT);
	//ioport_set_pin_level(HC3D_CONFIG_PIN_RELAY, false);
	//ioport_set_pin_mode(HC3D_CONFIG_PIN_RELAY, IOPORT_MODE_); ???
}

void driver_relay_set(bool val){
	// TODO
	//ioport_set_pin_level(HC3D_CONFIG_PIN_RELAY, val);
}

#endif