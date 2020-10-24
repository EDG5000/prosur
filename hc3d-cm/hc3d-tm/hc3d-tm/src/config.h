
/*
 * config.h
 *
 * Created: 2020-10-23 9:21:50 PM
 *  Author: Joel
 */ 

#define HC3D_TM_CONFIG_PIN_RELAY			2		// Pin for failsafe output pin. Relay is LOW when failsafe is active.

// Temperature sensor setup
#define HC3D_TM_CONFIG_PIN_TEMP_START		2		// Pin of temperature sensor 0. Other sensors will be assigned the pins following it
#define HC3D_TM_CONFIG_TEMP_SENSOR_COUNT	8		// Amount of temperature sensors

// Naming of temperature sensors
#define HC3D_TM_TEMP_SENSOR_X				0		// Temp sensor index for X motor stepper
#define HC3D_TM_TEMP_SENSOR_Y				1		// Temp sensor index for Y motor stepper
#define HC3D_TM_TEMP_SENSOR_Z				2		// Temp sensor index for Z motor stepper
#define HC3D_TM_TEMP_SENSOR_E				3		// Temp sensor index for E motor stepper
#define HC3D_TM_TEMP_SENSOR_CHAMBER0		4		// Temp sensor index for chamber sensor 0
#define HC3D_TM_TEMP_SENSOR_CHAMBER1		5		// Temp sensor index for chamber sensor 1

// Safety-related limit of each sensor
#define HC3D_TM_TEMP_SENSOR_X_LIMIT			65		// Temp sensor safe limit for X motor stepper
#define HC3D_TM_TEMP_SENSOR_Y_LIMIT			65		// Temp sensor safe limit for Y motor stepper
#define HC3D_TM_TEMP_SENSOR_Z_LIMIT			65		// Temp sensor safe limit for Z motor stepper
#define HC3D_TM_TEMP_SENSOR_E_LIMIT			65		// Temp sensor safe limit for E motor stepper
#define HC3D_TM_TEMP_SENSOR_CHAMBER0_LIMIT	80		// Temp sensor safe limit for chamber sensor 0
#define HC3D_TM_TEMP_SENSOR_CHAMBER1_LIMIT	80		// Temp sensor safe limit for chamber sensor 1

// Temperature failsafe configuration
#define HC3D_TM_CONFIG_TEMP_BUF_SIZE		10		// Keep last N temperature readings in buffer. Entire range for confirming validity of readings (filtering out noise)
#define HC3D_TM_CONFIG_TEMP_VALID_MIN		3
#define HC3D_TM_CONFIG_TEMP_VALID_MAX		120