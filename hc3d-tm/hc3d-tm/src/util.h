
/*
 * util.h
 *
 * Created: 2020-11-10 7:04:45 AM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"

// Check time offset, taking into accounr the possibility of timer wraparound events
// Use only when end is more recent than start
uint32_t util_time_offset(uint32_t start, uint32_t end);