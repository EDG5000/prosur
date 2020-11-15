/*
 * driver_temp.h
 *
 * Created: 2020-10-23 11:14:40 PM
 *  Author: Joel
 
	Steals driver_pwm last PWM setpoint to simulate changes in temperature sensors using a "model"
 */ 

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1

#include "drivers/driver_temp.h"
#include "config.h"
#include "stdint.h"
#include "string.h"
#include "stdbool.h"
#include "drivers/driver_pwm.h"

#include "testing/temperature_dataset.h"


int16_t previous_value[HC3D_CONFIG_TEMP_SENSOR_COUNT];

// Wraps around at HC3D_TEMPERATURE_DATASET_SIZE
uint8_t test_data_frame = 0;

// Generate fake data. Use the config value to determine the amount of temperature sensors present.
void driver_temp_read(int16_t* arr){
	if(test_data_frame == HC3D_TEMPERATURE_DATASET_SIZE-1){
		// Wrap around frame counter
		test_data_frame = 0;
	}
	
	if(temperature_dataset[test_data_frame] == 0){
		// No data provided by test dataset, run the model
		for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
			// Determine wether fake heater should be on
			uint8_t heater_on = ((test_data_frame > 0 && test_data_frame < 20) || test_data_frame > 29) ? 1 : 0;
			double last_pump_setpoint = last_percentage; // Steal from driver_pwm
			last_pump_setpoint -= 50;
			last_pump_setpoint /= 20; // +-2.5
			// Apply model
			previous_value[sensor_index] += (heater_on * 1) - ((uint16_t) last_pump_setpoint);
		}

	}else{
		// Copy data from dataset table into supplied array
		memcpy(arr, temperature_dataset[test_data_frame], HC3D_CONFIG_TEMP_SENSOR_COUNT);
	}


	test_data_frame++;
}

#endif