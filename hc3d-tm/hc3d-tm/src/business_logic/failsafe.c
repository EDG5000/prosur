/*
 * failsafe.c
 *
 * Created: 2020-10-24 4:24:46 PM
 *  Author: Joel
 */ 

#include "failsafe.h"
#include "stdio.h"
#include "drivers/driver_relay.h"

void failsafe_trigger(void){
	driver_relay_set(false);
	printf("Failsafe activated.");
}