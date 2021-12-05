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
#include "stdlib.h"

uint16_t data_reporter_frame = 0;

const int ROM_STRING_SIZE = 3*8+1;
//char rom_string[ROM_STRING_SIZE];

void data_reporter_tick(uint16_t time){
	str("{");

	// Print temperatures
	/*for(uint8_t sensor_index = 0; sensor_index < driver_temp_roms_found; sensor_index++){
		// Write
		for(uint8_t rom_byte_index = 0; rom_byte_index < DRIVER_TEMP_ROM_SIZE; rom_byte_index++){
			utoa(driver_temp_roms[sensor_index][rom_byte_index], rom_string, 10);
		}
		rom_string[ROM_STRING_SIZE-1] = '\0';



		fip raw_temp;
		util_fip(driver_temp_last_readings[sensor_index], &raw_temp);
		str("%u:%u.%u", sensor_index, raw_temp.left, raw_temp.right);

		if(sensor_index != driver_temp_roms_found-1){
			// No separator at the end
			str("\t");
		}
	}
	*/

    str("}\n");
}
