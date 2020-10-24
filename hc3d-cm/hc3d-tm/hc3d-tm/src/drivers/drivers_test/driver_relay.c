
/*
 * driver_relay.c
 *
 * Created: 2020-10-23 9:12:04 PM
 *  Author: Joel
 
	Uses pin configuration set in config.h
 */ 

#include "drivers/driver_uart.h"
#include "stdbool.h"
#include "drivers/driver_relay.h"

#ifdef HC3D_TM_UNIT_TEST

void driver_relay_init(void){
	driver_uart_write("Driver uart INIT.");
}

void driver_relay_set(bool val){
	if(val){
		driver_uart_write("Driver uart relay set HIGH");
	}else{
		driver_uart_write("Driver uart relay set HIGH");
	}
}

#endif