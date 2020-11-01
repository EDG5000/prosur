
/*
 * config.h
 *
 * Created: 2020-10-23 9:21:50 PM
 *  Author: Joel
 */ 

/*
	PC6 - PCINT14, Reset [RESET]
	PD0 - PCINT16, RXD [PIN0]
	PD1 - PCINT17, TXD [PIN1]
	PD2 - PCINT18, INT0 [PIN2]
	PD3 - PCINT19, INT1, OC2B [PIN3]
	PD4 - PCINT20, XCK, T0 [PIN4]
	PB6 - PCINT6, XTAL1, TOSC1
	PB7 - PCINT7, XTAL2, TOSC2
	PD5 - PCINT21, OC0B, T1 [PIN5/PWM]
	PD6 - PCINT22, OC0A, AIN0 [PIN6/PWM]
	PD7 - PCINT23, AIN1 [PIN7]
	PB0 - PCINT0, CLKO, ICP1 [PIN8]
	PB1 - PCINT1, OC1A [PIN9/PWM]
	PB2 - PCINT2, OC1B, SS [PIN10/PWM]
	PB3 - PCINT3, OC2A, MOSI [PIN11/PWM]
	PB4 - PCINT4, MISO [PIN12]
	PB5 - PCINT5, SCK [PIN13] LED
	PC0 - PCINT8, ADC0 [ANALOG0]
	PC1 - PCINT9, ADC1 [ANALOG1]
	PC2 - PCINT10, ADC2 [ANALOG2]
	PC3 - PCINT11, ADC3 [ANALOG3]
	PC4 - PCINT12, ADC4, SDA [ANALOG4]
	PC5 - PCINT13, ADC5, SCL [ANALOG5]
	
	Timer Info

	pin 3 = OC2B (timer 2 PWM output B)
	pin 11 = OC2A (timer 2 PWM output A)
	pin 10 = OC1B (timer 1 PWM output B)
	pin 9 = OC1A (timer 1 PWM output A)
	pin 5 = OC0B (timer 0 PWM output B)
	pin 6 = OC0A (timer 0 PWM output A)
*/

/*
	Configuration
*/

// Unit testing and mock drivers
#define HC3D_USE_TEST_DRIVERS							0			// (on/off: 1/0) Use fake software-only testing drivers instead of hardware drivers									
																	// Select specific unit test or all unit tests
#define HC3D_UNIT_TEST									HC3D_UNIT_TEST_TEMP

// Temperature driver setup
//#define HC3D_CONFIG_PIN_TEMP_START					2			// TODO currently hardcoded, see driver_temp// Pin of temperature sensor 0. Other sensors will be assigned the pins following it
#define HC3D_CONFIG_TEMP_SENSOR_COUNT					8			// Amount of temperature sensors. Note: Also used by other temperature-related modules.

// Tach driver setup
//#define HC3D_CONFIG_DRIVER_TACH_PIN								// TODO currently hardcoded, see driver_tach

// Relay driver setup
//#define HC3D_CONFIG_PIN_RELAY										// TODO currently hardcoded, see driver_relay // Pin for failsafe output pin. Relay is LOW when failsafe is active.

// Safety-related limit of each sensor
#define HC3D_CONFIG_TEMP_SENSOR_X_LIMIT					65			// Temp sensor safe limit for X motor stepper
#define HC3D_CONFIG_TEMP_SENSOR_Y_LIMIT					65			// Temp sensor safe limit for Y motor stepper
#define HC3D_CONFIG_TEMP_SENSOR_Z_LIMIT					65			// Temp sensor safe limit for Z motor stepper
#define HC3D_CONFIG_TEMP_SENSOR_E_LIMIT					65			// Temp sensor safe limit for E motor stepper
#define HC3D_CONFIG_TEMP_SENSOR_CHAMBER0_LIMIT			80			// Temp sensor safe limit for chamber sensor 0
#define HC3D_CONFIG_TEMP_SENSOR_CHAMBER1_LIMIT			80			// Temp sensor safe limit for chamber sensor 1

// Temperature failsafe configuration
#define HC3D_CONFIG_TEMP_BUF_SIZE						10			// Keep last N temperature readings in buffer. EntireS range for confirming validity of readings (filtering out noise)
#define HC3D_CONFIG_TEMP_VALID_MIN						3			// Temperatures lower than this are considered invalid, which affects the failsafe and pump controller
#define HC3D_CONFIG_TEMP_VALID_MAX						120			// Temperatures lower than this are considered invalid, which affects the failsafe and pump controller

// Pump controller configuration
#define HC3D_CONFIG_CONTROLLER_KI						1			// See libraries/pi_control/pi_control.h
#define HC3D_CONFIG_CONTROLLER_KP						1			// See libraries/pi_control/pi_control.h
#define HC3D_CONFIG_CONTROLLER_MIN						0			// See libraries/pi_control/pi_control.h
#define HC3D_CONFIG_CONTROLLER_MAX						100			// See libraries/pi_control/pi_control.h
#define HC3D_CONFIG_CONTROLLER_SHIFT					0			// See libraries/pi_control/pi_control.h
#define HC3D_CONFIG_CONTROLLER_TEMP_SETPOINT			60			// Try to keep stepper motor surface temperature under 60

/*
	Constants
*/

// Unit test
#define HC3D_UNIT_TEST_OFF								0
#define HC3D_UNIT_TEST_ALL								1
#define HC3D_UNIT_TEST_SERIAL							2
#define HC3D_UNIT_TEST_DRIVER_SLEEP						3
#define HC3D_UNIT_TEST_DRIVER_PWM						4
#define HC3D_UNIT_TEST_DRIVER_RELAY						5
#define HC3D_UNIT_TEST_DRIVER_CLOCK						6
#define HC3D_UNIT_TEST_PWM_AND_CLOCK					7
#define HC3D_UNIT_TEST_TEMP								8



// Temperature Sensors
#define HC3D_TEMP_SENSOR_X								0			// Temp sensor handle for X motor stepper
#define HC3D_TEMP_SENSOR_Y								1			// Temp sensor handle for Y motor stepper
#define HC3D_TEMP_SENSOR_Z								2			// Temp sensor handle for Z motor stepper
#define HC3D_TEMP_SENSOR_E								3			// Temp sensor handle for E motor stepper
#define HC3D_TEMP_SENSOR_CHAMBER0						4			// Temp sensor handle for chamber sensor 0
#define HC3D_TEMP_SENSOR_CHAMBER1						5			// Temp sensor handle for chamber sensor 1
