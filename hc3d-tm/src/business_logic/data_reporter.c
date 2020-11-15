/*
 * data_reporter.c
 *
 * Created: 2020-10-24 4:57:55 PM
 *  Author: Joel
 */ 

#include "config.h"
#include "business_logic/data_reporter.h"
#include "business_logic/data_reader.h"
#include "libraries/str/str.h"

void data_reporter_tick(void){
	// Create frame pointer pointing to the entire last sensor data frame, cast to char array
	for(int i = 0; i < HC3D_CONFIG_TEMP_SENSOR_COUNT; i++){
		uint8_t val = data_reader_last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][i];
		str("%i,", val);
	}
	str("\n");
	
}
