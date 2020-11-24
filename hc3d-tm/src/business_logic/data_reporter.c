/*
 * data_reporter.c
 *
 * Created: 2020-10-24 4:57:55 PM
 *  Author: Joel
 */ 

#include "config.h"
#include "business_logic/data_reporter.h"
#include "business_logic/data_reader.h"
#include "business_logic/temp_validator.h"
#include "business_logic/pump_controller.h"
#include "libraries/pi_control/pi_control.h"
#include "libraries/str/str.h"
#include "drivers/driver_tach.h"
#include "drivers/driver_pwm.h"
#include "util.h"

uint16_t data_reporter_frame = 0;

void data_reporter_tick(uint16_t time){
	str("[%u] (%u)", time, data_reporter_frame);

	// Print raw temperatures
	for(uint8_t sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		fip raw_temp;
		util_fip(data_reader_last_temperatures[HC3D_CONFIG_TEMP_BUF_SIZE-1][sensor_index], &raw_temp);
		str(" rt%u:%u.%u", sensor_index, raw_temp.left, raw_temp.right);
	}

    // Print valid temperatures and update times
    for(uint8_t sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
    	fip valid_temp;
    	util_fip(temp_validator_sensor_last_valid_temperature[sensor_index], &valid_temp);
    	uint16_t update_time = temp_validator_sensor_last_update_time[sensor_index];
        str(" vt%u:%u.%u ut%u:%u", sensor_index, valid_temp.left, valid_temp.right, sensor_index, update_time);
    }

    // Print PI controller state, pump controller setpoint, tach reading
    uint16_t driver_pwm_val = (uint16_t) driver_pwm_value;
    uint16_t pump_i = (uint16_t) pump_controller_state.i;
    uint16_t driver_tach_val = driver_tach_get();
    str(" pwm:%u pci:%u tac:%u", driver_pwm_val, pump_i, driver_tach_val);

    str("\n");
    data_reporter_frame++;
}