#pragma once

#include "stdint.h"

#define U16CRC_SEED 22282 // Random non-zero value to avoid checksum being zero

uint16_t u16ComputeCRC( uint16_t u16CRC, uint8_t *pData, uint8_t u8Length );
