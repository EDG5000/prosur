
/*
 * driver_relay.c
 *
 * Created: 2020-10-23 9:12:04 PM
 *  Author: Joel
 
	Uses pin configuration set in config.h
 */ 

#define DRIVER_RELAY_PIN 

#ifndef UNIT_TEST

void driver_relay_init(){
	ioport_init();
	ioport_set_pin_dir(HC3D_TM_CONFIG_PIN_RELAY, IOPORT_DIR_OUTPUT);
	ioport_set_pin_level(HC3D_TM_CONFIG_PIN_RELAY, false);
	//ioport_set_pin_mode(HC3D_TM_CONFIG_PIN_RELAY, IOPORT_MODE_); ???
}

void driver_relay_set(bool val){
	ioport_set_pin_level(HC3D_TM_CONFIG_PIN_RELAY, val);
}

#endif