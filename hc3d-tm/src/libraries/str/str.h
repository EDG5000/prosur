/*
	Joel: Reworked version of str using absolute types

	Based on: http://www.sparetimelabs.com/strrevisited/strrevisited.php

	Formats:
		char		c
		string 		s
		int16_t		i
		uint16_t	u

?
x	Unsigned hexadecimal integer	7fa
X	Unsigned hexadecimal integer (uppercase)	7FA

*/

#pragma once

#include <stdarg.h>

void str(char *fmt, ...);
