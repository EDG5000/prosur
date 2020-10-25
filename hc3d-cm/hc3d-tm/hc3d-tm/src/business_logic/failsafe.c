/*
 * failsafe.c
 *
 * Created: 2020-10-24 4:24:46 PM
 *  Author: Joel
 */ 

#include "failsafe.h"
#include "drivers/driver_relay.h"
#include "drivers/driver_uart.h"

void failsafe_trigger(void){
	driver_relay_set(false);
	driver_uart_write("Failsafe activated.");
}