/*
	HC3D-TM
	Infinus I/O HC3D Temperature Management
*/

#include "util.h"

#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <stdint.h>

#include "avr/io.h"

#include "drivers/driver_uart.h"
#include "drivers/driver_sleep.h"
#include "drivers/driver_clock.h"
#include "drivers/driver_system.h"

/*
	R 25 10K0 3950K
	K 数 量
	500
*/
#define SENSOR_COUNT 					8
#define INTERVAL 						1000				// Main loop is timed to run at 1Hz
#define SAMPLE_COUNT 					128 				// Must be within (2^32)÷(2^16)=65536. 128 samples will take exactly 1ms
#define DEFAULT_NUM_SAMPLES  			10
#define DEFAULT_BCOEF 					3950
#define DEFAULT_NOMINAL_RES 			10000
#define TEMPERATURENOMINAL 				25 					// Temperature for nominal resistance (almost always 25 C)
#define ADC_RESOLUTION 					1023
#define VERBOSE_SENSOR_ENABLED 			1
#define ANALOG_PIN 						0					// Analog pin where the thermistor is connected
#define NOMINAL_RES 					DEFAULT_NOMINAL_RES	// Nominal resistance at 25 degrees Celsius
#define B_COEF 							3950				// Beta coefficient of the thermistor
#define SERIAL_RES 						DEFAULT_NOMINAL_RES // Value of the serial resistor

// Stores output before printing as JSON
uint16_t temperatures[SENSOR_COUNT]; // Hundreds of degrees celcius

int main (void){
	driver_uart_init();
	driver_clock_init();

	uint16_t time_tick_start = 0;

	// ADC init; AREF = AVcc
	ADMUX = (1<<REFS0);
	// ADC Enable and prescaler of 128; 16000000Hz (MCU speed)/128 = 125000Hz (Safe ADC speed - ADC must be between 50-200Khz)
	ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);

	// Measure each sensor; dump all temperatures to JSON array at 1Hz
	while(true){
		time_tick_start = driver_clock_time();
		for(int sensor_index = 0; sensor_index < SENSOR_COUNT; sensor_index++){
			uint32_t adc_value = 0;
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
				adc_value += ADC;
			}
			// Divide to get average
			adc_value /= SAMPLE_COUNT;

			// Convert the value to resistance
			float resistance = adc_value; // Init as float
			resistance = ADC_RESOLUTION / resistance - 1; // Voltage
			resistance *= SERIAL_RES; // Resistance

			// Convert resistance to temperature
			float steinhart;
			steinhart = resistance / NOMINAL_RES;     				// (R/Ro)
			steinhart = log(steinhart);                  		// ln(R/Ro)
			steinhart /= B_COEF;                   				// 1/B * ln(R/Ro)
			steinhart += 1.0 / (TEMPERATURENOMINAL + 273.15); 	// + (1/To)
			steinhart = 1.0 / steinhart;                 		// Invert
			steinhart -= 273.15;                         		// convert to C

			uint16_t temperature_hundreds_celcius = (int) (steinhart * 100);

			// Store temperature in hundreds of degrees celcius
			temperatures[sensor_index] = temperature_hundreds_celcius;
		}

		// Report to serial
		printf("[%u, %u, %u, %u, %u, %u, %u, %u, %u]\n",
				SENSOR_COUNT,
				temperatures[0],
				temperatures[1],
				temperatures[2],
				temperatures[3],
				temperatures[4],
				temperatures[5],
				temperatures[6],
				temperatures[7]
		);

		uint16_t time_taken = util_time_offset(time_tick_start, driver_clock_time());
		driver_sleep(INTERVAL - time_taken);
	}

	driver_system_halt();
	return 0;
}
