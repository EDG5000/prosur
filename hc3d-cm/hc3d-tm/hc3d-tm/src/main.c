/*
	HC3D-TM
	Infinus I/O HC3D Temperature Management
	
	Purpose
		- Monitor stepper motor temperature; kill power to Duet when limits exceeded.
		- Monitor chamber temperature; kill power to duet when limits exceeded
		- Report all temperatures to UART
		
		(future)- Control stepper motor temperature by controlling pump PWM (optionally with tach as feedback/sanity check)
		
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
			Data Reader
				- Periodically invoke Tach and Temp driver.
				- For Temp, store last 10 values
			Temperature Watchdog
				- For Temp, check for at least 10 values when checking for limit exceeded/not exceeded condition
				- Trigger failsafe when needed
					- Invoke Relay driver
					- Send message to UART
					- Abort program excecution
			(future) Pump Controller
				- Keep steppers below target temperature
				- Use PID; send PWM command to PWM driver
				- Read Tach from Data Reader
		Data Reporter
				- Reports temperature data, tach data
				- Events related to safety are also reported as string messages over serial (not handled by serial writer)	
		
		HW Drivers & Test Drivers
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
			Sleep Driver
				- Provides sleep(uint ms) function
	Test Stategy
		- Compile test drivers instead of hardware drivers when running in unit test mode
		- Temp Driver in test mode will generate fake data when requesting data
		- Relay driver will print operations in console
		- UART driver will print written data in console
		

*/

#include "config.h"
#include "asf.h"
#include "stdbool.h"
#include "drivers/driver_uart.h"
#include "drivers/driver_sleep.h"
#include "drivers/driver_relay.h"
#include "drivers/driver_temp.h"
#include "drivers/driver_pwm.h"
#include "drivers/driver_tach.h"

#include "business_logic/failsafe.h"
#include "business_logic/data_reader.h"
#include "business_logic/data_reporter.h"
#include "business_logic/temp_watchdog.h"
#include "business_logic/clock.h"
#include "business_logic/pump_controller.h"

#if HC3D_UNIT_TEST == HC3D_UNIT_TEST_OFF
int main (void){
	// Call ASF bootstrap functions. Not sure if needed.
	sysclk_init();
	board_init();

	// Init drivers
	driver_relay_init(); // Relay should be off after power cycle and stay off during initialisation of the relay driver
	driver_uart_init();
	driver_temp_init();
	driver_pwm_init();
	driver_tach_init();
	
	// Init business logic modules
	clock_init();
	pump_controller_init();
	temp_watchdog_init();
	
	while(true){
		// Record tick start time to later calculate the correct sleep time
		uint32_t time_start = clock_time();
	
		// This will fetch temperature data from driver_temp and store it in a buffer
		data_reader_tick();

/*
		// Run temp_watchdog, which also calculates validated temperatures used later
		if(!temp_watchdog_tick()){
			// Temp_watchdog has invoked the failsafe
			// Abort excecution of program
			break;
		}
*/
		
		// Run pump controller. Uses data calculated by temp_watchdog
		// Results from pump_controller will be reported by data_reporter
		// along with other data points.
		pump_controller_tick();
		
		// Report measured temperatures to serial
		data_reporter_tick();
		
		uint32_t time_taken = clock_time() - time_start;
		if(time_taken > 1000){
			// Will be in the case of slow processing or timer wrap around
			// To confidently ensure at least 1Hz is used between frames, default to 
			// sleeping the full 1s in these unsure cases.
			time_taken = 0;
		}
		driver_sleep(1000 - time_taken); // 1 sec delay + data reader time duration
	}
	
	// Prevent AVR from resetting
	// This section will only be reached when the failsafe is triggered
	while(true){
		driver_sleep(1000);
	}

	return 0;
}
#endif