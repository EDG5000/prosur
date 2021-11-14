/*
	HC3D-TM
	Infinus I/O HC3D Temperature Management
*/

#include "config.h"
#include "util.h"

#include "stdbool.h"
#include "stdlib.h"
#include "stdio.h"

#include "libraries/str/str.h"
#include "drivers/driver_sleep.h"
#include "drivers/driver_clock.h"
#include "drivers/driver_temp.h"
#include "drivers/driver_uart.h"
#include "drivers/driver_system.h"
#include "drivers/driver_sleep.h"
#include "business_logic/data_reporter.h"

#if HC3D_TEST_MODE == 0 || HC3D_TEST_MODE == HC3D_TEST_MODE_SITL
int main (void){
	driver_uart_init();

	// Init drivers
	driver_relay_init(); // Relay should be off after power cycle and stay off during initialisation of the relay driver
	driver_pwm_init();
	driver_tach_init();
	driver_clock_init();
	driver_temp_init();

	// Init business logic modules
	pump_controller_init();
	temp_validator_init();
	temp_watchdog_init();

	uint16_t time_tick_start = 0;

	while(true){
		time_tick_start = driver_clock_time();
		driver_temp_read();
		data_reader_tick();
		data_reporter_tick(time_tick_start);
		uint16_t time_taken = util_time_offset(time_tick_start, driver_clock_time());
		driver_sleep(HC3D_INTERVAL - time_taken);
	}
	
	driver_system_halt();
	return 0;
}
#endif
