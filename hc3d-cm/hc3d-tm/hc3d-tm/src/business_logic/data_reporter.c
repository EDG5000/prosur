/*
 * data_reporter.c
 *
 * Created: 2020-10-24 4:57:55 PM
 *  Author: Joel
 */ 

#include "config.h"
#include "stdint.h"
#include "drivers/driver_uart.h"
#include "business_logic/data_reporter.h"
#include "business_logic/data_reader.h"
extern uint16_t last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE][HC3D_CONFIG_TEMP_SENSOR_COUNT];

void data_reporter_tick(void){
	// Create frame pointer pointing to the entire last sensor data frame, cast to char array
	char *frame = (char*) last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1];
	driver_uart_write(frame);
	driver_uart_write("\n");
}