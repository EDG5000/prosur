#include "drivers/driver_reg.h"

#if HC3D_USE_TEST_DRIVERS==0
volatile uint8_t* driver_reg_port(uint8_t* pin){
	switch(*pin / 8){
		case 0: return &PORTD;
		case 1: return &PORTB;
	}
	return 0;
}

volatile uint8_t* driver_reg_pin(uint8_t* pin){
		switch(*pin / 8){
			case 0: return &PIND;
			case 1: return &PINB;
		}
		return 0;
}

volatile uint8_t* driver_reg_ddr(uint8_t* pin){
	switch(*pin / 8){
		case 0: return &DDRD;
		case 1: return &DDRB;
	}
	return 0;
}

uint8_t config_mask(uint8_t* pin){
	return (1 << (*pin % 8));
}
#endif
