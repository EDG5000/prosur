
/*
 * util.h
 *
 * Created: 2020-11-10 7:04:45 AM
 *  Author: Joel
 */ 

#pragma once

#include "stdint.h"

// Fixed point number
typedef struct{
	uint16_t left;
	uint16_t right;
} fip;


// Check time offset, taking into accounr the possibility of timer wraparound events
// Use only when end is more recent than start
uint16_t util_time_offset(uint16_t start, uint16_t end);

uint16_t util_temp_raw(uint16_t temp);

uint16_t util_temp(uint16_t temp_raw);

void util_fip(uint16_t raw, fip* fip_val);
