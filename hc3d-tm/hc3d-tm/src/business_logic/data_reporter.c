/*
 * data_reporter.c
 *
 * Created: 2020-10-24 4:57:55 PM
 *  Author: Joel
 */ 

#include "stdio.h"
#include "config.h"
#include "stdio.h"
#include "business_logic/data_reporter.h"
#include "business_logic/data_reader.h"
extern uint16_t last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE][HC3D_CONFIG_TEMP_SENSOR_COUNT];

void data_reporter_tick(void){
	// Create frame pointer pointing to the entire last sensor data frame, cast to char array
	for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
		int16_t val = last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][i];
		printf("%i,", val);
	}
	printf("\n");
	
}