/*
	driver_system
 */

#include "config.h"
#if HC3D_SITL_MODE==1
#include "stdlib.h"
#include "drivers/driver_system.h"

void driver_system_halt(void){
	exit(0);
}

#endif
