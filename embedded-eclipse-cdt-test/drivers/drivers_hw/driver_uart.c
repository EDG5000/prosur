/*
 * driver_uart.c
 *
 * Created: 2020-10-24 4:51:14 PM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==0

#include "drivers/driver_uart.h"
#include "asf.h"


void driver_uart_init(void){

}

void driver_uart_write(char* val){
	/*
	while(*val){
		// Wait until transmitter ready
		while(((UCSR0A & (1<<UDRE0))==0)){}
		// Now write the data to USART buffer
		char cur_char = &val++;
		UDR0=cur_char;
	}
	*/
}

#endif