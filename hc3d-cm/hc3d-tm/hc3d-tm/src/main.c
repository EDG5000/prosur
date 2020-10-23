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
*/

#include <asf.h>
#include <stdbool.h>
#include "drivers/driver_uart.h"
#include "libraries/avr-ds80b20/ds18b20.h"
#include "libraries/avr-ds80b20/ds18b20.h"
#include "delay.h"

int main (void)
{
	sysclk_init();
	board_init();
	
	driver_uart_init();
	
	int temp;

	while(true){
		//Start conversion (without ROM matching)
		ds18b20convert( &PORTB, &DDRB, &PINB, ( 1 << 0 ), NULL );

		//Delay (sensor needs time to perform conversion)
		//_delay_ms( 1000 );
		delay_ms(1000);

		//Read temperature (without ROM matching)
		ds18b20read( &PORTB, &DDRB, &PINB, ( 1 << 0 ), NULL, &temp );

		//Somehow use data stored in `temp` variable
	}

	return 0;
}
