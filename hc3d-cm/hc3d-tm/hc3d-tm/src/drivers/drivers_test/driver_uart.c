
/*
 * driver_uart.c
 *
 * Created: 2020-10-23 10:06:01 PM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "drivers/driver_uart.h"

// NOP, special breakpoint logs to debug console and resumes excecution
void driver_uart_init(void){
	// NOP
}

// NOP, special breakpoint logs parameter to debug console and resumes excecution
void driver_uart_write(char* val){
	// NOP (inspecting this data would be good, breakpoints could be used)
}

#endif