/*
 * driver_uart.c
 *
 * Created: 2020-10-24 4:51:14 PM
 *  Author: Joel
 */ 

#include "config.h"
#if HC3D_SITL_MODE==0

#include "drivers/driver_uart.h"
#include "avr/io.h"
#include "avr/sfr_defs.h"
#include "libraries/str/str.h"
#include "stdio.h"

#include "drivers/driver_sleep.h"

#define BAUD_RATE      9600
#define BAUD_PRESCALE (F_CPU/16/BAUD_RATE-1)

int send_byte(char byte, FILE *stream);
int get_byte(FILE *stream);

FILE uart_output = FDEV_SETUP_STREAM(send_byte, NULL, _FDEV_SETUP_WRITE);
FILE uart_input = FDEV_SETUP_STREAM(NULL, get_byte, _FDEV_SETUP_READ);

void driver_uart_init(void) {
	UBRR0H = (BAUD_PRESCALE >> 8);
	UBRR0L = BAUD_PRESCALE;
	UCSR0B = (1<<RXEN0) | (1<<TXEN0);
	UCSR0C = (1<<UCSZ01) | (1<<UCSZ00);
	stdout = &uart_output;
}

int send_byte(char byte, FILE *stream) {
	loop_until_bit_is_set(UCSR0A, UDRE0);
	UDR0 = byte;
	return 0;
}

int get_byte(FILE *stream) {
	loop_until_bit_is_set(UCSR0A, RXC0);
	return (uint16_t) UDR0;
}

#endif
