#pragma once

#include "stdint.h"

// Check time offset, taking into accounr the possibility of timer wraparound events
// Use only when end is more recent than start
inline uint16_t util_time_offset(uint16_t start, uint16_t end){
	if(end >= start){
		return end-start;
	}else{
		// Handle timer wraparound correctly
		// TODO test!
		return UINT32_MAX-(start-end);
	}
}

