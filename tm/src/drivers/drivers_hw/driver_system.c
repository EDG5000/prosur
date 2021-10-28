/*
	driver_system
 */

#include "config.h"
#if HC3D_SITL_MODE==0

#include "drivers/driver_system.h"

void driver_system_halt(void){
	while(1);
}

#endif
