
/*
 * driver_relay.c
 *
 * Created: 2020-10-23 9:12:04 PM
 *  Author: Joel
 
	Uses pin configuration set in config.h
 */ 

#include "config.h"
#if HC3D_SITL_MODE==1

#include "libraries/str/str.h"
#include "stdbool.h"
#include "drivers/driver_relay.h"

void driver_relay_init(void){
	str("Driver relay INIT.");
}

void driver_relay_set(bool val){
	;
}

#endif