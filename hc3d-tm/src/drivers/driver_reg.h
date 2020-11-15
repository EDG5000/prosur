/*
 * Allows dynamic register configuration
 * TODO Perhaps a setup with macros for readability and use of a switch in a loop would make more sense to still allow systematic treatment of multiple ports in driver_temp
   TODO current setup is not the most performance-friendly but should allow maximal readiability and configurability
 */

#pragma once

// Obtain PORTX, PINX, DDRX register pointers based on supplied arduino-compatible digital pin number (0-13, 13=led)
// Analog pins could be supported by introducing an analog pin offset and defines for the analog pins
volatile uint8_t* driver_reg_port(uint8_t* pin);
volatile uint8_t* driver_reg_pin(uint8_t* pin);
volatile uint8_t* driver_reg_ddr(uint8_t* pin);
uint8_t config_mask(uint8_t* pin);
