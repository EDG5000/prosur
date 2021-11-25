#include "u16crc.h"

#include "stdint.h"

// Taken from https://www.avrfreaks.net/comment/2820506#comment-2820506
///////////////////////////////////////////////////////////////////////////////
//  FUNCTION:    u16ComputeCRC                                               //
//  DESCRIPTION: This routine takes a pointer to a data array, the length of //
//               the array, and a CRC seed and returns the calculated CRC for//
//               that data. CRC seed is 0xFFFF 							     //
//  GLOBALS      none                                                        //
//  INPUTS:      u16CRC - seed, pData - pointer to array, u8Length - number  //
//               bytes to process.                                           //
//  OUTPUTS:     u16CRC - Calculated Result.                                 //
//  AUTHOR:      unknown                                     //
//  HISTORY:     02/06/2014 - Initial - EJK                                  //
//               xx/xx/xxxx - Modification desc... - initials                //
///////////////////////////////////////////////////////////////////////////////
uint16_t u16ComputeCRC(uint16_t u16CRC, uint8_t *pData, uint8_t u8Length){
  uint8_t u8Bit, i;
  uint16_t u16Odd;

  for (i = 0; i < u8Length; i++)
  {
    u16CRC ^= ((uint16_t) * pData << 8);
    for (u8Bit = 0; u8Bit < 8; u8Bit++)
    {
      u16Odd = u16CRC & 0x8000;
      u16CRC <<= 1;
      if (u16Odd == 0x8000)
      {
        u16CRC ^=0x1021;  //C13 + C6 + C1
      }
    }
    pData++;
  }
  return (u16CRC);
}
