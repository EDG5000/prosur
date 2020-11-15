
/*
 * driver_uart.c
 *
 * Created: 2020-10-23 10:06:01 PM
 *  Author: Joel
 */

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "drivers/driver_uart.h"
#include "stdio.h"

// NOP, special breakpoint logs to debug console and resumes excecution
void driver_uart_init(void){
	setvbuf(stdout, NULL, _IONBF, 0); // changes stdout to unbuffered (_IONBF) mode; no fflush needed
}


#endif
