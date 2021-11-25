
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

char* uint64_to_str(uint64_t n, char dest[static 21]) {
    dest += 20;
    *dest-- = 0;
    while (n) {
        *dest-- = (n % 10) + '0';
        n /= 10;
    }
    return dest + 1;
}

/*
 * from avr-libc util/crc16.h (code is from a comment from avr-libc

	Optimized CRC-16 calculation.

	Polynomial: x^16 + x^15 + x^2 + 1 (0xa001)<br>
	Initial value: 0xffff

	This CRC is normally used in disk-drive controllers.

	The following is the equivalent functionality written in C.

*/
uint16_t crc16_update(uint16_t crc, uint8_t a){
	int i;
	crc ^= a;
	for (i = 0; i < 8; ++i){
		if (crc & 1){
			crc = (crc >> 1) ^ 0xA001;
		}else{
			crc = (crc >> 1);
		}
	}
	return crc;
}


