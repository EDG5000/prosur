#include "str.h"
#include "stdint.h"
#include "stdio.h"

static char* bf;
static char buf[12];
static uint16_t num;
static char uc;
static char zs;

static void out(char c) {
	*bf++ = c;
}

static void out_dgt(char dgt) {
	out(dgt + (dgt < 10 ? '0' : (uc ? 'A' : 'a') - 10));
	zs = 1;
}

static void div_out(uint16_t div) {
	uint16_t dgt = 0;
	num &= 0xffff; // just for testing the code with 32 bit ints
	while (num >= div) {
		num -= div;
		dgt++;
	}
	if (zs || dgt > 0)
		out_dgt(dgt);
}

void str(char *fmt, ...) {
	va_list va;
	char ch;
	char* p;

	va_start(va, fmt);

	while ((ch = *(fmt++))) {
		if (ch != '%') {
			putchar(ch);
		} else {
			char lz = 0;
			char w = 0;
			ch = *(fmt++);
			if (ch == '0') {
				ch = *(fmt++);
				lz = 1;
			}
			if (ch >= '0' && ch <= '9') {
				w = 0;
				while (ch >= '0' && ch <= '9') {
					w = (((w << 2) + w) << 1) + ch - '0';
					ch = *fmt++;
				}
			}
			bf = buf;
			p = bf;
			zs = 0;
			switch (ch) {
			case 0:
				goto abort;
			case 'u':
			case 'd':
				num = (uint16_t) va_arg(va, int);
				if (ch == 'd' && (int) num < 0) {
					num = -(int) num;
					out('-');
				}
				div_out(10000);
				div_out(1000);
				div_out(100);
				div_out(10);
				out_dgt(num);
				break;
			case 'x':
			case 'X':
				uc = ch == 'X';
				num = (uint16_t) va_arg(va, int);
				div_out(0x1000);
				div_out(0x100);
				div_out(0x10);
				out_dgt(num);
				break;
			case 'c':
				out((char) (va_arg(va, int)));
				break;
			case 's':
				p = va_arg(va, char*);
				break;
			case '%':
				out('%');
				break;
			default:
				break;
			}
			*bf = 0;
			bf = p;
			while (*bf++ && w > 0)
				w--;
			while (w-- > 0)
				putchar(lz ? '0' : ' ');
			while ((ch = *p++))
				putchar(ch);
		}
	}
	abort: ;
	va_end(va);
}

