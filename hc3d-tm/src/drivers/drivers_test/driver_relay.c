
/*
 * driver_relay.c
 *
 * Created: 2020-10-23 9:12:04 PM
 *  Author: Joel
 
	Uses pin configuration set in config.h
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "stdio.h"
#include "stdbool.h"
#include "drivers/driver_relay.h"

void driver_relay_init(void){
	printf("Driver relay INIT.");
}

void driver_relay_set(bool val){
	;
}

#endif