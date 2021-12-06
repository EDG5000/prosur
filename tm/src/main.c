/*
	HC3D-TM
	Infinus I/O HC3D Temperature Management
*/

#include "util.h"

#include "stdbool.h"
#include "stdlib.h"
#include "stdio.h"

#include "avr/io.h"

#include "drivers/driver_uart.h"
#include "drivers/driver_sleep.h"
#include "drivers/driver_clock.h"
#include "drivers/driver_system.h"

#define SENSOR_COUNT 8
#define INTERVAL 1000		// Main loop is timed to run at 1Hz
#define SAMPLE_COUNT 128 // Must be within (2^32)÷(2^16)=65536. 128 samples will take exactly 1ms

uint32_t adc_value[SENSOR_COUNT];

int main (void){
	driver_uart_init();

	// Init drivers
	driver_clock_init();
	uint16_t time_tick_start = 0;

	// ADC init
	// AREF = AVcc
	ADMUX = (1<<REFS0);
	// ADC Enable and prescaler of 128
	// 16000000Hz (MCU speed)/128 = 125000Hz (Safe ADC speed - ADC must be between 50-200Khz)
	ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);

	while(true){
		time_tick_start = driver_clock_time();
		// Traverse sensors

		for(int sensor_index = 0; sensor_index < SENSOR_COUNT; sensor_index++){
			adc_value[sensor_index] = 0;
			// Collect samples
			for(int sample_index = 0; sample_index < SAMPLE_COUNT; sample_index++){
				// select the corresponding channel 0~7
				// ANDing with ’7′ will always keep the value
				// of ‘ch’ between 0 and 7
				sensor_index &= 0b00000111;  // AND operation with 7
				ADMUX = (ADMUX & 0xF8)|sensor_index; // clears the bottom 3 bits before ORing

				// start single convertion
				// write ’1′ to ADSC
				ADCSRA |= (1<<ADSC);

				// wait for conversion to complete
				// ADSC becomes ’0′ again
				// till then, run loop continuously
				// Read 'ADC' after this
				while(ADCSRA & (1<<ADSC));

				// Add to sum
				adc_value[sensor_index] += ADC;
			}
			// Set to average value
			adc_value[sensor_index] /= SAMPLE_COUNT;
		}

		// Report to serial
		printf("[%lu, %lu, %lu, %lu, %lu, %lu, %lu, %lu]\n",
				adc_value[0],
				adc_value[1],
				adc_value[2],
				adc_value[3],
				adc_value[4],
				adc_value[5],
				adc_value[6],
				adc_value[7]
		);

		uint16_t time_taken = util_time_offset(time_tick_start, driver_clock_time());
		driver_sleep(INTERVAL - time_taken);
	}

	driver_system_halt();
	return 0;
}
