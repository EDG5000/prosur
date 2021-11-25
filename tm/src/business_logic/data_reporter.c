/*
 * data_reporter.c
 *
 * Created: 2020-10-24 4:57:55 PM
 *  Author: Joel
 */ 

#include "config.h"
#include "business_logic/data_reporter.h"
#include "libraries/str/str.h"
#include "drivers/driver_temp.h"
#include "util.h"
#include "util/crc16.h"

uint16_t data_reporter_frame = 0;

void data_reporter_tick(uint16_t time){
	str("{");

	// Print temperatures
	for(uint8_t sensor_index = 0; sensor_index < driver_temp_roms_found; sensor_index++){

		// First print the rom
		fip raw_temp;
		util_fip(driver_temp_last_readings[sensor_index], &raw_temp);
		str("\trt%u:%u.%u", sensor_index, raw_temp.left, raw_temp.right);
	}

    str("}\n");
}
