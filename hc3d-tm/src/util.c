
/*
 * util.c
 *
 * Created: 2020-11-10 7:04:52 AM
 *  Author: Joel
 */ 

#include "util.h"
#include "stdint.h"

uint16_t util_time_offset(uint16_t start, uint16_t end){
	if(end >= start){
		return end-start;
	}else{
		// Handle timer wraparound correctly
		// TODO test!
		return UINT32_MAX-(start-end);
	}
}
