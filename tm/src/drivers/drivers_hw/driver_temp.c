/*
	driver_temp

	Writes to supplied array upon calling of read function
	Expected to be called at around 1Hz.
	Uses arbitrary waiting period to give sensors time to process calculation
	Uses pinout as described in main.c


	AVR PIN		C0
	BOARD PIN	A0?

	MF52A103J3950
	P334-4
	418011201
	10KOhm +-5% | 3950K
	K | 500
	011 | 2018.11.30

 */ 

#include "config.h"
#if HC3D_SITL_MODE==0

#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>

#include "avr/io.h"
#include "libraries/str/str.h"
#include "ds18b20/ds18b20.h"
#include "ds18b20/romsearch.h"

#include "drivers/driver_temp.h"
#include "drivers/driver_sleep.h"
#include "util.h"

// Arduino digital pin 3. AVR port D, pin 3.
#define PORT PORTD
#define DDR DDRD
#define PIN PIND
#define PINNO 3

uint8_t driver_temp_roms_found;
uint16_t driver_temp_last_readings[HC3D_MAX_TEMP_SENSORS];

uint8_t error_status = DS18B20_ERROR_OTHER;

// ADC 0-1023 represents 0-5V. 5000000÷1024 = ~4883. Multiply ADC with this to get uV (microvolts).
#define ADC_TO_UV 4883



/*
void process_raw_reading(int sensor_index, int16_t raw_reading_p){
	uint16_t value = raw_reading_p < 0 ? 0 : raw_reading_p;
	driver_temp_last_readings[sensor_index] = value;
}
*/

//-----------------
/*
uint16_t readadchan(uint8_t n){
//read ch n of internal 10 bit a/d  9KHz

  ADMUX = n;          //channel n
  ADCSRA |=0x40;     //init conversion
  while((ADCSRA & 0x40) != 0){}; //wait for conv complete (128usec)

  return ADC;
}
*/

bool is_initialized = false;

// Try to read into driver_temp_roms, populate first driver_temp_roms_found values
// Abort if any failure occurs. bus will be rescanned on next cycle
void driver_temp_read(void){
	//uint16_t val = readadchan(0);


	if(!is_initialized){
		is_initialized = true;

	    // AREF = AVcc
	    ADMUX = (1<<REFS0);

	    // ADC Enable and prescaler of 128
	    // 16000000Hz (MCU speed)/128 = 125000Hz (Safe ADC speed - ADC must be between 50-200Khz)
	    ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
	}

	uint8_t ch = 0;

	// select the corresponding channel 0~7
	// ANDing with ’7′ will always keep the value
	// of ‘ch’ between 0 and 7
	ch &= 0b00000111;  // AND operation with 7
	ADMUX = (ADMUX & 0xF8)|ch; // clears the bottom 3 bits before ORing

	// start single convertion
	// write ’1′ to ADSC
	ADCSRA |= (1<<ADSC);

	// wait for conversion to complete
	// ADSC becomes ’0′ again
	// till then, run loop continuously
	while(ADCSRA & (1<<ADSC));

	uint32_t adc_long = ADC;
	uint32_t val_uv = adc_long * ADC_TO_UV;
	//uint32_t mv = uv / 1000;

	printf("Unsigned long baby: %lu", val_uv);



	/*
	if(error_status != DS18B20_ERROR_OK){
		// Status invalid, scan bus.
		error_status = ds18b20search(&PORT, &DDR, &PIN, 1 << PINNO, &driver_temp_roms_found, (uint8_t*)driver_temp_roms, HC3D_MAX_TEMP_SENSORS * DRIVER_TEMP_ROM_SIZE);
	}

	// Conversion
	for(int i = 0; i < driver_temp_roms_found; i++){
		error_status = ds18b20convert(&PORTD, &DDRD, &PIND, 1 << PINNO, &driver_temp_roms[i*DRIVER_TEMP_ROM_SIZE]);
		if(error_status != DS18B20_ERROR_OK){
			// Abort, rescan bus next cycle
			return;
		}
	}

	// Read
	for(int i = 0; i < driver_temp_roms_found; i++){
		int16_t raw_reading;
		error_status = ds18b20read(&PORTD, &DDRD, &PIND, 1 << PINNO, &driver_temp_roms[i*DRIVER_TEMP_ROM_SIZE], &raw_reading);
		if(error_status != DS18B20_ERROR_OK){
			// Abort, rescan bus next cycle
			return;
		}
		process_raw_reading(i, raw_reading);
	}
	*/
}





//      1030           4K-400
// +5---/\/\/\----+---\/\/\/\/\---+
//      rref      |      NTC      |
//                vout		       gnd

uint16_t addat[HC3D_MAX_TEMP_SENSORS];
float ntcv;   //v across thermister
float ntcvsm; //v smoothed
float ntci;   //current thru thermistor
float ntcr;   //r of thermistor
float ntcrsm; //r smoothed
float lnr;    //ln(r)
float lnrcu;  //ln(r)^3
float tk;     //kelvin
float oneovertk;
float ntcdegc;
float ntcdegf;

#if 0
__flash float a=1.663443e-3; //3k duralast chevy temp sensor from autozone
__flash float b=1.849225e-4;
__flash float c=5.42688e-8;
#endif

#if 0
__flash float a=1.28745e-3; //5k epcos temp sensor
__flash float b=2.357394e-4;
__flash float c=9.5052e-8;
#endif

#if 0
__flash float a=2.22348e-3; //MGB  810 ohm temperature sender
__flash float b=3.965e-5;
__flash float c=2.6583e-6;
#endif

#if 0
float a=1.778139e-3; //wells mfg tu165 from autozone $9.99
float b=1.511277e-4;
float c=9.472924e-7;
#endif

//-------------------------
/*
void calcntctemp(void){
//calc temp from ntc thermistor on pin8 or pin10?
//steinhart eqn: 1/T= a+ b(LnR)+c(LnR)^3
//20 fp ops + a log

  addat[0]=readadchan(0);  //debug chg to ad ch 1  ad ch0 on pin8
  ntcv=addat[0]*ad2volts;  //volts across thermistor
  ntcvsm = ntcvsm + .125*(ntcv-ntcvsm); //ntcv smoothed over 8 readings
  ntci=(vref - ntcvsm)/rref;  //amps thru thermistor
  ntcr=ntcvsm/ntci;        //ohms of thermistor
  ntcrsm=ntcrsm + .125*(ntcr - ntcrsm); //ntcr smoothed
  lnr=log(ntcrsm);         //ln of ntcr
  lnrcu=lnr*lnr*lnr;       //ln ntcr cubed
  oneovertk=ntca + ntcb*lnr + ntcc*lnrcu; //the Steinhart equation!
  tk=1.0/oneovertk;           //deg in K
  ntcdegc=tk-273.15;          //deg C
  ntcdegf=1.8*ntcdegc + 32.0; //deg F
}
*/

//-------------------------
/*
void ntcloop(void){
//read ntc on a/d ch 0
char c;

  cprintf("ntc thermistor\n");
	cprintf("ad  degc   degf   v      a      r   q=quit\n");
  while(c != 'q'){
    if(kbhit()){
      c=getchar();
    }
    calcntctemp();
    cprintf("%03x %#6.1f %#6.1f %#6.3f %#6.3f %#6.1f \r",
		  addat[0],ntcdegc,ntcdegf,ntcvsm,ntci,ntcrsm);
    delnms(10);
  }
}

*/


#endif
