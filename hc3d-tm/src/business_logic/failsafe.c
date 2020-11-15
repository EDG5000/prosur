/*
 * failsafe.c
 *
 * Created: 2020-10-24 4:24:46 PM
 *  Author: Joel
 */ 

#include "failsafe.h"
#include "stdio.h"
#include "drivers/driver_relay.h"
#include "drivers/driver_uart.h"

void failsafe_trigger(void){
	driver_relay_set(false);
	printf("Failsafe activated.");
	while(1); // Stop further code excecution. Hardware devices stay as they are. (PWM, timers, clock, IO-out)
}