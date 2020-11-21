/*
	driver_system
 */

#include "config.h"
#if HC3D_USE_TEST_DRIVERS==1
#include "stdlib.h"
#include "drivers/driver_system.h"

void driver_system_halt(void){
	exit(0);
}

#endif
