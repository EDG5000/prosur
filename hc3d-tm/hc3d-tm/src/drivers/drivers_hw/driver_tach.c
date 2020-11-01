
/*
 * driver_tach.c
 *
 * Created: 2020-10-25 11:41:26 AM
 *  Author: Joel
 */ 

#include "config.h"
#include "avr/io.h"

#include "drivers/driver_tach.h"
#include "avr/interrupt.h"

#if HC3D_USE_TEST_DRIVERS==0

uint32_t ticks = 0; 

void driver_tach_init(void){
	// Set up interrupts
	// Ensure no interference with interrupts from driver_pwm and clock
		
	// External interrupt 0, falling edge
	// Interrupt 0 is hardware bound to pin D2
	EICRA = (EICRA & ~((1 << ISC00) | (1 << ISC01))) | (2 << ISC00);
	EIMSK |= (1 << INT0);
}

/// Has to be called at exactly 1Hz
uint32_t driver_tach_get(void){
	return 1; // TODO
	/*
			// For each tachometric device, calculate average speed in RPM based on data gathered since the last calculation
			// Reset counters afterwards
			// Store results in tach_speed_rpm_calc
			for(int i = 0; i < INPUT_DEV_COUNT; i++){
				if(tach_total_ticks[i] != 0){
					cmd_out_buf[i] = tach_total_ticks[i];
					tach_total_ticks[i] = 0;
					tach_total_duration[i] = 0;
					}else{
					cmd_out_buf[i] = 0;
				}
			}
			*/
}

// External Interrupt Request 0
ISR(INT0_vect){
	ticks++;
};


#endif