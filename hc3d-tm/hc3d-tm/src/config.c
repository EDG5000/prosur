
/*
 * config.c
 *
 * Created: 2020-11-07 8:44:48 PM
 *  Author: Joel
 */ 

#include "config.h"
#include "avr/io.h"

volatile uint8_t* config_port(uint8_t* pin){
	switch(*pin / 8){
		case 0: return &PORTD;
		case 1: return &PORTB;
	}
	return 0;
}

volatile uint8_t* config_pin(uint8_t* pin){
		switch(*pin / 8){
			case 0: return &PIND;
			case 1: return &PINB;
		}
		return 0;
}

volatile uint8_t* config_ddr(uint8_t* pin){
	switch(*pin / 8){
		case 0: return &DDRD;
		case 1: return &DDRB;
	}
	return 0;	
}

uint8_t config_mask(uint8_t* pin){
	return (1 << (*pin % 8));
}