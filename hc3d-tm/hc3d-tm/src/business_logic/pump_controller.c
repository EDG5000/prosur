/*
 * pump_controller.c
 *
 * Created: 2020-10-23 10:40:36 PM
 *  Author: Joel
 */ 

#include "config.h"
#include "pump_controller.h"
#include "libraries/pi_control/pi_control.h"
struct PIControl pi_control_state;
#include "business_logic/temp_validator.h"
uint16_t temp_validator_sensor_last_valid_temperature[HC3D_CONFIG_TEMP_SENSOR_COUNT];
#include "drivers/driver_pwm.h"
#include "drivers/driver_tach.h"

void pump_controller_init(void){
	pi_control_state.ki = HC3D_CONFIG_CONTROLLER_KI;
	pi_control_state.kp = HC3D_CONFIG_CONTROLLER_KP;
	pi_control_state.min = HC3D_CONFIG_CONTROLLER_MIN;
	pi_control_state.max = HC3D_CONFIG_CONTROLLER_MAX;
	pi_control_state.shift = HC3D_CONFIG_CONTROLLER_SHIFT;
}

void pump_controller_tick(void){
	// Find the temperature of the hottest stepper motor
	// Use the validated temperatures from temp_validator
	uint16_t highest_temp = 0;
	for(int sensor_index = 0; sensor_index < HC3D_CONFIG_TEMP_SENSOR_COUNT; sensor_index++){
		if(temp_validator_sensor_last_valid_temperature[sensor_index] > highest_temp){
			highest_temp = temp_validator_sensor_last_valid_temperature[sensor_index];
		}
	}
	
	// Calculate error based on the highest measured temperature and the target temperature
	int error = highest_temp - HC3D_CONFIG_CONTROLLER_TEMP_SETPOINT; // TODO check if it needs to be inverted
	
	// Obtain pump PWM control output from PI controller
	int control_output = pi_control(&pi_control_state, error);
	
	// Send control output to PWM driver
	driver_pwm_set_pwm(control_output);
}