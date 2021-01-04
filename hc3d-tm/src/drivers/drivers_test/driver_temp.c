/*
	driver_temp
	Steals driver_pwm last PWM setpoint to simulate changes in temperature sensors using a "model"
 */ 

#include "config.h"
#if HC3D_SITL_MODE==1

#include "drivers/driver_temp.h"
#include "config.h"
#include "stdint.h"
#include "string.h"
#include "stdbool.h"
#include "drivers/driver_pwm.h"
#include "business_logic/data_reader.h"
#include "testing/temperature_dataset.h"

uint8_t previous_value[HC3D_CONFIG_TEMP_SENSOR_COUNT];

uint16_t driver_temp_last_readings[HC3D_CONFIG_TEMP_SENSOR_COUNT];

// Generate fake data. Use the config value to determine the amount of temperature sensors present.
void driver_temp_read(void){
	memcpy(driver_temp_last_readings, temperature_dataset[data_reader_frame], HC3D_CONFIG_TEMP_SENSOR_COUNT);
}

#endif
