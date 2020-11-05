#include <avr/io.h>
#include <avr/sfr_defs.h>
#include <stdio.h>
#include "libraries/avr_printf/avr_printf.h"

#define BAUD_RATE      9600
#define BAUD_PRESCALE (F_CPU/16/BAUD_RATE-1)

void usart_send_byte(char byte, FILE *stream);
char usart_get_byte(FILE *stream);

FILE uart_output = FDEV_SETUP_STREAM(usart_send_byte, NULL, _FDEV_SETUP_WRITE);
FILE uart_input = FDEV_SETUP_STREAM(NULL, usart_get_byte, _FDEV_SETUP_READ);

void avr_printf_init(void) {
	UBRR0H = (BAUD_PRESCALE >> 8);
	UBRR0L = BAUD_PRESCALE;
	UCSR0B = (1<<RXEN0) | (1<<TXEN0);
	UCSR0C = (1<<UCSZ01) | (1<<UCSZ00);
	stdout = &uart_output;
}

void usart_send_byte(char byte, FILE *stream) {
	if (byte == '\n') {
		usart_send_byte('\r',stream);
	}
	loop_until_bit_is_set(UCSR0A,UDRE0);
	UDR0 = byte;
}

char usart_get_byte(FILE *stream) {
	loop_until_bit_is_set(UCSR0A, RXC0);
	return UDR0;
}