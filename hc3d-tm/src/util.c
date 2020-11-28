
/*
 * util.c
 *
 * Created: 2020-11-10 7:04:52 AM
 *  Author: Joel
 */ 

#include "util.h"
#include "stdint.h"
#include "libraries/str/str.h"

uint16_t util_time_offset(uint16_t start, uint16_t end){
	if(end >= start){
		return end-start;
	}else{
		// Handle timer wraparound correctly
		// TODO test!
		return UINT32_MAX-(start-end);
	}
}

uint16_t util_temp_raw(uint16_t temp){
	return temp * 16;
}

uint16_t util_temp(uint16_t temp_raw){
	return temp_raw / 16;
}

void util_fip(uint16_t raw, fip* fip_val){
	fip_val->left = raw / 16;
	fip_val->right = (100 * (raw % 16)) / 16;
}
