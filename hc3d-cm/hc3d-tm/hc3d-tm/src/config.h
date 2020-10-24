
/*
 * config.h
 *
 * Created: 2020-10-23 9:21:50 PM
 *  Author: Joel
 */ 

#define HC3D_TM_CONFIG_PIN_RELAY 2			// Pin for failsafe output pin. Relay is LOW when failsafe is active.
#define HC3D_TM_CONFIG_PIN_TEMP_START 2		// Pin of temperature sensor 0. Other sensors will be assigned the pins following it
#define HC3D_TM_CONFIG_PIN_TEMP_COUNT 8		// Amount of temperature sensors
#define HC3D_TM_CONFIG_TEMP_BUF_SIZE 10		// Keep last N temperature readings in buffer. Entire range for confirming validity of readings (filtering out noise)