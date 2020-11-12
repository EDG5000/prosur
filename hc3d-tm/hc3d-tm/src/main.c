/*
	HC3D-TM
	Infinus I/O HC3D Temperature Management
	
	TODO expand temperature algorythm: no reading for 100 frames, trigger invalid reading
	
	Purpose
		- Monitor stepper motor temperature; kill power to Duet when limits exceeded.
		- Monitor chamber temperature; kill power to duet when limits exceeded
		- Report to UART:  raw and processed temperatures, pump tachometer reading, pump pi controller state, failsafe events (detailed reason)
		- Control stepper motor temperature by controlling pump
		
	Envisioned scenarios:
		failsafe triggered due to
			invalid reading detected
			chamber temperature reached critical level
			motor temperature reached critical level
		pump controller is
			not cooling due to motors still at safe temperature, chamber still heating
			keeping motors stable at setpoint of 60 deg, ambient temperature 70, motors inactive
			keeping motors table at setppoint of 60 deg, ambient temperature 70, motors active
			motors have exceeded 60 deg c, controller is experiencing slight overshoot and attempting to reach setpoint and recovers
			motors under 60 deg c, controller is experiencing slight undershoot and recovers
			cooling system failure; cooling setpoint 100%, motor temperature exceeding setpoint approaching critical level
		reporting during long print
			data reported, no failsafe triggered, pump controller operational
		
	Startup Sequence
		- Board init
		- Init relay pin.
		- Relay OFF
		
		- Init temp sensors.
		- Start periodic temperature reading. (1 Hz)
		- Await intial temp reading (1 verified reading).
		- IF initial reading EXCEEDS limit:
			- Write shutdown message: "Limit exceeded at startup. Failsafe active."
			- Abort program operation (while(true))
		- Start temperature watchdog:
			- IF verified temperature reading exceeds chamber or stepper temp
				- Relay OFF
				- Write shutdown message: "Chamber/Stepper Limit exceeded. Failsafe active."
				- Abort progream excecution
		
		(future)
		- Init PWM out
		- Set initial PWM out (MIN)
		- Start periodic PWM writing
		- Init Tach in
		- Start periodic Tach reading
		
		- Start PID loop
		
	Architecture
		Business Logic
			Failsafe
				- Invoke relay driver
			Data Reader
				- Periodically invoke Tach and Temp driver.
				- For Temp, store last 10 values
				Temperature Watchdog
					- For Temp, check for at least 10 values when checking for limit exceeded/not exceeded condition
					- Trigger failsafe when needed
					- Invoke failsafe
					- Send message to UART
					- Abort program excecution
					Data Reporter
					- Reports temperature data, tach data
					- Events related to safety are also reported as string messages over serial (not handled by serial writer)
			Pump Controller
				- Keep steppers below target temperature
				- Use PI; send PWM command to PWM driver
				- Read Tach from Data Reader

		
		HW Drivers & SITL Drivers
			Tach Driver
				- Configure interrupt
				- Store latest calculated RPM value
			PWM Driver
				- PWM is set using external API or by periodically reading a value
			Relay Driver
				- Offers Init and Set function
				- Allows reading of current pin state (last value sent is stored)
			Temp Driver
				- Allows performing init() and read() calls on sensors
			Sleep Driver (No SITL driver used)
				- Provides sleep(uint ms) function
			Clock Driver (No SITL driver used)
				- Provides system clock
				
		Unit Tests
			Provides unit tests for all modules, both drivers and business logic
			
	Test Stategy
		- Compile test drivers instead of hardware drivers when running in unit test mode
		- Temp Driver in test mode will generate fake data when requesting data
		- Relay driver will print operations in console
		- UART driver will print written data in console
		
	Pin Reservations
		driver_tach: 2 (D2)
		driver_pwm: 9 (B1) + 10 reserved (B2)
		driver_relay: 8 (B0)
		driver_temp 3 (D3), 4 (D4), 5 (D5), 6 (D6) , 7 (D7), 11 (B3), 12 (B4)
		

*/

#include "config.h"
#include "util.h"
#include "stdbool.h"
#include "libraries/avr_printf/avr_printf.h"

#include "stdio.h"
#include "drivers/driver_sleep.h"
#include "drivers/driver_relay.h"
#include "drivers/driver_temp.h"
#include "drivers/driver_pwm.h"
#include "drivers/driver_tach.h"
#include "drivers/driver_clock.h"

#include "business_logic/failsafe.h"
#include "business_logic/data_reader.h"
#include "business_logic/data_reporter.h"
#include "business_logic/temp_validator.h"
#include "business_logic/temp_watchdog.h"
#include "business_logic/pump_controller.h"

#if HC3D_TEST_MODE == 0 || HC3D_TEST_MODE == HC3D_TEST_MODE_SITL
int main (void){

	avr_printf_init();
	printf("Infinus I/O HC3D-TM 0.0.1 (c) Joel Meijering\n");

	// Init drivers
	driver_relay_init(); // Relay should be off after power cycle and stay off during initialisation of the relay driver
	driver_pwm_init();
	driver_tach_init();
	driver_clock_init();
	
	// Init business logic modules
	pump_controller_init();
	temp_validator_init();
	temp_watchdog_init();

	while(true){
		// Record tick start time to later calculate the correct sleep time
		uint32_t time_tick_start = driver_clock_time();
	
		// This will fetch temperature data from driver_temp and store it in a buffer
		data_reader_tick();

		// This will assess validity of sensor readings and store the results
		temp_validator_tick();

		// Will check for invalid readings, limit exceedings or validation timeouts
		// Will trigger failsafe if any issue is encountered
		temp_watchdog_tick();

		// Run pump controller. Uses data calculated by temp_validator
		// Results from pump_controller will be reported by data_reporter
		// along with other data points.
		pump_controller_tick();
		
		// Report measured temperatures to serial
		data_reporter_tick();
		
		uint32_t time_taken = util_time_offset(time_tick_start, driver_clock_time());
		driver_sleep(1000 - time_taken); // Sleep as such to ensure loop running at 1Hz
	}
	
	// Prevent AVR from resetting
	// This section will only be reached when the failsafe is triggered
	while(1);

	return 0;
}
#endif