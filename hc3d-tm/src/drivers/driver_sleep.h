/*
 driver_sleep
 Contrary to other driver, this driver does not have a separate implementation for test mode
 */
#pragma once

#include "stdint.h"

void driver_sleep(uint16_t time);
