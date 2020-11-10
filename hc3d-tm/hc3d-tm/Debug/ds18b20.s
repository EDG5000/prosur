	.file	"ds18b20.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.section	.text.ds18b20crc8,"ax",@progbits
.global	ds18b20crc8
	.type	ds18b20crc8, @function
ds18b20crc8:
.LFB6:
	.file 1 "../src/libraries/avr-ds80b20/ds18b20.c"
	.loc 1 21 0
	.cfi_startproc
.LVL0:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	movw r26,r24
.LVL1:
	.loc 1 27 0
	ldi r24,0
.LVL2:
	.loc 1 30 0
	ldi r20,0
	rjmp .L2
.LVL3:
.L6:
	.loc 1 32 0
	movw r30,r26
	add r30,r20
	adc r31,__zero_reg__
	ld r18,Z
.LVL4:
	.loc 1 34 0
	ldi r25,0
	rjmp .L3
.LVL5:
.L5:
	.loc 1 36 0
	mov r19,r24
	eor r19,r18
.LVL6:
	.loc 1 37 0
	lsr r24
.LVL7:
	.loc 1 38 0
	sbrs r19,0
	rjmp .L4
	.loc 1 38 0 is_stmt 0 discriminator 1
	ldi r19,lo8(-116)
.LVL8:
	eor r24,r19
.LVL9:
.L4:
	.loc 1 39 0 is_stmt 1 discriminator 2
	lsr r18
.LVL10:
	.loc 1 34 0 discriminator 2
	subi r25,lo8(-(1))
.LVL11:
.L3:
	.loc 1 34 0 is_stmt 0 discriminator 1
	cpi r25,lo8(8)
	brlo .L5
	.loc 1 30 0 is_stmt 1 discriminator 2
	subi r20,lo8(-(1))
.LVL12:
.L2:
	.loc 1 30 0 is_stmt 0 discriminator 1
	cp r20,r22
	brlo .L6
/* epilogue start */
	.loc 1 43 0 is_stmt 1
	ret
	.cfi_endproc
.LFE6:
	.size	ds18b20crc8, .-ds18b20crc8
	.section	.text.ds18b20match,"ax",@progbits
.global	ds18b20match
	.type	ds18b20match, @function
ds18b20match:
.LFB7:
	.loc 1 47 0
	.cfi_startproc
.LVL13:
	push r8
.LCFI0:
	.cfi_def_cfa_offset 3
	.cfi_offset 8, -2
	push r9
.LCFI1:
	.cfi_def_cfa_offset 4
	.cfi_offset 9, -3
	push r10
.LCFI2:
	.cfi_def_cfa_offset 5
	.cfi_offset 10, -4
	push r11
.LCFI3:
	.cfi_def_cfa_offset 6
	.cfi_offset 11, -5
	push r12
.LCFI4:
	.cfi_def_cfa_offset 7
	.cfi_offset 12, -6
	push r13
.LCFI5:
	.cfi_def_cfa_offset 8
	.cfi_offset 13, -7
	push r14
.LCFI6:
	.cfi_def_cfa_offset 9
	.cfi_offset 14, -8
	push r15
.LCFI7:
	.cfi_def_cfa_offset 10
	.cfi_offset 15, -9
	push r16
.LCFI8:
	.cfi_def_cfa_offset 11
	.cfi_offset 16, -10
	push r17
.LCFI9:
	.cfi_def_cfa_offset 12
	.cfi_offset 17, -11
	push r28
.LCFI10:
	.cfi_def_cfa_offset 13
	.cfi_offset 28, -12
	push r29
.LCFI11:
	.cfi_def_cfa_offset 14
	.cfi_offset 29, -13
/* prologue: function */
/* frame size = 0 */
/* stack size = 12 */
.L__stack_usage = 12
	movw r14,r24
	movw r12,r22
	movw r10,r20
	mov r29,r18
	movw r8,r16
.LVL14:
	.loc 1 54 0
	or r16,r17
	brne .L8
	.loc 1 57 0
	ldi r16,lo8(-52)
.LVL15:
	call onewireWrite
.LVL16:
	rjmp .L7
.LVL17:
.L8:
	.loc 1 62 0
	ldi r16,lo8(85)
	call onewireWrite
.LVL18:
	.loc 1 63 0
	ldi r28,0
	rjmp .L10
.LVL19:
.L11:
	.loc 1 64 0 discriminator 3
	movw r30,r8
	add r30,r28
	adc r31,__zero_reg__
	ld r16,Z
	mov r18,r29
	movw r20,r10
	movw r22,r12
	movw r24,r14
	call onewireWrite
.LVL20:
	.loc 1 63 0 discriminator 3
	subi r28,lo8(-(1))
.LVL21:
.L10:
	.loc 1 63 0 is_stmt 0 discriminator 1
	cpi r28,lo8(8)
	brlo .L11
.LVL22:
.L7:
/* epilogue start */
	.loc 1 66 0 is_stmt 1
	pop r29
.LVL23:
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
.LVL24:
	pop r13
	pop r12
.LVL25:
	pop r11
	pop r10
.LVL26:
	pop r9
	pop r8
.LVL27:
	ret
	.cfi_endproc
.LFE7:
	.size	ds18b20match, .-ds18b20match
	.section	.text.ds18b20convert,"ax",@progbits
.global	ds18b20convert
	.type	ds18b20convert, @function
ds18b20convert:
.LFB8:
	.loc 1 70 0
	.cfi_startproc
.LVL28:
	push r11
.LCFI12:
	.cfi_def_cfa_offset 3
	.cfi_offset 11, -2
	push r12
.LCFI13:
	.cfi_def_cfa_offset 4
	.cfi_offset 12, -3
	push r13
.LCFI14:
	.cfi_def_cfa_offset 5
	.cfi_offset 13, -4
	push r14
.LCFI15:
	.cfi_def_cfa_offset 6
	.cfi_offset 14, -5
	push r15
.LCFI16:
	.cfi_def_cfa_offset 7
	.cfi_offset 15, -6
	push r16
.LCFI17:
	.cfi_def_cfa_offset 8
	.cfi_offset 16, -7
	push r17
.LCFI18:
	.cfi_def_cfa_offset 9
	.cfi_offset 17, -8
	push r28
.LCFI19:
	.cfi_def_cfa_offset 10
	.cfi_offset 28, -9
	push r29
.LCFI20:
	.cfi_def_cfa_offset 11
	.cfi_offset 29, -10
/* prologue: function */
/* frame size = 0 */
/* stack size = 9 */
.L__stack_usage = 9
	movw r28,r24
	movw r14,r22
	movw r12,r20
	mov r11,r18
	.loc 1 74 0
	call onewireInit
.LVL29:
	cpi r24,lo8(1)
	breq .L13
	.loc 1 78 0
	mov r18,r11
	movw r20,r12
	movw r22,r14
	movw r24,r28
	call ds18b20match
.LVL30:
	.loc 1 81 0
	ldi r16,lo8(68)
.LVL31:
	mov r18,r11
	movw r20,r12
	movw r22,r14
	movw r24,r28
	call onewireWrite
.LVL32:
	.loc 1 83 0
	ldi r24,0
.L13:
/* epilogue start */
	.loc 1 84 0
	pop r29
	pop r28
.LVL33:
	pop r17
	pop r16
	pop r15
	pop r14
.LVL34:
	pop r13
	pop r12
.LVL35:
	pop r11
.LVL36:
	ret
	.cfi_endproc
.LFE8:
	.size	ds18b20convert, .-ds18b20convert
	.section	.text.ds18b20rsp,"ax",@progbits
.global	ds18b20rsp
	.type	ds18b20rsp, @function
ds18b20rsp:
.LFB9:
	.loc 1 88 0
	.cfi_startproc
.LVL37:
	push r8
.LCFI21:
	.cfi_def_cfa_offset 3
	.cfi_offset 8, -2
	push r9
.LCFI22:
	.cfi_def_cfa_offset 4
	.cfi_offset 9, -3
	push r10
.LCFI23:
	.cfi_def_cfa_offset 5
	.cfi_offset 10, -4
	push r11
.LCFI24:
	.cfi_def_cfa_offset 6
	.cfi_offset 11, -5
	push r12
.LCFI25:
	.cfi_def_cfa_offset 7
	.cfi_offset 12, -6
	push r13
.LCFI26:
	.cfi_def_cfa_offset 8
	.cfi_offset 13, -7
	push r14
.LCFI27:
	.cfi_def_cfa_offset 9
	.cfi_offset 14, -8
	push r15
.LCFI28:
	.cfi_def_cfa_offset 10
	.cfi_offset 15, -9
	push r16
.LCFI29:
	.cfi_def_cfa_offset 11
	.cfi_offset 16, -10
	push r17
.LCFI30:
	.cfi_def_cfa_offset 12
	.cfi_offset 17, -11
	push r28
.LCFI31:
	.cfi_def_cfa_offset 13
	.cfi_offset 28, -12
	push r29
.LCFI32:
	.cfi_def_cfa_offset 14
	.cfi_offset 29, -13
/* prologue: function */
/* frame size = 0 */
/* stack size = 12 */
.L__stack_usage = 12
	movw r12,r24
	movw r10,r22
	movw r8,r20
	mov r29,r18
.LVL38:
	.loc 1 94 0
	call onewireInit
.LVL39:
	cpi r24,lo8(1)
	breq .L15
	.loc 1 98 0
	mov r18,r29
	movw r20,r8
	movw r22,r10
	movw r24,r12
	call ds18b20match
.LVL40:
	.loc 1 101 0
	ldi r16,lo8(-66)
.LVL41:
	mov r18,r29
	movw r20,r8
	movw r22,r10
	movw r24,r12
	call onewireWrite
.LVL42:
	.loc 1 102 0
	ldi r28,0
	rjmp .L16
.LVL43:
.L17:
	.loc 1 103 0 discriminator 3
	movw r16,r14
	add r16,r28
	adc r17,__zero_reg__
	mov r18,r29
	movw r20,r8
	movw r22,r10
	movw r24,r12
	call onewireRead
.LVL44:
	movw r30,r16
	st Z,r24
	.loc 1 102 0 discriminator 3
	subi r28,lo8(-(1))
.LVL45:
.L16:
	.loc 1 102 0 is_stmt 0 discriminator 1
	cpi r28,lo8(9)
	brlo .L17
	.loc 1 106 0 is_stmt 1
	movw r30,r14
	ld r23,Z
	ldd r24,Z+1
	ldd r22,Z+2
	ldd r21,Z+3
	ldd r20,Z+4
	ldd r19,Z+5
	ldd r18,Z+6
	ldd r25,Z+7
	or r24,r23
	or r24,r22
	or r24,r21
	or r24,r20
	or r24,r19
	or r24,r18
	or r24,r25
	breq .L18
	.loc 1 110 0
	ldi r22,lo8(8)
	movw r24,r14
	call ds18b20crc8
.LVL46:
	movw r30,r14
	ldd r25,Z+8
	cp r24,r25
	breq .L19
	.loc 1 111 0
	ldi r24,lo8(2)
	rjmp .L15
.L18:
	.loc 1 107 0
	ldi r24,lo8(3)
	rjmp .L15
.L19:
	.loc 1 113 0
	ldi r24,0
.LVL47:
.L15:
/* epilogue start */
	.loc 1 114 0
	pop r29
.LVL48:
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
.LVL49:
	pop r13
	pop r12
.LVL50:
	pop r11
	pop r10
.LVL51:
	pop r9
	pop r8
.LVL52:
	ret
	.cfi_endproc
.LFE9:
	.size	ds18b20rsp, .-ds18b20rsp
	.section	.text.ds18b20wsp,"ax",@progbits
.global	ds18b20wsp
	.type	ds18b20wsp, @function
ds18b20wsp:
.LFB10:
	.loc 1 118 0
	.cfi_startproc
.LVL53:
	push r6
.LCFI33:
	.cfi_def_cfa_offset 3
	.cfi_offset 6, -2
	push r7
.LCFI34:
	.cfi_def_cfa_offset 4
	.cfi_offset 7, -3
	push r8
.LCFI35:
	.cfi_def_cfa_offset 5
	.cfi_offset 8, -4
	push r9
.LCFI36:
	.cfi_def_cfa_offset 6
	.cfi_offset 9, -5
	push r10
.LCFI37:
	.cfi_def_cfa_offset 7
	.cfi_offset 10, -6
	push r12
.LCFI38:
	.cfi_def_cfa_offset 8
	.cfi_offset 12, -7
	push r14
.LCFI39:
	.cfi_def_cfa_offset 9
	.cfi_offset 14, -8
	push r15
.LCFI40:
	.cfi_def_cfa_offset 10
	.cfi_offset 15, -9
	push r16
.LCFI41:
	.cfi_def_cfa_offset 11
	.cfi_offset 16, -10
	push r17
.LCFI42:
	.cfi_def_cfa_offset 12
	.cfi_offset 17, -11
	push r28
.LCFI43:
	.cfi_def_cfa_offset 13
	.cfi_offset 28, -12
	push r29
.LCFI44:
	.cfi_def_cfa_offset 14
	.cfi_offset 29, -13
/* prologue: function */
/* frame size = 0 */
/* stack size = 12 */
.L__stack_usage = 12
	movw r28,r24
	movw r8,r22
	movw r6,r20
	mov r15,r18
	.loc 1 125 0
	call onewireInit
.LVL54:
	cpi r24,lo8(1)
	breq .L21
	.loc 1 129 0
	mov r18,r15
	movw r20,r6
	movw r22,r8
	movw r24,r28
	call ds18b20match
.LVL55:
	.loc 1 132 0
	ldi r16,lo8(78)
.LVL56:
	mov r18,r15
	movw r20,r6
	movw r22,r8
	movw r24,r28
	call onewireWrite
.LVL57:
	.loc 1 133 0
	mov r16,r14
	mov r18,r15
	movw r20,r6
	movw r22,r8
	movw r24,r28
	call onewireWrite
.LVL58:
	.loc 1 134 0
	mov r16,r12
	mov r18,r15
	movw r20,r6
	movw r22,r8
	movw r24,r28
	call onewireWrite
.LVL59:
	.loc 1 135 0
	mov r16,r10
	mov r18,r15
	movw r20,r6
	movw r22,r8
	movw r24,r28
	call onewireWrite
.LVL60:
	.loc 1 137 0
	ldi r24,0
.L21:
/* epilogue start */
	.loc 1 138 0
	pop r29
	pop r28
.LVL61:
	pop r17
	pop r16
	pop r15
.LVL62:
	pop r14
.LVL63:
	pop r12
.LVL64:
	pop r10
.LVL65:
	pop r9
	pop r8
.LVL66:
	pop r7
	pop r6
.LVL67:
	ret
	.cfi_endproc
.LFE10:
	.size	ds18b20wsp, .-ds18b20wsp
	.section	.text.ds18b20csp,"ax",@progbits
.global	ds18b20csp
	.type	ds18b20csp, @function
ds18b20csp:
.LFB11:
	.loc 1 142 0
	.cfi_startproc
.LVL68:
	push r10
.LCFI45:
	.cfi_def_cfa_offset 3
	.cfi_offset 10, -2
	push r11
.LCFI46:
	.cfi_def_cfa_offset 4
	.cfi_offset 11, -3
	push r12
.LCFI47:
	.cfi_def_cfa_offset 5
	.cfi_offset 12, -4
	push r13
.LCFI48:
	.cfi_def_cfa_offset 6
	.cfi_offset 13, -5
	push r15
.LCFI49:
	.cfi_def_cfa_offset 7
	.cfi_offset 15, -6
	push r16
.LCFI50:
	.cfi_def_cfa_offset 8
	.cfi_offset 16, -7
	push r17
.LCFI51:
	.cfi_def_cfa_offset 9
	.cfi_offset 17, -8
	push r28
.LCFI52:
	.cfi_def_cfa_offset 10
	.cfi_offset 28, -9
	push r29
.LCFI53:
	.cfi_def_cfa_offset 11
	.cfi_offset 29, -10
/* prologue: function */
/* frame size = 0 */
/* stack size = 9 */
.L__stack_usage = 9
	movw r12,r24
	movw r28,r22
	movw r10,r20
	mov r15,r18
	.loc 1 146 0
	call onewireInit
.LVL69:
	cpi r24,lo8(1)
	breq .L23
	.loc 1 150 0
	mov r18,r15
	movw r20,r10
	movw r22,r28
	movw r24,r12
	call ds18b20match
.LVL70:
	.loc 1 153 0
	ldi r16,lo8(72)
.LVL71:
	mov r18,r15
	movw r20,r10
	movw r22,r28
	movw r24,r12
	call onewireWrite
.LVL72:
	.loc 1 157 0
	movw r30,r12
	ld r24,Z
	or r24,r15
	st Z,r24
	.loc 1 158 0
	ld r24,Y
	or r15,r24
.LVL73:
	st Y,r15
	.loc 1 160 0
	ldi r24,0
.L23:
/* epilogue start */
	.loc 1 161 0
	pop r29
	pop r28
.LVL74:
	pop r17
	pop r16
	pop r15
	pop r13
	pop r12
.LVL75:
	pop r11
	pop r10
.LVL76:
	ret
	.cfi_endproc
.LFE11:
	.size	ds18b20csp, .-ds18b20csp
	.section	.text.ds18b20read,"ax",@progbits
.global	ds18b20read
	.type	ds18b20read, @function
ds18b20read:
.LFB12:
	.loc 1 165 0
	.cfi_startproc
.LVL77:
	push r12
.LCFI54:
	.cfi_def_cfa_offset 3
	.cfi_offset 12, -2
	push r13
.LCFI55:
	.cfi_def_cfa_offset 4
	.cfi_offset 13, -3
	push r14
.LCFI56:
	.cfi_def_cfa_offset 5
	.cfi_offset 14, -4
	push r15
.LCFI57:
	.cfi_def_cfa_offset 6
	.cfi_offset 15, -5
	push r16
.LCFI58:
	.cfi_def_cfa_offset 7
	.cfi_offset 16, -6
	push r17
.LCFI59:
	.cfi_def_cfa_offset 8
	.cfi_offset 17, -7
	push r28
.LCFI60:
	.cfi_def_cfa_offset 9
	.cfi_offset 28, -8
	push r29
.LCFI61:
	.cfi_def_cfa_offset 10
	.cfi_offset 29, -9
	in r28,__SP_L__
	in r29,__SP_H__
.LCFI62:
	.cfi_def_cfa_register 28
	sbiw r28,9
.LCFI63:
	.cfi_def_cfa_offset 19
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
/* prologue: function */
/* frame size = 9 */
/* stack size = 17 */
.L__stack_usage = 17
	movw r12,r14
.LVL78:
	.loc 1 173 0
	movw r30,r28
	adiw r30,1
	movw r14,r30
.LVL79:
	call ds18b20rsp
.LVL80:
	.loc 1 175 0
	tst r24
	breq .L25
	.loc 1 177 0
	movw r30,r12
	std Z+1,__zero_reg__
	st Z,__zero_reg__
	.loc 1 178 0
	rjmp .L26
.L25:
	.loc 1 182 0
	ldd r24,Y+2
.LVL81:
	ldi r25,0
	mov r25,r24
	clr r24
	ldd r18,Y+1
	add r24,r18
	adc r25,__zero_reg__
	movw r30,r12
	std Z+1,r25
	st Z,r24
	.loc 1 184 0
	ldi r24,0
.L26:
/* epilogue start */
	.loc 1 185 0
	adiw r28,9
	in __tmp_reg__,__SREG__
	cli
	out __SP_H__,r29
	out __SREG__,__tmp_reg__
	out __SP_L__,r28
	pop r29
	pop r28
	pop r17
	pop r16
.LVL82:
	pop r15
	pop r14
	pop r13
	pop r12
.LVL83:
	ret
	.cfi_endproc
.LFE12:
	.size	ds18b20read, .-ds18b20read
	.section	.text.ds18b20rom,"ax",@progbits
.global	ds18b20rom
	.type	ds18b20rom, @function
ds18b20rom:
.LFB13:
	.loc 1 189 0
	.cfi_startproc
.LVL84:
	push r8
.LCFI64:
	.cfi_def_cfa_offset 3
	.cfi_offset 8, -2
	push r9
.LCFI65:
	.cfi_def_cfa_offset 4
	.cfi_offset 9, -3
	push r10
.LCFI66:
	.cfi_def_cfa_offset 5
	.cfi_offset 10, -4
	push r11
.LCFI67:
	.cfi_def_cfa_offset 6
	.cfi_offset 11, -5
	push r12
.LCFI68:
	.cfi_def_cfa_offset 7
	.cfi_offset 12, -6
	push r13
.LCFI69:
	.cfi_def_cfa_offset 8
	.cfi_offset 13, -7
	push r14
.LCFI70:
	.cfi_def_cfa_offset 9
	.cfi_offset 14, -8
	push r15
.LCFI71:
	.cfi_def_cfa_offset 10
	.cfi_offset 15, -9
	push r16
.LCFI72:
	.cfi_def_cfa_offset 11
	.cfi_offset 16, -10
	push r17
.LCFI73:
	.cfi_def_cfa_offset 12
	.cfi_offset 17, -11
	push r28
.LCFI74:
	.cfi_def_cfa_offset 13
	.cfi_offset 28, -12
	push r29
.LCFI75:
	.cfi_def_cfa_offset 14
	.cfi_offset 29, -13
/* prologue: function */
/* frame size = 0 */
/* stack size = 12 */
.L__stack_usage = 12
.LVL85:
	.loc 1 194 0
	cp r16,__zero_reg__
	cpc r17,__zero_reg__
	brne .+2
	rjmp .L33
	movw r14,r16
	mov r29,r18
	movw r8,r20
	movw r10,r22
	movw r12,r24
	.loc 1 197 0
	call onewireInit
.LVL86:
	cpi r24,lo8(1)
	brne .+2
	rjmp .L28
	.loc 1 201 0
	ldi r16,lo8(51)
.LVL87:
	mov r18,r29
	movw r20,r8
	movw r22,r10
	movw r24,r12
	call onewireWrite
.LVL88:
	.loc 1 202 0
	ldi r28,0
	rjmp .L29
.LVL89:
.L30:
	.loc 1 203 0 discriminator 3
	movw r16,r14
	add r16,r28
	adc r17,__zero_reg__
	mov r18,r29
	movw r20,r8
	movw r22,r10
	movw r24,r12
	call onewireRead
.LVL90:
	movw r30,r16
	st Z,r24
	.loc 1 202 0 discriminator 3
	subi r28,lo8(-(1))
.LVL91:
.L29:
	.loc 1 202 0 is_stmt 0 discriminator 1
	cpi r28,lo8(8)
	brlo .L30
	.loc 1 206 0 is_stmt 1
	movw r30,r14
	ld r22,Z
	ldd r24,Z+1
	ldd r21,Z+2
	ldd r20,Z+3
	ldd r19,Z+4
	ldd r18,Z+5
	ldd r25,Z+6
	ldd r28,Z+7
.LVL92:
	or r24,r22
	or r24,r21
	or r24,r20
	or r24,r19
	or r24,r18
	or r24,r25
	or r24,r28
	breq .L34
	.loc 1 209 0
	ldi r22,lo8(7)
	movw r24,r14
	call ds18b20crc8
.LVL93:
	cpse r28,r24
	rjmp .L35
	.loc 1 215 0
	ldi r24,0
	rjmp .L28
.LVL94:
.L32:
	.loc 1 211 0 discriminator 3
	movw r30,r14
	add r30,r24
	adc r31,__zero_reg__
	st Z,__zero_reg__
	subi r24,lo8(-(1))
.LVL95:
	rjmp .L31
.LVL96:
.L35:
	ldi r24,0
.L31:
.LVL97:
	.loc 1 211 0 is_stmt 0 discriminator 1
	cpi r24,lo8(8)
	brlo .L32
	.loc 1 212 0 is_stmt 1
	ldi r24,lo8(2)
.LVL98:
	rjmp .L28
.LVL99:
.L33:
	.loc 1 194 0
	ldi r24,lo8(4)
.LVL100:
	rjmp .L28
.LVL101:
.L34:
	.loc 1 206 0
	ldi r24,lo8(3)
.LVL102:
.L28:
/* epilogue start */
	.loc 1 216 0
	pop r29
	pop r28
	pop r17
	pop r16
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11
	pop r10
	pop r9
	pop r8
	ret
	.cfi_endproc
.LFE13:
	.size	ds18b20rom, .-ds18b20rom
	.text
.Letext0:
	.file 2 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\avr\\include\\stdint.h"
	.file 3 "../src/libraries/avr-ds80b20/onewire.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x9ff
	.word	0x2
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF777
	.byte	0xc
	.long	.LASF778
	.long	.LASF779
	.long	.Ldebug_ranges0+0
	.long	0
	.long	0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.byte	0x2
	.byte	0x5
	.string	"int"
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF748
	.uleb128 0x3
	.byte	0x1
	.byte	0x6
	.long	.LASF749
	.uleb128 0x4
	.long	.LASF751
	.byte	0x2
	.byte	0x7e
	.long	0x4d
	.uleb128 0x3
	.byte	0x1
	.byte	0x8
	.long	.LASF750
	.uleb128 0x4
	.long	.LASF752
	.byte	0x2
	.byte	0x7f
	.long	0x2d
	.uleb128 0x3
	.byte	0x4
	.byte	0x5
	.long	.LASF753
	.uleb128 0x3
	.byte	0x4
	.byte	0x7
	.long	.LASF754
	.uleb128 0x3
	.byte	0x8
	.byte	0x5
	.long	.LASF755
	.uleb128 0x3
	.byte	0x8
	.byte	0x7
	.long	.LASF756
	.uleb128 0x5
	.byte	0x1
	.long	.LASF764
	.byte	0x1
	.byte	0x14
	.byte	0x1
	.long	0x42
	.long	.LFB6
	.long	.LFE6
	.byte	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.byte	0x1
	.long	0xfd
	.uleb128 0x6
	.long	.LASF757
	.byte	0x1
	.byte	0x14
	.long	0xfd
	.long	.LLST0
	.uleb128 0x7
	.long	.LASF758
	.byte	0x1
	.byte	0x14
	.long	0x42
	.byte	0x1
	.byte	0x66
	.uleb128 0x8
	.string	"i"
	.byte	0x1
	.byte	0x18
	.long	0x42
	.long	.LLST1
	.uleb128 0x8
	.string	"j"
	.byte	0x1
	.byte	0x19
	.long	0x42
	.long	.LLST2
	.uleb128 0x8
	.string	"mix"
	.byte	0x1
	.byte	0x1a
	.long	0x42
	.long	.LLST3
	.uleb128 0x8
	.string	"crc"
	.byte	0x1
	.byte	0x1b
	.long	0x42
	.long	.LLST4
	.uleb128 0x9
	.long	.LASF759
	.byte	0x1
	.byte	0x1c
	.long	0x42
	.long	.LLST5
	.byte	0
	.uleb128 0xa
	.byte	0x2
	.long	0x42
	.uleb128 0xb
	.byte	0x1
	.long	.LASF780
	.byte	0x1
	.byte	0x2e
	.byte	0x1
	.long	.LFB7
	.long	.LFE7
	.long	.LLST6
	.byte	0x1
	.long	0x1fc
	.uleb128 0x6
	.long	.LASF760
	.byte	0x1
	.byte	0x2e
	.long	0x1fc
	.long	.LLST7
	.uleb128 0x6
	.long	.LASF761
	.byte	0x1
	.byte	0x2e
	.long	0x1fc
	.long	.LLST8
	.uleb128 0x6
	.long	.LASF762
	.byte	0x1
	.byte	0x2e
	.long	0x1fc
	.long	.LLST9
	.uleb128 0x6
	.long	.LASF763
	.byte	0x1
	.byte	0x2e
	.long	0x42
	.long	.LLST10
	.uleb128 0xc
	.string	"rom"
	.byte	0x1
	.byte	0x2e
	.long	0xfd
	.long	.LLST11
	.uleb128 0x8
	.string	"i"
	.byte	0x1
	.byte	0x33
	.long	0x42
	.long	.LLST12
	.uleb128 0xd
	.long	.LVL16
	.long	0x9db
	.long	0x1b0
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL18
	.long	0x9db
	.long	0x1c4
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xf
	.long	.LVL20
	.long	0x9db
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xa
	.byte	0x2
	.long	0x202
	.uleb128 0x10
	.long	0x42
	.uleb128 0x11
	.byte	0x1
	.long	.LASF765
	.byte	0x1
	.byte	0x45
	.byte	0x1
	.long	0x42
	.long	.LFB8
	.long	.LFE8
	.long	.LLST13
	.byte	0x1
	.long	0x31d
	.uleb128 0x6
	.long	.LASF760
	.byte	0x1
	.byte	0x45
	.long	0x1fc
	.long	.LLST14
	.uleb128 0x6
	.long	.LASF761
	.byte	0x1
	.byte	0x45
	.long	0x1fc
	.long	.LLST15
	.uleb128 0x6
	.long	.LASF762
	.byte	0x1
	.byte	0x45
	.long	0x1fc
	.long	.LLST16
	.uleb128 0x6
	.long	.LASF763
	.byte	0x1
	.byte	0x45
	.long	0x42
	.long	.LLST17
	.uleb128 0xc
	.string	"rom"
	.byte	0x1
	.byte	0x45
	.long	0xfd
	.long	.LLST18
	.uleb128 0xd
	.long	.LVL29
	.long	0x9e8
	.long	0x2a5
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7b
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL30
	.long	0x103
	.long	0x2e5
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7b
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xf
	.long	.LVL32
	.long	0x9db
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7b
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x11
	.byte	0x1
	.long	.LASF766
	.byte	0x1
	.byte	0x57
	.byte	0x1
	.long	0x42
	.long	.LFB9
	.long	.LFE9
	.long	.LLST19
	.byte	0x1
	.long	0x4a1
	.uleb128 0x6
	.long	.LASF760
	.byte	0x1
	.byte	0x57
	.long	0x1fc
	.long	.LLST20
	.uleb128 0x6
	.long	.LASF761
	.byte	0x1
	.byte	0x57
	.long	0x1fc
	.long	.LLST21
	.uleb128 0x6
	.long	.LASF762
	.byte	0x1
	.byte	0x57
	.long	0x1fc
	.long	.LLST22
	.uleb128 0x6
	.long	.LASF763
	.byte	0x1
	.byte	0x57
	.long	0x42
	.long	.LLST23
	.uleb128 0xc
	.string	"rom"
	.byte	0x1
	.byte	0x57
	.long	0xfd
	.long	.LLST24
	.uleb128 0xc
	.string	"sp"
	.byte	0x1
	.byte	0x57
	.long	0xfd
	.long	.LLST25
	.uleb128 0x8
	.string	"i"
	.byte	0x1
	.byte	0x5b
	.long	0x42
	.long	.LLST26
	.uleb128 0xd
	.long	.LVL39
	.long	0x9e8
	.long	0x3d6
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL40
	.long	0x103
	.long	0x416
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL42
	.long	0x9db
	.long	0x451
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL44
	.long	0x9f5
	.long	0x486
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.byte	0
	.uleb128 0xf
	.long	.LVL46
	.long	0x7b
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x66
	.byte	0x1
	.byte	0x38
	.byte	0
	.byte	0
	.uleb128 0x11
	.byte	0x1
	.long	.LASF767
	.byte	0x1
	.byte	0x75
	.byte	0x1
	.long	0x42
	.long	.LFB10
	.long	.LFE10
	.long	.LLST27
	.byte	0x1
	.long	0x693
	.uleb128 0x6
	.long	.LASF760
	.byte	0x1
	.byte	0x75
	.long	0x1fc
	.long	.LLST28
	.uleb128 0x6
	.long	.LASF761
	.byte	0x1
	.byte	0x75
	.long	0x1fc
	.long	.LLST29
	.uleb128 0x6
	.long	.LASF762
	.byte	0x1
	.byte	0x75
	.long	0x1fc
	.long	.LLST30
	.uleb128 0x6
	.long	.LASF763
	.byte	0x1
	.byte	0x75
	.long	0x42
	.long	.LLST31
	.uleb128 0xc
	.string	"rom"
	.byte	0x1
	.byte	0x75
	.long	0xfd
	.long	.LLST32
	.uleb128 0xc
	.string	"th"
	.byte	0x1
	.byte	0x75
	.long	0x42
	.long	.LLST33
	.uleb128 0xc
	.string	"tl"
	.byte	0x1
	.byte	0x75
	.long	0x42
	.long	.LLST34
	.uleb128 0x6
	.long	.LASF768
	.byte	0x1
	.byte	0x75
	.long	0x42
	.long	.LLST35
	.uleb128 0xd
	.long	.LVL54
	.long	0x9e8
	.long	0x56a
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL55
	.long	0x103
	.long	0x5aa
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL57
	.long	0x9db
	.long	0x5e5
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL58
	.long	0x9db
	.long	0x620
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL59
	.long	0x9db
	.long	0x65b
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.byte	0
	.uleb128 0xf
	.long	.LVL60
	.long	0x9db
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x76
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x11
	.byte	0x1
	.long	.LASF769
	.byte	0x1
	.byte	0x8d
	.byte	0x1
	.long	0x42
	.long	.LFB11
	.long	.LFE11
	.long	.LLST36
	.byte	0x1
	.long	0x7a9
	.uleb128 0x6
	.long	.LASF760
	.byte	0x1
	.byte	0x8d
	.long	0x1fc
	.long	.LLST37
	.uleb128 0x6
	.long	.LASF761
	.byte	0x1
	.byte	0x8d
	.long	0x1fc
	.long	.LLST38
	.uleb128 0x6
	.long	.LASF762
	.byte	0x1
	.byte	0x8d
	.long	0x1fc
	.long	.LLST39
	.uleb128 0x6
	.long	.LASF763
	.byte	0x1
	.byte	0x8d
	.long	0x42
	.long	.LLST40
	.uleb128 0xc
	.string	"rom"
	.byte	0x1
	.byte	0x8d
	.long	0xfd
	.long	.LLST41
	.uleb128 0xd
	.long	.LVL69
	.long	0x9e8
	.long	0x731
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL70
	.long	0x103
	.long	0x771
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xf
	.long	.LVL72
	.long	0x9db
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x8c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x7f
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0x11
	.byte	0x1
	.long	.LASF770
	.byte	0x1
	.byte	0xa4
	.byte	0x1
	.long	0x42
	.long	.LFB12
	.long	.LFE12
	.long	.LLST42
	.byte	0x1
	.long	0x888
	.uleb128 0x6
	.long	.LASF760
	.byte	0x1
	.byte	0xa4
	.long	0x1fc
	.long	.LLST43
	.uleb128 0x6
	.long	.LASF761
	.byte	0x1
	.byte	0xa4
	.long	0x1fc
	.long	.LLST44
	.uleb128 0x6
	.long	.LASF762
	.byte	0x1
	.byte	0xa4
	.long	0x1fc
	.long	.LLST45
	.uleb128 0x6
	.long	.LASF763
	.byte	0x1
	.byte	0xa4
	.long	0x42
	.long	.LLST46
	.uleb128 0xc
	.string	"rom"
	.byte	0x1
	.byte	0xa4
	.long	0xfd
	.long	.LLST47
	.uleb128 0x6
	.long	.LASF771
	.byte	0x1
	.byte	0xa4
	.long	0x888
	.long	.LLST48
	.uleb128 0x12
	.string	"sp"
	.byte	0x1
	.byte	0xa9
	.long	0x88e
	.byte	0x2
	.byte	0x8c
	.sleb128 1
	.uleb128 0x8
	.string	"ec"
	.byte	0x1
	.byte	0xaa
	.long	0x42
	.long	.LLST49
	.uleb128 0xf
	.long	.LVL80
	.long	0x31d
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x64
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x3
	.byte	0xf3
	.uleb128 0x1
	.byte	0x62
	.uleb128 0xe
	.byte	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x5e
	.byte	0x93
	.uleb128 0x1
	.byte	0x5f
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.byte	0
	.byte	0
	.uleb128 0xa
	.byte	0x2
	.long	0x54
	.uleb128 0x13
	.long	0x42
	.long	0x89e
	.uleb128 0x14
	.long	0x89e
	.byte	0x8
	.byte	0
	.uleb128 0x3
	.byte	0x2
	.byte	0x7
	.long	.LASF772
	.uleb128 0x11
	.byte	0x1
	.long	.LASF773
	.byte	0x1
	.byte	0xbc
	.byte	0x1
	.long	0x42
	.long	.LFB13
	.long	.LFE13
	.long	.LLST50
	.byte	0x1
	.long	0x9db
	.uleb128 0x6
	.long	.LASF760
	.byte	0x1
	.byte	0xbc
	.long	0x1fc
	.long	.LLST51
	.uleb128 0x6
	.long	.LASF761
	.byte	0x1
	.byte	0xbc
	.long	0x1fc
	.long	.LLST52
	.uleb128 0x6
	.long	.LASF762
	.byte	0x1
	.byte	0xbc
	.long	0x1fc
	.long	.LLST53
	.uleb128 0x6
	.long	.LASF763
	.byte	0x1
	.byte	0xbc
	.long	0x42
	.long	.LLST54
	.uleb128 0xc
	.string	"rom"
	.byte	0x1
	.byte	0xbc
	.long	0xfd
	.long	.LLST55
	.uleb128 0x8
	.string	"i"
	.byte	0x1
	.byte	0xc0
	.long	0x4d
	.long	.LLST56
	.uleb128 0xd
	.long	.LVL86
	.long	0x9e8
	.long	0x950
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL88
	.long	0x9db
	.long	0x98b
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x60
	.byte	0x2
	.byte	0x80
	.sleb128 0
	.byte	0
	.uleb128 0xd
	.long	.LVL90
	.long	0x9f5
	.long	0x9c0
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7c
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7a
	.sleb128 0
	.uleb128 0xe
	.byte	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x78
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x62
	.byte	0x2
	.byte	0x8d
	.sleb128 0
	.byte	0
	.uleb128 0xf
	.long	.LVL93
	.long	0x7b
	.uleb128 0xe
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0x2
	.byte	0x7e
	.sleb128 0
	.uleb128 0xe
	.byte	0x1
	.byte	0x66
	.byte	0x1
	.byte	0x37
	.byte	0
	.byte	0
	.uleb128 0x15
	.byte	0x1
	.byte	0x1
	.long	.LASF774
	.long	.LASF774
	.byte	0x3
	.byte	0x38
	.uleb128 0x15
	.byte	0x1
	.byte	0x1
	.long	.LASF775
	.long	.LASF775
	.byte	0x3
	.byte	0x23
	.uleb128 0x15
	.byte	0x1
	.byte	0x1
	.long	.LASF776
	.long	.LASF776
	.byte	0x3
	.byte	0x4c
	.byte	0
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1
	.uleb128 0x11
	.byte	0x1
	.uleb128 0x25
	.uleb128 0xe
	.uleb128 0x13
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x1b
	.uleb128 0xe
	.uleb128 0x55
	.uleb128 0x6
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x52
	.uleb128 0x1
	.uleb128 0x10
	.uleb128 0x6
	.uleb128 0x2119
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x2
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0x24
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3e
	.uleb128 0xb
	.uleb128 0x3
	.uleb128 0xe
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0x16
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x5
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0xa
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x6
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x8
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0x9
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0xa
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xb
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
	.uleb128 0x5
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0x6
	.byte	0
	.byte	0
	.uleb128 0xd
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xe
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0xa
	.uleb128 0x2111
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0xf
	.uleb128 0x4109
	.byte	0x1
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x10
	.uleb128 0x35
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x11
	.uleb128 0x2e
	.byte	0x1
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x27
	.uleb128 0xc
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x12
	.uleb128 0x1
	.uleb128 0x40
	.uleb128 0x6
	.uleb128 0x2117
	.uleb128 0xc
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x12
	.uleb128 0x34
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x13
	.uleb128 0x1
	.byte	0x1
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x14
	.uleb128 0x21
	.byte	0
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x2f
	.uleb128 0xb
	.byte	0
	.byte	0
	.uleb128 0x15
	.uleb128 0x2e
	.byte	0
	.uleb128 0x3f
	.uleb128 0xc
	.uleb128 0x3c
	.uleb128 0xc
	.uleb128 0x2007
	.uleb128 0xe
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST0:
	.long	.LVL0
	.long	.LVL2
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL2
	.long	.LFE6
	.word	0x6
	.byte	0x6a
	.byte	0x93
	.uleb128 0x1
	.byte	0x6b
	.byte	0x93
	.uleb128 0x1
	.long	0
	.long	0
.LLST1:
	.long	.LVL1
	.long	.LVL3
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL3
	.long	.LFE6
	.word	0x1
	.byte	0x64
	.long	0
	.long	0
.LLST2:
	.long	.LVL1
	.long	.LVL3
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL4
	.long	.LVL5
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL5
	.long	.LVL12
	.word	0x1
	.byte	0x69
	.long	0
	.long	0
.LLST3:
	.long	.LVL1
	.long	.LVL3
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL6
	.long	.LVL8
	.word	0x5
	.byte	0x83
	.sleb128 0
	.byte	0x31
	.byte	0x1a
	.byte	0x9f
	.long	0
	.long	0
.LLST4:
	.long	.LVL1
	.long	.LVL3
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL3
	.long	.LFE6
	.word	0x1
	.byte	0x68
	.long	0
	.long	0
.LLST5:
	.long	.LVL1
	.long	.LVL3
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL4
	.long	.LVL12
	.word	0x1
	.byte	0x62
	.long	0
	.long	0
.LLST6:
	.long	.LFB7
	.long	.LCFI0
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.long	.LCFI0
	.long	.LCFI1
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 3
	.long	.LCFI1
	.long	.LCFI2
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 4
	.long	.LCFI2
	.long	.LCFI3
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 5
	.long	.LCFI3
	.long	.LCFI4
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 6
	.long	.LCFI4
	.long	.LCFI5
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 7
	.long	.LCFI5
	.long	.LCFI6
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 8
	.long	.LCFI6
	.long	.LCFI7
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 9
	.long	.LCFI7
	.long	.LCFI8
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 10
	.long	.LCFI8
	.long	.LCFI9
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 11
	.long	.LCFI9
	.long	.LCFI10
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 12
	.long	.LCFI10
	.long	.LCFI11
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 13
	.long	.LCFI11
	.long	.LFE7
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 14
	.long	0
	.long	0
.LLST7:
	.long	.LVL13
	.long	.LVL16-1
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL16-1
	.long	.LVL24
	.word	0x6
	.byte	0x5e
	.byte	0x93
	.uleb128 0x1
	.byte	0x5f
	.byte	0x93
	.uleb128 0x1
	.long	.LVL24
	.long	.LFE7
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.byte	0x9f
	.long	0
	.long	0
.LLST8:
	.long	.LVL13
	.long	.LVL16-1
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL16-1
	.long	.LVL25
	.word	0x6
	.byte	0x5c
	.byte	0x93
	.uleb128 0x1
	.byte	0x5d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL25
	.long	.LFE7
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.byte	0x9f
	.long	0
	.long	0
.LLST9:
	.long	.LVL13
	.long	.LVL16-1
	.word	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.long	.LVL16-1
	.long	.LVL26
	.word	0x6
	.byte	0x5a
	.byte	0x93
	.uleb128 0x1
	.byte	0x5b
	.byte	0x93
	.uleb128 0x1
	.long	.LVL26
	.long	.LFE7
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x64
	.byte	0x9f
	.long	0
	.long	0
.LLST10:
	.long	.LVL13
	.long	.LVL16-1
	.word	0x1
	.byte	0x62
	.long	.LVL16-1
	.long	.LVL17
	.word	0x1
	.byte	0x6d
	.long	.LVL17
	.long	.LVL18-1
	.word	0x1
	.byte	0x62
	.long	.LVL18-1
	.long	.LVL23
	.word	0x1
	.byte	0x6d
	.long	.LVL23
	.long	.LFE7
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x62
	.byte	0x9f
	.long	0
	.long	0
.LLST11:
	.long	.LVL13
	.long	.LVL15
	.word	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.long	.LVL15
	.long	.LVL27
	.word	0x6
	.byte	0x58
	.byte	0x93
	.uleb128 0x1
	.byte	0x59
	.byte	0x93
	.uleb128 0x1
	.long	.LVL27
	.long	.LFE7
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x60
	.byte	0x9f
	.long	0
	.long	0
.LLST12:
	.long	.LVL14
	.long	.LVL19
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL19
	.long	.LVL22
	.word	0x1
	.byte	0x6c
	.long	0
	.long	0
.LLST13:
	.long	.LFB8
	.long	.LCFI12
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.long	.LCFI12
	.long	.LCFI13
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 3
	.long	.LCFI13
	.long	.LCFI14
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 4
	.long	.LCFI14
	.long	.LCFI15
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 5
	.long	.LCFI15
	.long	.LCFI16
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 6
	.long	.LCFI16
	.long	.LCFI17
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 7
	.long	.LCFI17
	.long	.LCFI18
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 8
	.long	.LCFI18
	.long	.LCFI19
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 9
	.long	.LCFI19
	.long	.LCFI20
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 10
	.long	.LCFI20
	.long	.LFE8
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 11
	.long	0
	.long	0
.LLST14:
	.long	.LVL28
	.long	.LVL29-1
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL29-1
	.long	.LVL33
	.word	0x6
	.byte	0x6c
	.byte	0x93
	.uleb128 0x1
	.byte	0x6d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL33
	.long	.LFE8
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.byte	0x9f
	.long	0
	.long	0
.LLST15:
	.long	.LVL28
	.long	.LVL29-1
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL29-1
	.long	.LVL34
	.word	0x6
	.byte	0x5e
	.byte	0x93
	.uleb128 0x1
	.byte	0x5f
	.byte	0x93
	.uleb128 0x1
	.long	.LVL34
	.long	.LFE8
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.byte	0x9f
	.long	0
	.long	0
.LLST16:
	.long	.LVL28
	.long	.LVL29-1
	.word	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.long	.LVL29-1
	.long	.LVL35
	.word	0x6
	.byte	0x5c
	.byte	0x93
	.uleb128 0x1
	.byte	0x5d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL35
	.long	.LFE8
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x64
	.byte	0x9f
	.long	0
	.long	0
.LLST17:
	.long	.LVL28
	.long	.LVL29-1
	.word	0x1
	.byte	0x62
	.long	.LVL29-1
	.long	.LVL36
	.word	0x1
	.byte	0x5b
	.long	.LVL36
	.long	.LFE8
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x62
	.byte	0x9f
	.long	0
	.long	0
.LLST18:
	.long	.LVL28
	.long	.LVL31
	.word	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.long	.LVL31
	.long	.LFE8
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x60
	.byte	0x9f
	.long	0
	.long	0
.LLST19:
	.long	.LFB9
	.long	.LCFI21
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.long	.LCFI21
	.long	.LCFI22
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 3
	.long	.LCFI22
	.long	.LCFI23
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 4
	.long	.LCFI23
	.long	.LCFI24
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 5
	.long	.LCFI24
	.long	.LCFI25
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 6
	.long	.LCFI25
	.long	.LCFI26
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 7
	.long	.LCFI26
	.long	.LCFI27
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 8
	.long	.LCFI27
	.long	.LCFI28
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 9
	.long	.LCFI28
	.long	.LCFI29
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 10
	.long	.LCFI29
	.long	.LCFI30
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 11
	.long	.LCFI30
	.long	.LCFI31
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 12
	.long	.LCFI31
	.long	.LCFI32
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 13
	.long	.LCFI32
	.long	.LFE9
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 14
	.long	0
	.long	0
.LLST20:
	.long	.LVL37
	.long	.LVL39-1
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL39-1
	.long	.LVL50
	.word	0x6
	.byte	0x5c
	.byte	0x93
	.uleb128 0x1
	.byte	0x5d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL50
	.long	.LFE9
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.byte	0x9f
	.long	0
	.long	0
.LLST21:
	.long	.LVL37
	.long	.LVL39-1
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL39-1
	.long	.LVL51
	.word	0x6
	.byte	0x5a
	.byte	0x93
	.uleb128 0x1
	.byte	0x5b
	.byte	0x93
	.uleb128 0x1
	.long	.LVL51
	.long	.LFE9
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.byte	0x9f
	.long	0
	.long	0
.LLST22:
	.long	.LVL37
	.long	.LVL39-1
	.word	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.long	.LVL39-1
	.long	.LVL52
	.word	0x6
	.byte	0x58
	.byte	0x93
	.uleb128 0x1
	.byte	0x59
	.byte	0x93
	.uleb128 0x1
	.long	.LVL52
	.long	.LFE9
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x64
	.byte	0x9f
	.long	0
	.long	0
.LLST23:
	.long	.LVL37
	.long	.LVL39-1
	.word	0x1
	.byte	0x62
	.long	.LVL39-1
	.long	.LVL48
	.word	0x1
	.byte	0x6d
	.long	.LVL48
	.long	.LFE9
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x62
	.byte	0x9f
	.long	0
	.long	0
.LLST24:
	.long	.LVL37
	.long	.LVL41
	.word	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.long	.LVL41
	.long	.LFE9
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x60
	.byte	0x9f
	.long	0
	.long	0
.LLST25:
	.long	.LVL37
	.long	.LVL49
	.word	0x6
	.byte	0x5e
	.byte	0x93
	.uleb128 0x1
	.byte	0x5f
	.byte	0x93
	.uleb128 0x1
	.long	.LVL49
	.long	.LFE9
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x5e
	.byte	0x9f
	.long	0
	.long	0
.LLST26:
	.long	.LVL38
	.long	.LVL43
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL43
	.long	.LVL47
	.word	0x1
	.byte	0x6c
	.long	0
	.long	0
.LLST27:
	.long	.LFB10
	.long	.LCFI33
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.long	.LCFI33
	.long	.LCFI34
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 3
	.long	.LCFI34
	.long	.LCFI35
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 4
	.long	.LCFI35
	.long	.LCFI36
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 5
	.long	.LCFI36
	.long	.LCFI37
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 6
	.long	.LCFI37
	.long	.LCFI38
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 7
	.long	.LCFI38
	.long	.LCFI39
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 8
	.long	.LCFI39
	.long	.LCFI40
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 9
	.long	.LCFI40
	.long	.LCFI41
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 10
	.long	.LCFI41
	.long	.LCFI42
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 11
	.long	.LCFI42
	.long	.LCFI43
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 12
	.long	.LCFI43
	.long	.LCFI44
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 13
	.long	.LCFI44
	.long	.LFE10
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 14
	.long	0
	.long	0
.LLST28:
	.long	.LVL53
	.long	.LVL54-1
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL54-1
	.long	.LVL61
	.word	0x6
	.byte	0x6c
	.byte	0x93
	.uleb128 0x1
	.byte	0x6d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL61
	.long	.LFE10
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.byte	0x9f
	.long	0
	.long	0
.LLST29:
	.long	.LVL53
	.long	.LVL54-1
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL54-1
	.long	.LVL66
	.word	0x6
	.byte	0x58
	.byte	0x93
	.uleb128 0x1
	.byte	0x59
	.byte	0x93
	.uleb128 0x1
	.long	.LVL66
	.long	.LFE10
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.byte	0x9f
	.long	0
	.long	0
.LLST30:
	.long	.LVL53
	.long	.LVL54-1
	.word	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.long	.LVL54-1
	.long	.LVL67
	.word	0x6
	.byte	0x56
	.byte	0x93
	.uleb128 0x1
	.byte	0x57
	.byte	0x93
	.uleb128 0x1
	.long	.LVL67
	.long	.LFE10
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x64
	.byte	0x9f
	.long	0
	.long	0
.LLST31:
	.long	.LVL53
	.long	.LVL54-1
	.word	0x1
	.byte	0x62
	.long	.LVL54-1
	.long	.LVL62
	.word	0x1
	.byte	0x5f
	.long	.LVL62
	.long	.LFE10
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x62
	.byte	0x9f
	.long	0
	.long	0
.LLST32:
	.long	.LVL53
	.long	.LVL56
	.word	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.long	.LVL56
	.long	.LFE10
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x60
	.byte	0x9f
	.long	0
	.long	0
.LLST33:
	.long	.LVL53
	.long	.LVL63
	.word	0x1
	.byte	0x5e
	.long	.LVL63
	.long	.LFE10
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x5e
	.byte	0x9f
	.long	0
	.long	0
.LLST34:
	.long	.LVL53
	.long	.LVL64
	.word	0x1
	.byte	0x5c
	.long	.LVL64
	.long	.LFE10
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x5c
	.byte	0x9f
	.long	0
	.long	0
.LLST35:
	.long	.LVL53
	.long	.LVL65
	.word	0x1
	.byte	0x5a
	.long	.LVL65
	.long	.LFE10
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x5a
	.byte	0x9f
	.long	0
	.long	0
.LLST36:
	.long	.LFB11
	.long	.LCFI45
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.long	.LCFI45
	.long	.LCFI46
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 3
	.long	.LCFI46
	.long	.LCFI47
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 4
	.long	.LCFI47
	.long	.LCFI48
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 5
	.long	.LCFI48
	.long	.LCFI49
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 6
	.long	.LCFI49
	.long	.LCFI50
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 7
	.long	.LCFI50
	.long	.LCFI51
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 8
	.long	.LCFI51
	.long	.LCFI52
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 9
	.long	.LCFI52
	.long	.LCFI53
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 10
	.long	.LCFI53
	.long	.LFE11
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 11
	.long	0
	.long	0
.LLST37:
	.long	.LVL68
	.long	.LVL69-1
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL69-1
	.long	.LVL75
	.word	0x6
	.byte	0x5c
	.byte	0x93
	.uleb128 0x1
	.byte	0x5d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL75
	.long	.LFE11
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.byte	0x9f
	.long	0
	.long	0
.LLST38:
	.long	.LVL68
	.long	.LVL69-1
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL69-1
	.long	.LVL74
	.word	0x6
	.byte	0x6c
	.byte	0x93
	.uleb128 0x1
	.byte	0x6d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL74
	.long	.LFE11
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.byte	0x9f
	.long	0
	.long	0
.LLST39:
	.long	.LVL68
	.long	.LVL69-1
	.word	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.long	.LVL69-1
	.long	.LVL76
	.word	0x6
	.byte	0x5a
	.byte	0x93
	.uleb128 0x1
	.byte	0x5b
	.byte	0x93
	.uleb128 0x1
	.long	.LVL76
	.long	.LFE11
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x64
	.byte	0x9f
	.long	0
	.long	0
.LLST40:
	.long	.LVL68
	.long	.LVL69-1
	.word	0x1
	.byte	0x62
	.long	.LVL69-1
	.long	.LVL73
	.word	0x1
	.byte	0x5f
	.long	.LVL73
	.long	.LFE11
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x62
	.byte	0x9f
	.long	0
	.long	0
.LLST41:
	.long	.LVL68
	.long	.LVL71
	.word	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.long	.LVL71
	.long	.LFE11
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x60
	.byte	0x9f
	.long	0
	.long	0
.LLST42:
	.long	.LFB12
	.long	.LCFI54
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.long	.LCFI54
	.long	.LCFI55
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 3
	.long	.LCFI55
	.long	.LCFI56
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 4
	.long	.LCFI56
	.long	.LCFI57
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 5
	.long	.LCFI57
	.long	.LCFI58
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 6
	.long	.LCFI58
	.long	.LCFI59
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 7
	.long	.LCFI59
	.long	.LCFI60
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 8
	.long	.LCFI60
	.long	.LCFI61
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 9
	.long	.LCFI61
	.long	.LCFI62
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 10
	.long	.LCFI62
	.long	.LCFI63
	.word	0x2
	.byte	0x8c
	.sleb128 10
	.long	.LCFI63
	.long	.LFE12
	.word	0x2
	.byte	0x8c
	.sleb128 19
	.long	0
	.long	0
.LLST43:
	.long	.LVL77
	.long	.LVL80-1
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL80-1
	.long	.LFE12
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.byte	0x9f
	.long	0
	.long	0
.LLST44:
	.long	.LVL77
	.long	.LVL80-1
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL80-1
	.long	.LFE12
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.byte	0x9f
	.long	0
	.long	0
.LLST45:
	.long	.LVL77
	.long	.LVL80-1
	.word	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.long	.LVL80-1
	.long	.LFE12
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x64
	.byte	0x9f
	.long	0
	.long	0
.LLST46:
	.long	.LVL77
	.long	.LVL80-1
	.word	0x1
	.byte	0x62
	.long	.LVL80-1
	.long	.LFE12
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x62
	.byte	0x9f
	.long	0
	.long	0
.LLST47:
	.long	.LVL77
	.long	.LVL82
	.word	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.long	.LVL82
	.long	.LFE12
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x60
	.byte	0x9f
	.long	0
	.long	0
.LLST48:
	.long	.LVL77
	.long	.LVL79
	.word	0x6
	.byte	0x5e
	.byte	0x93
	.uleb128 0x1
	.byte	0x5f
	.byte	0x93
	.uleb128 0x1
	.long	.LVL79
	.long	.LVL83
	.word	0x6
	.byte	0x5c
	.byte	0x93
	.uleb128 0x1
	.byte	0x5d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL83
	.long	.LFE12
	.word	0x6
	.byte	0x6e
	.byte	0x93
	.uleb128 0x1
	.byte	0x6f
	.byte	0x93
	.uleb128 0x1
	.long	0
	.long	0
.LLST49:
	.long	.LVL78
	.long	.LVL80
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL80
	.long	.LVL81
	.word	0x1
	.byte	0x68
	.long	0
	.long	0
.LLST50:
	.long	.LFB13
	.long	.LCFI64
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.long	.LCFI64
	.long	.LCFI65
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 3
	.long	.LCFI65
	.long	.LCFI66
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 4
	.long	.LCFI66
	.long	.LCFI67
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 5
	.long	.LCFI67
	.long	.LCFI68
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 6
	.long	.LCFI68
	.long	.LCFI69
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 7
	.long	.LCFI69
	.long	.LCFI70
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 8
	.long	.LCFI70
	.long	.LCFI71
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 9
	.long	.LCFI71
	.long	.LCFI72
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 10
	.long	.LCFI72
	.long	.LCFI73
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 11
	.long	.LCFI73
	.long	.LCFI74
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 12
	.long	.LCFI74
	.long	.LCFI75
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 13
	.long	.LCFI75
	.long	.LFE13
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 14
	.long	0
	.long	0
.LLST51:
	.long	.LVL84
	.long	.LVL86-1
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL86-1
	.long	.LVL99
	.word	0x6
	.byte	0x5c
	.byte	0x93
	.uleb128 0x1
	.byte	0x5d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL99
	.long	.LVL100
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL100
	.long	.LVL101
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.byte	0x9f
	.long	.LVL101
	.long	.LVL102
	.word	0x6
	.byte	0x5c
	.byte	0x93
	.uleb128 0x1
	.byte	0x5d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL102
	.long	.LFE13
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x68
	.byte	0x9f
	.long	0
	.long	0
.LLST52:
	.long	.LVL84
	.long	.LVL86-1
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL86-1
	.long	.LVL99
	.word	0x6
	.byte	0x5a
	.byte	0x93
	.uleb128 0x1
	.byte	0x5b
	.byte	0x93
	.uleb128 0x1
	.long	.LVL99
	.long	.LVL101
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL101
	.long	.LVL102
	.word	0x6
	.byte	0x5a
	.byte	0x93
	.uleb128 0x1
	.byte	0x5b
	.byte	0x93
	.uleb128 0x1
	.long	.LVL102
	.long	.LFE13
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.byte	0x9f
	.long	0
	.long	0
.LLST53:
	.long	.LVL84
	.long	.LVL86-1
	.word	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.long	.LVL86-1
	.long	.LVL99
	.word	0x6
	.byte	0x58
	.byte	0x93
	.uleb128 0x1
	.byte	0x59
	.byte	0x93
	.uleb128 0x1
	.long	.LVL99
	.long	.LVL101
	.word	0x6
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.long	.LVL101
	.long	.LVL102
	.word	0x6
	.byte	0x58
	.byte	0x93
	.uleb128 0x1
	.byte	0x59
	.byte	0x93
	.uleb128 0x1
	.long	.LVL102
	.long	.LFE13
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x64
	.byte	0x9f
	.long	0
	.long	0
.LLST54:
	.long	.LVL84
	.long	.LVL86-1
	.word	0x1
	.byte	0x62
	.long	.LVL86-1
	.long	.LVL99
	.word	0x1
	.byte	0x6d
	.long	.LVL99
	.long	.LVL101
	.word	0x1
	.byte	0x62
	.long	.LVL101
	.long	.LVL102
	.word	0x1
	.byte	0x6d
	.long	.LVL102
	.long	.LFE13
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x62
	.byte	0x9f
	.long	0
	.long	0
.LLST55:
	.long	.LVL84
	.long	.LVL87
	.word	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.long	.LVL87
	.long	.LVL99
	.word	0x6
	.byte	0x5e
	.byte	0x93
	.uleb128 0x1
	.byte	0x5f
	.byte	0x93
	.uleb128 0x1
	.long	.LVL99
	.long	.LVL101
	.word	0x6
	.byte	0x60
	.byte	0x93
	.uleb128 0x1
	.byte	0x61
	.byte	0x93
	.uleb128 0x1
	.long	.LVL101
	.long	.LVL102
	.word	0x6
	.byte	0x5e
	.byte	0x93
	.uleb128 0x1
	.byte	0x5f
	.byte	0x93
	.uleb128 0x1
	.long	.LVL102
	.long	.LFE13
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x60
	.byte	0x9f
	.long	0
	.long	0
.LLST56:
	.long	.LVL85
	.long	.LVL89
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	.LVL89
	.long	.LVL92
	.word	0x1
	.byte	0x6c
	.long	.LVL94
	.long	.LVL96
	.word	0x1
	.byte	0x68
	.long	.LVL97
	.long	.LVL98
	.word	0x1
	.byte	0x68
	.long	.LVL99
	.long	.LVL101
	.word	0x2
	.byte	0x30
	.byte	0x9f
	.long	0
	.long	0
	.section	.debug_aranges,"",@progbits
	.long	0x54
	.word	0x2
	.long	.Ldebug_info0
	.byte	0x4
	.byte	0
	.word	0
	.word	0
	.long	.LFB6
	.long	.LFE6-.LFB6
	.long	.LFB7
	.long	.LFE7-.LFB7
	.long	.LFB8
	.long	.LFE8-.LFB8
	.long	.LFB9
	.long	.LFE9-.LFB9
	.long	.LFB10
	.long	.LFE10-.LFB10
	.long	.LFB11
	.long	.LFE11-.LFB11
	.long	.LFB12
	.long	.LFE12-.LFB12
	.long	.LFB13
	.long	.LFE13-.LFB13
	.long	0
	.long	0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.long	.LFB6
	.long	.LFE6
	.long	.LFB7
	.long	.LFE7
	.long	.LFB8
	.long	.LFE8
	.long	.LFB9
	.long	.LFE9
	.long	.LFB10
	.long	.LFE10
	.long	.LFB11
	.long	.LFE11
	.long	.LFB12
	.long	.LFE12
	.long	.LFB13
	.long	.LFE13
	.long	0
	.long	0
	.section	.debug_macro,"",@progbits
.Ldebug_macro0:
	.word	0x4
	.byte	0x2
	.long	.Ldebug_line0
	.byte	0x3
	.uleb128 0
	.uleb128 0x1
	.byte	0x5
	.uleb128 0x1
	.long	.LASF0
	.byte	0x5
	.uleb128 0x2
	.long	.LASF1
	.byte	0x5
	.uleb128 0x3
	.long	.LASF2
	.byte	0x5
	.uleb128 0x4
	.long	.LASF3
	.byte	0x5
	.uleb128 0x5
	.long	.LASF4
	.byte	0x5
	.uleb128 0x6
	.long	.LASF5
	.byte	0x5
	.uleb128 0x7
	.long	.LASF6
	.byte	0x5
	.uleb128 0x8
	.long	.LASF7
	.byte	0x5
	.uleb128 0x9
	.long	.LASF8
	.byte	0x5
	.uleb128 0xa
	.long	.LASF9
	.byte	0x5
	.uleb128 0xb
	.long	.LASF10
	.byte	0x5
	.uleb128 0xc
	.long	.LASF11
	.byte	0x5
	.uleb128 0xd
	.long	.LASF12
	.byte	0x5
	.uleb128 0xe
	.long	.LASF13
	.byte	0x5
	.uleb128 0xf
	.long	.LASF14
	.byte	0x5
	.uleb128 0x10
	.long	.LASF15
	.byte	0x5
	.uleb128 0x11
	.long	.LASF16
	.byte	0x5
	.uleb128 0x12
	.long	.LASF17
	.byte	0x5
	.uleb128 0x13
	.long	.LASF18
	.byte	0x5
	.uleb128 0x14
	.long	.LASF19
	.byte	0x5
	.uleb128 0x15
	.long	.LASF20
	.byte	0x5
	.uleb128 0x16
	.long	.LASF21
	.byte	0x5
	.uleb128 0x17
	.long	.LASF22
	.byte	0x5
	.uleb128 0x18
	.long	.LASF23
	.byte	0x5
	.uleb128 0x19
	.long	.LASF24
	.byte	0x5
	.uleb128 0x1a
	.long	.LASF25
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF26
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF27
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF28
	.byte	0x5
	.uleb128 0x1e
	.long	.LASF29
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF30
	.byte	0x5
	.uleb128 0x20
	.long	.LASF31
	.byte	0x5
	.uleb128 0x21
	.long	.LASF32
	.byte	0x5
	.uleb128 0x22
	.long	.LASF33
	.byte	0x5
	.uleb128 0x23
	.long	.LASF34
	.byte	0x5
	.uleb128 0x24
	.long	.LASF35
	.byte	0x5
	.uleb128 0x25
	.long	.LASF36
	.byte	0x5
	.uleb128 0x26
	.long	.LASF37
	.byte	0x5
	.uleb128 0x27
	.long	.LASF38
	.byte	0x5
	.uleb128 0x28
	.long	.LASF39
	.byte	0x5
	.uleb128 0x29
	.long	.LASF40
	.byte	0x5
	.uleb128 0x2a
	.long	.LASF41
	.byte	0x5
	.uleb128 0x2b
	.long	.LASF42
	.byte	0x5
	.uleb128 0x2c
	.long	.LASF43
	.byte	0x5
	.uleb128 0x2d
	.long	.LASF44
	.byte	0x5
	.uleb128 0x2e
	.long	.LASF45
	.byte	0x5
	.uleb128 0x2f
	.long	.LASF46
	.byte	0x5
	.uleb128 0x30
	.long	.LASF47
	.byte	0x5
	.uleb128 0x31
	.long	.LASF48
	.byte	0x5
	.uleb128 0x32
	.long	.LASF49
	.byte	0x5
	.uleb128 0x33
	.long	.LASF50
	.byte	0x5
	.uleb128 0x34
	.long	.LASF51
	.byte	0x5
	.uleb128 0x35
	.long	.LASF52
	.byte	0x5
	.uleb128 0x36
	.long	.LASF53
	.byte	0x5
	.uleb128 0x37
	.long	.LASF54
	.byte	0x5
	.uleb128 0x38
	.long	.LASF55
	.byte	0x5
	.uleb128 0x39
	.long	.LASF56
	.byte	0x5
	.uleb128 0x3a
	.long	.LASF57
	.byte	0x5
	.uleb128 0x3b
	.long	.LASF58
	.byte	0x5
	.uleb128 0x3c
	.long	.LASF59
	.byte	0x5
	.uleb128 0x3d
	.long	.LASF60
	.byte	0x5
	.uleb128 0x3e
	.long	.LASF61
	.byte	0x5
	.uleb128 0x3f
	.long	.LASF62
	.byte	0x5
	.uleb128 0x40
	.long	.LASF63
	.byte	0x5
	.uleb128 0x41
	.long	.LASF64
	.byte	0x5
	.uleb128 0x42
	.long	.LASF65
	.byte	0x5
	.uleb128 0x43
	.long	.LASF66
	.byte	0x5
	.uleb128 0x44
	.long	.LASF67
	.byte	0x5
	.uleb128 0x45
	.long	.LASF68
	.byte	0x5
	.uleb128 0x46
	.long	.LASF69
	.byte	0x5
	.uleb128 0x47
	.long	.LASF70
	.byte	0x5
	.uleb128 0x48
	.long	.LASF71
	.byte	0x5
	.uleb128 0x49
	.long	.LASF72
	.byte	0x5
	.uleb128 0x4a
	.long	.LASF73
	.byte	0x5
	.uleb128 0x4b
	.long	.LASF74
	.byte	0x5
	.uleb128 0x4c
	.long	.LASF75
	.byte	0x5
	.uleb128 0x4d
	.long	.LASF76
	.byte	0x5
	.uleb128 0x4e
	.long	.LASF77
	.byte	0x5
	.uleb128 0x4f
	.long	.LASF78
	.byte	0x5
	.uleb128 0x50
	.long	.LASF79
	.byte	0x5
	.uleb128 0x51
	.long	.LASF80
	.byte	0x5
	.uleb128 0x52
	.long	.LASF81
	.byte	0x5
	.uleb128 0x53
	.long	.LASF82
	.byte	0x5
	.uleb128 0x54
	.long	.LASF83
	.byte	0x5
	.uleb128 0x55
	.long	.LASF84
	.byte	0x5
	.uleb128 0x56
	.long	.LASF85
	.byte	0x5
	.uleb128 0x57
	.long	.LASF86
	.byte	0x5
	.uleb128 0x58
	.long	.LASF87
	.byte	0x5
	.uleb128 0x59
	.long	.LASF88
	.byte	0x5
	.uleb128 0x5a
	.long	.LASF89
	.byte	0x5
	.uleb128 0x5b
	.long	.LASF90
	.byte	0x5
	.uleb128 0x5c
	.long	.LASF91
	.byte	0x5
	.uleb128 0x5d
	.long	.LASF92
	.byte	0x5
	.uleb128 0x5e
	.long	.LASF93
	.byte	0x5
	.uleb128 0x5f
	.long	.LASF94
	.byte	0x5
	.uleb128 0x60
	.long	.LASF95
	.byte	0x5
	.uleb128 0x61
	.long	.LASF96
	.byte	0x5
	.uleb128 0x62
	.long	.LASF97
	.byte	0x5
	.uleb128 0x63
	.long	.LASF98
	.byte	0x5
	.uleb128 0x64
	.long	.LASF99
	.byte	0x5
	.uleb128 0x65
	.long	.LASF100
	.byte	0x5
	.uleb128 0x66
	.long	.LASF101
	.byte	0x5
	.uleb128 0x67
	.long	.LASF102
	.byte	0x5
	.uleb128 0x68
	.long	.LASF103
	.byte	0x5
	.uleb128 0x69
	.long	.LASF104
	.byte	0x5
	.uleb128 0x6a
	.long	.LASF105
	.byte	0x5
	.uleb128 0x6b
	.long	.LASF106
	.byte	0x5
	.uleb128 0x6c
	.long	.LASF107
	.byte	0x5
	.uleb128 0x6d
	.long	.LASF108
	.byte	0x5
	.uleb128 0x6e
	.long	.LASF109
	.byte	0x5
	.uleb128 0x6f
	.long	.LASF110
	.byte	0x5
	.uleb128 0x70
	.long	.LASF111
	.byte	0x5
	.uleb128 0x71
	.long	.LASF112
	.byte	0x5
	.uleb128 0x72
	.long	.LASF113
	.byte	0x5
	.uleb128 0x73
	.long	.LASF114
	.byte	0x5
	.uleb128 0x74
	.long	.LASF115
	.byte	0x5
	.uleb128 0x75
	.long	.LASF116
	.byte	0x5
	.uleb128 0x76
	.long	.LASF117
	.byte	0x5
	.uleb128 0x77
	.long	.LASF118
	.byte	0x5
	.uleb128 0x78
	.long	.LASF119
	.byte	0x5
	.uleb128 0x79
	.long	.LASF120
	.byte	0x5
	.uleb128 0x7a
	.long	.LASF121
	.byte	0x5
	.uleb128 0x7b
	.long	.LASF122
	.byte	0x5
	.uleb128 0x7c
	.long	.LASF123
	.byte	0x5
	.uleb128 0x7d
	.long	.LASF124
	.byte	0x5
	.uleb128 0x7e
	.long	.LASF125
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF126
	.byte	0x5
	.uleb128 0x80
	.long	.LASF127
	.byte	0x5
	.uleb128 0x81
	.long	.LASF128
	.byte	0x5
	.uleb128 0x82
	.long	.LASF129
	.byte	0x5
	.uleb128 0x83
	.long	.LASF130
	.byte	0x5
	.uleb128 0x84
	.long	.LASF131
	.byte	0x5
	.uleb128 0x85
	.long	.LASF132
	.byte	0x5
	.uleb128 0x86
	.long	.LASF133
	.byte	0x5
	.uleb128 0x87
	.long	.LASF134
	.byte	0x5
	.uleb128 0x88
	.long	.LASF135
	.byte	0x5
	.uleb128 0x89
	.long	.LASF136
	.byte	0x5
	.uleb128 0x8a
	.long	.LASF137
	.byte	0x5
	.uleb128 0x8b
	.long	.LASF138
	.byte	0x5
	.uleb128 0x8c
	.long	.LASF139
	.byte	0x5
	.uleb128 0x8d
	.long	.LASF140
	.byte	0x5
	.uleb128 0x8e
	.long	.LASF141
	.byte	0x5
	.uleb128 0x8f
	.long	.LASF142
	.byte	0x5
	.uleb128 0x90
	.long	.LASF143
	.byte	0x5
	.uleb128 0x91
	.long	.LASF144
	.byte	0x5
	.uleb128 0x92
	.long	.LASF145
	.byte	0x5
	.uleb128 0x93
	.long	.LASF146
	.byte	0x5
	.uleb128 0x94
	.long	.LASF147
	.byte	0x5
	.uleb128 0x95
	.long	.LASF148
	.byte	0x5
	.uleb128 0x96
	.long	.LASF149
	.byte	0x5
	.uleb128 0x97
	.long	.LASF150
	.byte	0x5
	.uleb128 0x98
	.long	.LASF151
	.byte	0x5
	.uleb128 0x99
	.long	.LASF152
	.byte	0x5
	.uleb128 0x9a
	.long	.LASF153
	.byte	0x5
	.uleb128 0x9b
	.long	.LASF154
	.byte	0x5
	.uleb128 0x9c
	.long	.LASF155
	.byte	0x5
	.uleb128 0x9d
	.long	.LASF156
	.byte	0x5
	.uleb128 0x9e
	.long	.LASF157
	.byte	0x5
	.uleb128 0x9f
	.long	.LASF158
	.byte	0x5
	.uleb128 0xa0
	.long	.LASF159
	.byte	0x5
	.uleb128 0xa1
	.long	.LASF160
	.byte	0x5
	.uleb128 0xa2
	.long	.LASF161
	.byte	0x5
	.uleb128 0xa3
	.long	.LASF162
	.byte	0x5
	.uleb128 0xa4
	.long	.LASF163
	.byte	0x5
	.uleb128 0xa5
	.long	.LASF164
	.byte	0x5
	.uleb128 0xa6
	.long	.LASF165
	.byte	0x5
	.uleb128 0xa7
	.long	.LASF166
	.byte	0x5
	.uleb128 0xa8
	.long	.LASF167
	.byte	0x5
	.uleb128 0xa9
	.long	.LASF168
	.byte	0x5
	.uleb128 0xaa
	.long	.LASF169
	.byte	0x5
	.uleb128 0xab
	.long	.LASF170
	.byte	0x5
	.uleb128 0xac
	.long	.LASF171
	.byte	0x5
	.uleb128 0xad
	.long	.LASF172
	.byte	0x5
	.uleb128 0xae
	.long	.LASF173
	.byte	0x5
	.uleb128 0xaf
	.long	.LASF174
	.byte	0x5
	.uleb128 0xb0
	.long	.LASF175
	.byte	0x5
	.uleb128 0xb1
	.long	.LASF176
	.byte	0x5
	.uleb128 0xb2
	.long	.LASF177
	.byte	0x5
	.uleb128 0xb3
	.long	.LASF178
	.byte	0x5
	.uleb128 0xb4
	.long	.LASF179
	.byte	0x5
	.uleb128 0xb5
	.long	.LASF180
	.byte	0x5
	.uleb128 0xb6
	.long	.LASF181
	.byte	0x5
	.uleb128 0xb7
	.long	.LASF182
	.byte	0x5
	.uleb128 0xb8
	.long	.LASF183
	.byte	0x5
	.uleb128 0xb9
	.long	.LASF184
	.byte	0x5
	.uleb128 0xba
	.long	.LASF185
	.byte	0x5
	.uleb128 0xbb
	.long	.LASF186
	.byte	0x5
	.uleb128 0xbc
	.long	.LASF187
	.byte	0x5
	.uleb128 0xbd
	.long	.LASF188
	.byte	0x5
	.uleb128 0xbe
	.long	.LASF189
	.byte	0x5
	.uleb128 0xbf
	.long	.LASF190
	.byte	0x5
	.uleb128 0xc0
	.long	.LASF191
	.byte	0x5
	.uleb128 0xc1
	.long	.LASF192
	.byte	0x5
	.uleb128 0xc2
	.long	.LASF193
	.byte	0x5
	.uleb128 0xc3
	.long	.LASF194
	.byte	0x5
	.uleb128 0xc4
	.long	.LASF195
	.byte	0x5
	.uleb128 0xc5
	.long	.LASF196
	.byte	0x5
	.uleb128 0xc6
	.long	.LASF197
	.byte	0x5
	.uleb128 0xc7
	.long	.LASF198
	.byte	0x5
	.uleb128 0xc8
	.long	.LASF199
	.byte	0x5
	.uleb128 0xc9
	.long	.LASF200
	.byte	0x5
	.uleb128 0xca
	.long	.LASF201
	.byte	0x5
	.uleb128 0xcb
	.long	.LASF202
	.byte	0x5
	.uleb128 0xcc
	.long	.LASF203
	.byte	0x5
	.uleb128 0xcd
	.long	.LASF204
	.byte	0x5
	.uleb128 0xce
	.long	.LASF205
	.byte	0x5
	.uleb128 0xcf
	.long	.LASF206
	.byte	0x5
	.uleb128 0xd0
	.long	.LASF207
	.byte	0x5
	.uleb128 0xd1
	.long	.LASF208
	.byte	0x5
	.uleb128 0xd2
	.long	.LASF209
	.byte	0x5
	.uleb128 0xd3
	.long	.LASF210
	.byte	0x5
	.uleb128 0xd4
	.long	.LASF211
	.byte	0x5
	.uleb128 0xd5
	.long	.LASF212
	.byte	0x5
	.uleb128 0xd6
	.long	.LASF213
	.byte	0x5
	.uleb128 0xd7
	.long	.LASF214
	.byte	0x5
	.uleb128 0xd8
	.long	.LASF215
	.byte	0x5
	.uleb128 0xd9
	.long	.LASF216
	.byte	0x5
	.uleb128 0xda
	.long	.LASF217
	.byte	0x5
	.uleb128 0xdb
	.long	.LASF218
	.byte	0x5
	.uleb128 0xdc
	.long	.LASF219
	.byte	0x5
	.uleb128 0xdd
	.long	.LASF220
	.byte	0x5
	.uleb128 0xde
	.long	.LASF221
	.byte	0x5
	.uleb128 0xdf
	.long	.LASF222
	.byte	0x5
	.uleb128 0xe0
	.long	.LASF223
	.byte	0x5
	.uleb128 0xe1
	.long	.LASF224
	.byte	0x5
	.uleb128 0xe2
	.long	.LASF225
	.byte	0x5
	.uleb128 0xe3
	.long	.LASF226
	.byte	0x5
	.uleb128 0xe4
	.long	.LASF227
	.byte	0x5
	.uleb128 0xe5
	.long	.LASF228
	.byte	0x5
	.uleb128 0xe6
	.long	.LASF229
	.byte	0x5
	.uleb128 0xe7
	.long	.LASF230
	.byte	0x5
	.uleb128 0xe8
	.long	.LASF231
	.byte	0x5
	.uleb128 0xe9
	.long	.LASF232
	.byte	0x5
	.uleb128 0xea
	.long	.LASF233
	.byte	0x5
	.uleb128 0xeb
	.long	.LASF234
	.byte	0x5
	.uleb128 0xec
	.long	.LASF235
	.byte	0x5
	.uleb128 0xed
	.long	.LASF236
	.byte	0x5
	.uleb128 0xee
	.long	.LASF237
	.byte	0x5
	.uleb128 0xef
	.long	.LASF238
	.byte	0x5
	.uleb128 0xf0
	.long	.LASF239
	.byte	0x5
	.uleb128 0xf1
	.long	.LASF240
	.byte	0x5
	.uleb128 0xf2
	.long	.LASF241
	.byte	0x5
	.uleb128 0xf3
	.long	.LASF242
	.byte	0x5
	.uleb128 0xf4
	.long	.LASF243
	.byte	0x5
	.uleb128 0xf5
	.long	.LASF244
	.byte	0x5
	.uleb128 0xf6
	.long	.LASF245
	.byte	0x5
	.uleb128 0xf7
	.long	.LASF246
	.byte	0x5
	.uleb128 0xf8
	.long	.LASF247
	.byte	0x5
	.uleb128 0xf9
	.long	.LASF248
	.byte	0x5
	.uleb128 0xfa
	.long	.LASF249
	.byte	0x5
	.uleb128 0xfb
	.long	.LASF250
	.byte	0x5
	.uleb128 0xfc
	.long	.LASF251
	.byte	0x5
	.uleb128 0xfd
	.long	.LASF252
	.byte	0x5
	.uleb128 0xfe
	.long	.LASF253
	.byte	0x5
	.uleb128 0xff
	.long	.LASF254
	.byte	0x5
	.uleb128 0x100
	.long	.LASF255
	.byte	0x5
	.uleb128 0x101
	.long	.LASF256
	.byte	0x5
	.uleb128 0x102
	.long	.LASF257
	.byte	0x5
	.uleb128 0x103
	.long	.LASF258
	.byte	0x5
	.uleb128 0x104
	.long	.LASF259
	.byte	0x5
	.uleb128 0x105
	.long	.LASF260
	.byte	0x5
	.uleb128 0x106
	.long	.LASF261
	.byte	0x5
	.uleb128 0x107
	.long	.LASF262
	.byte	0x5
	.uleb128 0x108
	.long	.LASF263
	.byte	0x5
	.uleb128 0x109
	.long	.LASF264
	.byte	0x5
	.uleb128 0x10a
	.long	.LASF265
	.byte	0x5
	.uleb128 0x10b
	.long	.LASF266
	.byte	0x5
	.uleb128 0x10c
	.long	.LASF267
	.byte	0x5
	.uleb128 0x10d
	.long	.LASF268
	.byte	0x5
	.uleb128 0x10e
	.long	.LASF269
	.byte	0x5
	.uleb128 0x10f
	.long	.LASF270
	.byte	0x5
	.uleb128 0x110
	.long	.LASF271
	.byte	0x5
	.uleb128 0x111
	.long	.LASF272
	.byte	0x5
	.uleb128 0x112
	.long	.LASF273
	.byte	0x5
	.uleb128 0x113
	.long	.LASF274
	.byte	0x5
	.uleb128 0x114
	.long	.LASF275
	.byte	0x5
	.uleb128 0x115
	.long	.LASF276
	.byte	0x5
	.uleb128 0x116
	.long	.LASF277
	.byte	0x5
	.uleb128 0x117
	.long	.LASF278
	.byte	0x5
	.uleb128 0x118
	.long	.LASF279
	.byte	0x5
	.uleb128 0x119
	.long	.LASF280
	.byte	0x5
	.uleb128 0x11a
	.long	.LASF281
	.byte	0x5
	.uleb128 0x11b
	.long	.LASF282
	.byte	0x5
	.uleb128 0x11c
	.long	.LASF283
	.byte	0x5
	.uleb128 0x11d
	.long	.LASF284
	.byte	0x5
	.uleb128 0x11e
	.long	.LASF285
	.byte	0x5
	.uleb128 0x11f
	.long	.LASF286
	.byte	0x5
	.uleb128 0x120
	.long	.LASF287
	.byte	0x5
	.uleb128 0x121
	.long	.LASF288
	.byte	0x5
	.uleb128 0x122
	.long	.LASF289
	.byte	0x5
	.uleb128 0x123
	.long	.LASF290
	.byte	0x5
	.uleb128 0x124
	.long	.LASF291
	.byte	0x5
	.uleb128 0x125
	.long	.LASF292
	.byte	0x5
	.uleb128 0x126
	.long	.LASF293
	.byte	0x5
	.uleb128 0x127
	.long	.LASF294
	.byte	0x5
	.uleb128 0x128
	.long	.LASF295
	.byte	0x5
	.uleb128 0x129
	.long	.LASF296
	.byte	0x5
	.uleb128 0x12a
	.long	.LASF297
	.byte	0x5
	.uleb128 0x12b
	.long	.LASF298
	.byte	0x5
	.uleb128 0x12c
	.long	.LASF299
	.byte	0x5
	.uleb128 0x12d
	.long	.LASF300
	.byte	0x5
	.uleb128 0x12e
	.long	.LASF301
	.byte	0x5
	.uleb128 0x12f
	.long	.LASF302
	.byte	0x5
	.uleb128 0x130
	.long	.LASF303
	.byte	0x5
	.uleb128 0x131
	.long	.LASF304
	.byte	0x5
	.uleb128 0x132
	.long	.LASF305
	.byte	0x5
	.uleb128 0x133
	.long	.LASF306
	.byte	0x5
	.uleb128 0x134
	.long	.LASF307
	.byte	0x5
	.uleb128 0x135
	.long	.LASF308
	.byte	0x5
	.uleb128 0x136
	.long	.LASF309
	.byte	0x5
	.uleb128 0x137
	.long	.LASF310
	.byte	0x5
	.uleb128 0x138
	.long	.LASF311
	.byte	0x5
	.uleb128 0x139
	.long	.LASF312
	.byte	0x5
	.uleb128 0x13a
	.long	.LASF313
	.byte	0x5
	.uleb128 0x13b
	.long	.LASF314
	.byte	0x5
	.uleb128 0x13c
	.long	.LASF315
	.byte	0x5
	.uleb128 0x13d
	.long	.LASF316
	.byte	0x5
	.uleb128 0x13e
	.long	.LASF317
	.byte	0x5
	.uleb128 0x13f
	.long	.LASF318
	.byte	0x5
	.uleb128 0x140
	.long	.LASF319
	.byte	0x5
	.uleb128 0x141
	.long	.LASF320
	.byte	0x5
	.uleb128 0x142
	.long	.LASF321
	.byte	0x5
	.uleb128 0x143
	.long	.LASF322
	.byte	0x5
	.uleb128 0x144
	.long	.LASF323
	.byte	0x5
	.uleb128 0x145
	.long	.LASF324
	.byte	0x5
	.uleb128 0x146
	.long	.LASF325
	.byte	0x5
	.uleb128 0x147
	.long	.LASF326
	.byte	0x5
	.uleb128 0x148
	.long	.LASF327
	.byte	0x5
	.uleb128 0x149
	.long	.LASF328
	.byte	0x5
	.uleb128 0x14a
	.long	.LASF329
	.byte	0x5
	.uleb128 0x14b
	.long	.LASF330
	.byte	0x5
	.uleb128 0x14c
	.long	.LASF331
	.byte	0x5
	.uleb128 0x14d
	.long	.LASF332
	.byte	0x5
	.uleb128 0x14e
	.long	.LASF333
	.byte	0x5
	.uleb128 0x14f
	.long	.LASF334
	.byte	0x5
	.uleb128 0x150
	.long	.LASF335
	.byte	0x5
	.uleb128 0x151
	.long	.LASF336
	.byte	0x5
	.uleb128 0x152
	.long	.LASF337
	.byte	0x5
	.uleb128 0x153
	.long	.LASF338
	.byte	0x5
	.uleb128 0x154
	.long	.LASF339
	.byte	0x5
	.uleb128 0x155
	.long	.LASF340
	.byte	0x5
	.uleb128 0x156
	.long	.LASF341
	.byte	0x5
	.uleb128 0x157
	.long	.LASF342
	.byte	0x5
	.uleb128 0x158
	.long	.LASF343
	.byte	0x5
	.uleb128 0x159
	.long	.LASF344
	.byte	0x5
	.uleb128 0x15a
	.long	.LASF345
	.byte	0x5
	.uleb128 0x15b
	.long	.LASF346
	.byte	0x5
	.uleb128 0x15c
	.long	.LASF347
	.byte	0x5
	.uleb128 0x15d
	.long	.LASF348
	.byte	0x5
	.uleb128 0x15e
	.long	.LASF349
	.byte	0x5
	.uleb128 0x15f
	.long	.LASF350
	.byte	0x5
	.uleb128 0x160
	.long	.LASF351
	.byte	0x5
	.uleb128 0x161
	.long	.LASF352
	.byte	0x5
	.uleb128 0x162
	.long	.LASF353
	.byte	0x5
	.uleb128 0x163
	.long	.LASF354
	.byte	0x5
	.uleb128 0x164
	.long	.LASF355
	.byte	0x5
	.uleb128 0x165
	.long	.LASF356
	.byte	0x5
	.uleb128 0x166
	.long	.LASF357
	.byte	0x5
	.uleb128 0x167
	.long	.LASF358
	.byte	0x5
	.uleb128 0x168
	.long	.LASF359
	.byte	0x5
	.uleb128 0x169
	.long	.LASF360
	.byte	0x5
	.uleb128 0x16a
	.long	.LASF361
	.byte	0x5
	.uleb128 0x16b
	.long	.LASF362
	.byte	0x5
	.uleb128 0x16c
	.long	.LASF363
	.byte	0x5
	.uleb128 0x16d
	.long	.LASF364
	.byte	0x5
	.uleb128 0x16e
	.long	.LASF365
	.byte	0x5
	.uleb128 0x16f
	.long	.LASF366
	.byte	0x5
	.uleb128 0x170
	.long	.LASF367
	.byte	0x5
	.uleb128 0x171
	.long	.LASF368
	.byte	0x5
	.uleb128 0x172
	.long	.LASF369
	.byte	0x5
	.uleb128 0x173
	.long	.LASF370
	.byte	0x5
	.uleb128 0x174
	.long	.LASF371
	.byte	0x5
	.uleb128 0x175
	.long	.LASF372
	.byte	0x5
	.uleb128 0x176
	.long	.LASF373
	.byte	0x5
	.uleb128 0x177
	.long	.LASF374
	.byte	0x5
	.uleb128 0x178
	.long	.LASF375
	.byte	0x5
	.uleb128 0x179
	.long	.LASF376
	.byte	0x5
	.uleb128 0x17a
	.long	.LASF377
	.byte	0x5
	.uleb128 0x17b
	.long	.LASF378
	.byte	0x5
	.uleb128 0x17c
	.long	.LASF379
	.byte	0x5
	.uleb128 0x17d
	.long	.LASF380
	.byte	0x5
	.uleb128 0x17e
	.long	.LASF381
	.byte	0x5
	.uleb128 0x17f
	.long	.LASF382
	.byte	0x5
	.uleb128 0x180
	.long	.LASF383
	.byte	0x5
	.uleb128 0x181
	.long	.LASF384
	.byte	0x5
	.uleb128 0x182
	.long	.LASF385
	.byte	0x5
	.uleb128 0x183
	.long	.LASF386
	.byte	0x5
	.uleb128 0x184
	.long	.LASF387
	.byte	0x5
	.uleb128 0x185
	.long	.LASF388
	.byte	0x5
	.uleb128 0x186
	.long	.LASF389
	.byte	0x5
	.uleb128 0x187
	.long	.LASF390
	.byte	0x5
	.uleb128 0x188
	.long	.LASF391
	.byte	0x5
	.uleb128 0x189
	.long	.LASF392
	.byte	0x5
	.uleb128 0x18a
	.long	.LASF393
	.byte	0x5
	.uleb128 0x18b
	.long	.LASF394
	.byte	0x5
	.uleb128 0x18c
	.long	.LASF395
	.byte	0x5
	.uleb128 0x18d
	.long	.LASF396
	.byte	0x5
	.uleb128 0x18e
	.long	.LASF397
	.byte	0x5
	.uleb128 0x18f
	.long	.LASF398
	.byte	0x5
	.uleb128 0x190
	.long	.LASF399
	.byte	0x5
	.uleb128 0x191
	.long	.LASF400
	.byte	0x5
	.uleb128 0x192
	.long	.LASF401
	.byte	0x5
	.uleb128 0x193
	.long	.LASF402
	.byte	0x5
	.uleb128 0x194
	.long	.LASF403
	.byte	0x5
	.uleb128 0x195
	.long	.LASF404
	.byte	0x5
	.uleb128 0x196
	.long	.LASF405
	.byte	0x5
	.uleb128 0x197
	.long	.LASF406
	.byte	0x5
	.uleb128 0x198
	.long	.LASF407
	.byte	0x5
	.uleb128 0x199
	.long	.LASF408
	.byte	0x5
	.uleb128 0x19a
	.long	.LASF409
	.byte	0x5
	.uleb128 0x19b
	.long	.LASF410
	.byte	0x5
	.uleb128 0x19c
	.long	.LASF411
	.byte	0x5
	.uleb128 0x19d
	.long	.LASF412
	.byte	0x5
	.uleb128 0x19e
	.long	.LASF413
	.byte	0x5
	.uleb128 0x19f
	.long	.LASF414
	.byte	0x5
	.uleb128 0x1a0
	.long	.LASF415
	.byte	0x5
	.uleb128 0x1a1
	.long	.LASF416
	.byte	0x5
	.uleb128 0x1a2
	.long	.LASF417
	.byte	0x5
	.uleb128 0x1a3
	.long	.LASF418
	.byte	0x5
	.uleb128 0x1a4
	.long	.LASF419
	.byte	0x5
	.uleb128 0x1a5
	.long	.LASF420
	.byte	0x5
	.uleb128 0x1a6
	.long	.LASF421
	.byte	0x5
	.uleb128 0x1a7
	.long	.LASF422
	.byte	0x5
	.uleb128 0x1a8
	.long	.LASF423
	.byte	0x5
	.uleb128 0x1a9
	.long	.LASF424
	.byte	0x5
	.uleb128 0x1aa
	.long	.LASF425
	.byte	0x5
	.uleb128 0x1ab
	.long	.LASF426
	.byte	0x5
	.uleb128 0x1ac
	.long	.LASF427
	.byte	0x5
	.uleb128 0x1ad
	.long	.LASF428
	.byte	0x5
	.uleb128 0x1ae
	.long	.LASF429
	.byte	0x5
	.uleb128 0x1af
	.long	.LASF430
	.byte	0x5
	.uleb128 0x1b0
	.long	.LASF431
	.byte	0x5
	.uleb128 0x1b1
	.long	.LASF432
	.byte	0x5
	.uleb128 0x1b2
	.long	.LASF433
	.byte	0x5
	.uleb128 0x1
	.long	.LASF434
	.byte	0x5
	.uleb128 0x2
	.long	.LASF435
	.byte	0x5
	.uleb128 0x3
	.long	.LASF436
	.byte	0x5
	.uleb128 0x4
	.long	.LASF437
	.byte	0x5
	.uleb128 0x5
	.long	.LASF438
	.byte	0x5
	.uleb128 0x6
	.long	.LASF439
	.file 4 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\lib\\gcc\\avr\\5.4.0\\include\\stddef.h"
	.byte	0x3
	.uleb128 0xe
	.uleb128 0x4
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.file 5 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\avr\\include\\util\\delay.h"
	.byte	0x3
	.uleb128 0xf
	.uleb128 0x5
	.byte	0x7
	.long	.Ldebug_macro2
	.file 6 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\avr\\include\\inttypes.h"
	.byte	0x3
	.uleb128 0x2c
	.uleb128 0x6
	.byte	0x5
	.uleb128 0x23
	.long	.LASF494
	.file 7 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\lib\\gcc\\avr\\5.4.0\\include\\stdint.h"
	.byte	0x3
	.uleb128 0x25
	.uleb128 0x7
	.byte	0x3
	.uleb128 0x9
	.uleb128 0x2
	.byte	0x7
	.long	.Ldebug_macro3
	.byte	0x4
	.byte	0x5
	.uleb128 0xd
	.long	.LASF560
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro4
	.byte	0x4
	.file 8 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\avr\\include\\util\\delay_basic.h"
	.byte	0x3
	.uleb128 0x2d
	.uleb128 0x8
	.byte	0x5
	.uleb128 0x23
	.long	.LASF671
	.byte	0x4
	.file 9 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\avr\\include\\math.h"
	.byte	0x3
	.uleb128 0x2e
	.uleb128 0x9
	.byte	0x7
	.long	.Ldebug_macro5
	.byte	0x4
	.byte	0x4
	.file 10 "../src/libraries/avr-ds80b20/ds18b20.h"
	.byte	0x3
	.uleb128 0x10
	.uleb128 0xa
	.byte	0x5
	.uleb128 0xf
	.long	.LASF725
	.byte	0x3
	.uleb128 0x12
	.uleb128 0x3
	.byte	0x7
	.long	.Ldebug_macro6
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro7
	.byte	0x4
	.byte	0x3
	.uleb128 0x11
	.uleb128 0x3
	.byte	0x4
	.byte	0x4
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stddef.h.39.99b5021e28f91cdb161c889e07266673,comdat
.Ldebug_macro1:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x27
	.long	.LASF440
	.byte	0x5
	.uleb128 0x28
	.long	.LASF441
	.byte	0x5
	.uleb128 0x2a
	.long	.LASF442
	.byte	0x5
	.uleb128 0x89
	.long	.LASF443
	.byte	0x5
	.uleb128 0x8a
	.long	.LASF444
	.byte	0x5
	.uleb128 0x8b
	.long	.LASF445
	.byte	0x5
	.uleb128 0x8c
	.long	.LASF446
	.byte	0x5
	.uleb128 0x8d
	.long	.LASF447
	.byte	0x5
	.uleb128 0x8e
	.long	.LASF448
	.byte	0x5
	.uleb128 0x8f
	.long	.LASF449
	.byte	0x5
	.uleb128 0x90
	.long	.LASF450
	.byte	0x5
	.uleb128 0x91
	.long	.LASF451
	.byte	0x6
	.uleb128 0xa1
	.long	.LASF452
	.byte	0x5
	.uleb128 0xbb
	.long	.LASF453
	.byte	0x5
	.uleb128 0xbc
	.long	.LASF454
	.byte	0x5
	.uleb128 0xbd
	.long	.LASF455
	.byte	0x5
	.uleb128 0xbe
	.long	.LASF456
	.byte	0x5
	.uleb128 0xbf
	.long	.LASF457
	.byte	0x5
	.uleb128 0xc0
	.long	.LASF458
	.byte	0x5
	.uleb128 0xc1
	.long	.LASF459
	.byte	0x5
	.uleb128 0xc2
	.long	.LASF460
	.byte	0x5
	.uleb128 0xc3
	.long	.LASF461
	.byte	0x5
	.uleb128 0xc4
	.long	.LASF462
	.byte	0x5
	.uleb128 0xc5
	.long	.LASF463
	.byte	0x5
	.uleb128 0xc6
	.long	.LASF464
	.byte	0x5
	.uleb128 0xc7
	.long	.LASF465
	.byte	0x5
	.uleb128 0xc8
	.long	.LASF466
	.byte	0x5
	.uleb128 0xc9
	.long	.LASF467
	.byte	0x5
	.uleb128 0xca
	.long	.LASF468
	.byte	0x5
	.uleb128 0xd2
	.long	.LASF469
	.byte	0x6
	.uleb128 0xee
	.long	.LASF470
	.byte	0x5
	.uleb128 0x10b
	.long	.LASF471
	.byte	0x5
	.uleb128 0x10c
	.long	.LASF472
	.byte	0x5
	.uleb128 0x10d
	.long	.LASF473
	.byte	0x5
	.uleb128 0x10e
	.long	.LASF474
	.byte	0x5
	.uleb128 0x10f
	.long	.LASF475
	.byte	0x5
	.uleb128 0x110
	.long	.LASF476
	.byte	0x5
	.uleb128 0x111
	.long	.LASF477
	.byte	0x5
	.uleb128 0x112
	.long	.LASF478
	.byte	0x5
	.uleb128 0x113
	.long	.LASF479
	.byte	0x5
	.uleb128 0x114
	.long	.LASF480
	.byte	0x5
	.uleb128 0x115
	.long	.LASF481
	.byte	0x5
	.uleb128 0x116
	.long	.LASF482
	.byte	0x5
	.uleb128 0x117
	.long	.LASF483
	.byte	0x5
	.uleb128 0x118
	.long	.LASF484
	.byte	0x5
	.uleb128 0x119
	.long	.LASF485
	.byte	0x6
	.uleb128 0x126
	.long	.LASF486
	.byte	0x6
	.uleb128 0x15b
	.long	.LASF487
	.byte	0x6
	.uleb128 0x191
	.long	.LASF488
	.byte	0x5
	.uleb128 0x196
	.long	.LASF489
	.byte	0x6
	.uleb128 0x19c
	.long	.LASF490
	.byte	0x5
	.uleb128 0x1a1
	.long	.LASF491
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.delay.h.36.9b049a49ceee302c08fd72aec728bf54,comdat
.Ldebug_macro2:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x24
	.long	.LASF492
	.byte	0x5
	.uleb128 0x28
	.long	.LASF493
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stdint.h.41.052d062c327f27e210bb72c3d087afe5,comdat
.Ldebug_macro3:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x29
	.long	.LASF495
	.byte	0x5
	.uleb128 0x3b
	.long	.LASF496
	.byte	0x5
	.uleb128 0x122
	.long	.LASF497
	.byte	0x5
	.uleb128 0x123
	.long	.LASF498
	.byte	0x5
	.uleb128 0x133
	.long	.LASF499
	.byte	0x5
	.uleb128 0x138
	.long	.LASF500
	.byte	0x5
	.uleb128 0x14b
	.long	.LASF501
	.byte	0x5
	.uleb128 0x150
	.long	.LASF502
	.byte	0x5
	.uleb128 0x155
	.long	.LASF503
	.byte	0x5
	.uleb128 0x15a
	.long	.LASF504
	.byte	0x5
	.uleb128 0x15f
	.long	.LASF505
	.byte	0x5
	.uleb128 0x164
	.long	.LASF506
	.byte	0x5
	.uleb128 0x169
	.long	.LASF507
	.byte	0x5
	.uleb128 0x170
	.long	.LASF508
	.byte	0x5
	.uleb128 0x175
	.long	.LASF509
	.byte	0x5
	.uleb128 0x17a
	.long	.LASF510
	.byte	0x5
	.uleb128 0x184
	.long	.LASF511
	.byte	0x5
	.uleb128 0x189
	.long	.LASF512
	.byte	0x5
	.uleb128 0x18e
	.long	.LASF513
	.byte	0x5
	.uleb128 0x193
	.long	.LASF514
	.byte	0x5
	.uleb128 0x198
	.long	.LASF515
	.byte	0x5
	.uleb128 0x19d
	.long	.LASF516
	.byte	0x5
	.uleb128 0x1a2
	.long	.LASF517
	.byte	0x5
	.uleb128 0x1a7
	.long	.LASF518
	.byte	0x5
	.uleb128 0x1ac
	.long	.LASF519
	.byte	0x5
	.uleb128 0x1b1
	.long	.LASF520
	.byte	0x5
	.uleb128 0x1b6
	.long	.LASF521
	.byte	0x5
	.uleb128 0x1bb
	.long	.LASF522
	.byte	0x5
	.uleb128 0x1c6
	.long	.LASF523
	.byte	0x5
	.uleb128 0x1cb
	.long	.LASF524
	.byte	0x5
	.uleb128 0x1d0
	.long	.LASF525
	.byte	0x5
	.uleb128 0x1d5
	.long	.LASF526
	.byte	0x5
	.uleb128 0x1da
	.long	.LASF527
	.byte	0x5
	.uleb128 0x1df
	.long	.LASF528
	.byte	0x5
	.uleb128 0x1e4
	.long	.LASF529
	.byte	0x5
	.uleb128 0x1e9
	.long	.LASF530
	.byte	0x5
	.uleb128 0x1ee
	.long	.LASF531
	.byte	0x5
	.uleb128 0x1f3
	.long	.LASF532
	.byte	0x5
	.uleb128 0x1f8
	.long	.LASF533
	.byte	0x5
	.uleb128 0x1fd
	.long	.LASF534
	.byte	0x5
	.uleb128 0x208
	.long	.LASF535
	.byte	0x5
	.uleb128 0x20d
	.long	.LASF536
	.byte	0x5
	.uleb128 0x212
	.long	.LASF537
	.byte	0x5
	.uleb128 0x21d
	.long	.LASF538
	.byte	0x5
	.uleb128 0x222
	.long	.LASF539
	.byte	0x5
	.uleb128 0x227
	.long	.LASF540
	.byte	0x5
	.uleb128 0x234
	.long	.LASF541
	.byte	0x5
	.uleb128 0x239
	.long	.LASF542
	.byte	0x5
	.uleb128 0x242
	.long	.LASF543
	.byte	0x5
	.uleb128 0x247
	.long	.LASF544
	.byte	0x5
	.uleb128 0x24d
	.long	.LASF545
	.byte	0x5
	.uleb128 0x259
	.long	.LASF546
	.byte	0x5
	.uleb128 0x25a
	.long	.LASF547
	.byte	0x5
	.uleb128 0x25d
	.long	.LASF548
	.byte	0x5
	.uleb128 0x25e
	.long	.LASF549
	.byte	0x5
	.uleb128 0x271
	.long	.LASF550
	.byte	0x5
	.uleb128 0x272
	.long	.LASF551
	.byte	0x5
	.uleb128 0x273
	.long	.LASF552
	.byte	0x5
	.uleb128 0x274
	.long	.LASF553
	.byte	0x5
	.uleb128 0x275
	.long	.LASF554
	.byte	0x5
	.uleb128 0x276
	.long	.LASF555
	.byte	0x5
	.uleb128 0x277
	.long	.LASF556
	.byte	0x5
	.uleb128 0x278
	.long	.LASF557
	.byte	0x5
	.uleb128 0x279
	.long	.LASF558
	.byte	0x5
	.uleb128 0x27a
	.long	.LASF559
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.inttypes.h.96.afb9c4be73a069861f8689c997efc518,comdat
.Ldebug_macro4:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x60
	.long	.LASF561
	.byte	0x5
	.uleb128 0x63
	.long	.LASF562
	.byte	0x5
	.uleb128 0x66
	.long	.LASF563
	.byte	0x5
	.uleb128 0x6a
	.long	.LASF564
	.byte	0x5
	.uleb128 0x6d
	.long	.LASF565
	.byte	0x5
	.uleb128 0x70
	.long	.LASF566
	.byte	0x5
	.uleb128 0x75
	.long	.LASF567
	.byte	0x5
	.uleb128 0x78
	.long	.LASF568
	.byte	0x5
	.uleb128 0x7b
	.long	.LASF569
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF570
	.byte	0x5
	.uleb128 0x82
	.long	.LASF571
	.byte	0x5
	.uleb128 0x85
	.long	.LASF572
	.byte	0x5
	.uleb128 0x8a
	.long	.LASF573
	.byte	0x5
	.uleb128 0x8d
	.long	.LASF574
	.byte	0x5
	.uleb128 0x90
	.long	.LASF575
	.byte	0x5
	.uleb128 0x94
	.long	.LASF576
	.byte	0x5
	.uleb128 0x97
	.long	.LASF577
	.byte	0x5
	.uleb128 0x9a
	.long	.LASF578
	.byte	0x5
	.uleb128 0xaf
	.long	.LASF579
	.byte	0x5
	.uleb128 0xb2
	.long	.LASF580
	.byte	0x5
	.uleb128 0xb6
	.long	.LASF581
	.byte	0x5
	.uleb128 0xb9
	.long	.LASF582
	.byte	0x5
	.uleb128 0xbc
	.long	.LASF583
	.byte	0x5
	.uleb128 0xc0
	.long	.LASF584
	.byte	0x5
	.uleb128 0xc3
	.long	.LASF585
	.byte	0x5
	.uleb128 0xc6
	.long	.LASF586
	.byte	0x5
	.uleb128 0xca
	.long	.LASF587
	.byte	0x5
	.uleb128 0xcd
	.long	.LASF588
	.byte	0x5
	.uleb128 0xd0
	.long	.LASF589
	.byte	0x5
	.uleb128 0xd4
	.long	.LASF590
	.byte	0x5
	.uleb128 0xd7
	.long	.LASF591
	.byte	0x5
	.uleb128 0xda
	.long	.LASF592
	.byte	0x5
	.uleb128 0xdf
	.long	.LASF593
	.byte	0x5
	.uleb128 0xe2
	.long	.LASF594
	.byte	0x5
	.uleb128 0xe5
	.long	.LASF595
	.byte	0x5
	.uleb128 0xe9
	.long	.LASF596
	.byte	0x5
	.uleb128 0xec
	.long	.LASF597
	.byte	0x5
	.uleb128 0xef
	.long	.LASF598
	.byte	0x5
	.uleb128 0xf3
	.long	.LASF599
	.byte	0x5
	.uleb128 0xf6
	.long	.LASF600
	.byte	0x5
	.uleb128 0xf9
	.long	.LASF601
	.byte	0x5
	.uleb128 0xfd
	.long	.LASF602
	.byte	0x5
	.uleb128 0x100
	.long	.LASF603
	.byte	0x5
	.uleb128 0x103
	.long	.LASF604
	.byte	0x5
	.uleb128 0x108
	.long	.LASF605
	.byte	0x5
	.uleb128 0x10b
	.long	.LASF606
	.byte	0x5
	.uleb128 0x10e
	.long	.LASF607
	.byte	0x5
	.uleb128 0x112
	.long	.LASF608
	.byte	0x5
	.uleb128 0x115
	.long	.LASF609
	.byte	0x5
	.uleb128 0x118
	.long	.LASF610
	.byte	0x5
	.uleb128 0x11c
	.long	.LASF611
	.byte	0x5
	.uleb128 0x11f
	.long	.LASF612
	.byte	0x5
	.uleb128 0x122
	.long	.LASF613
	.byte	0x5
	.uleb128 0x126
	.long	.LASF614
	.byte	0x5
	.uleb128 0x129
	.long	.LASF615
	.byte	0x5
	.uleb128 0x12c
	.long	.LASF616
	.byte	0x5
	.uleb128 0x14a
	.long	.LASF617
	.byte	0x5
	.uleb128 0x14d
	.long	.LASF618
	.byte	0x5
	.uleb128 0x150
	.long	.LASF619
	.byte	0x5
	.uleb128 0x153
	.long	.LASF620
	.byte	0x5
	.uleb128 0x158
	.long	.LASF621
	.byte	0x5
	.uleb128 0x15b
	.long	.LASF622
	.byte	0x5
	.uleb128 0x15e
	.long	.LASF623
	.byte	0x5
	.uleb128 0x162
	.long	.LASF624
	.byte	0x5
	.uleb128 0x165
	.long	.LASF625
	.byte	0x5
	.uleb128 0x168
	.long	.LASF626
	.byte	0x5
	.uleb128 0x16d
	.long	.LASF627
	.byte	0x5
	.uleb128 0x170
	.long	.LASF628
	.byte	0x5
	.uleb128 0x173
	.long	.LASF629
	.byte	0x5
	.uleb128 0x177
	.long	.LASF630
	.byte	0x5
	.uleb128 0x17a
	.long	.LASF631
	.byte	0x5
	.uleb128 0x17d
	.long	.LASF632
	.byte	0x5
	.uleb128 0x182
	.long	.LASF633
	.byte	0x5
	.uleb128 0x185
	.long	.LASF634
	.byte	0x5
	.uleb128 0x188
	.long	.LASF635
	.byte	0x5
	.uleb128 0x18c
	.long	.LASF636
	.byte	0x5
	.uleb128 0x18f
	.long	.LASF637
	.byte	0x5
	.uleb128 0x192
	.long	.LASF638
	.byte	0x5
	.uleb128 0x1a6
	.long	.LASF639
	.byte	0x5
	.uleb128 0x1a9
	.long	.LASF640
	.byte	0x5
	.uleb128 0x1ad
	.long	.LASF641
	.byte	0x5
	.uleb128 0x1b0
	.long	.LASF642
	.byte	0x5
	.uleb128 0x1b3
	.long	.LASF643
	.byte	0x5
	.uleb128 0x1b7
	.long	.LASF644
	.byte	0x5
	.uleb128 0x1ba
	.long	.LASF645
	.byte	0x5
	.uleb128 0x1bd
	.long	.LASF646
	.byte	0x5
	.uleb128 0x1c1
	.long	.LASF647
	.byte	0x5
	.uleb128 0x1c4
	.long	.LASF648
	.byte	0x5
	.uleb128 0x1c7
	.long	.LASF649
	.byte	0x5
	.uleb128 0x1cb
	.long	.LASF650
	.byte	0x5
	.uleb128 0x1ce
	.long	.LASF651
	.byte	0x5
	.uleb128 0x1d1
	.long	.LASF652
	.byte	0x5
	.uleb128 0x1d5
	.long	.LASF653
	.byte	0x5
	.uleb128 0x1d8
	.long	.LASF654
	.byte	0x5
	.uleb128 0x1db
	.long	.LASF655
	.byte	0x5
	.uleb128 0x1df
	.long	.LASF656
	.byte	0x5
	.uleb128 0x1e2
	.long	.LASF657
	.byte	0x5
	.uleb128 0x1e5
	.long	.LASF658
	.byte	0x5
	.uleb128 0x1ea
	.long	.LASF659
	.byte	0x5
	.uleb128 0x1ed
	.long	.LASF660
	.byte	0x5
	.uleb128 0x1f0
	.long	.LASF661
	.byte	0x5
	.uleb128 0x1f4
	.long	.LASF662
	.byte	0x5
	.uleb128 0x1f7
	.long	.LASF663
	.byte	0x5
	.uleb128 0x1fa
	.long	.LASF664
	.byte	0x5
	.uleb128 0x1fe
	.long	.LASF665
	.byte	0x5
	.uleb128 0x201
	.long	.LASF666
	.byte	0x5
	.uleb128 0x204
	.long	.LASF667
	.byte	0x5
	.uleb128 0x21d
	.long	.LASF668
	.byte	0x5
	.uleb128 0x220
	.long	.LASF669
	.byte	0x5
	.uleb128 0x223
	.long	.LASF670
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.math.h.49.c8a36eddb532146e0bb8ca9326ea4652,comdat
.Ldebug_macro5:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x31
	.long	.LASF672
	.byte	0x5
	.uleb128 0x47
	.long	.LASF673
	.byte	0x5
	.uleb128 0x4a
	.long	.LASF674
	.byte	0x5
	.uleb128 0x4d
	.long	.LASF675
	.byte	0x5
	.uleb128 0x50
	.long	.LASF676
	.byte	0x5
	.uleb128 0x53
	.long	.LASF677
	.byte	0x5
	.uleb128 0x56
	.long	.LASF678
	.byte	0x5
	.uleb128 0x59
	.long	.LASF679
	.byte	0x5
	.uleb128 0x5c
	.long	.LASF680
	.byte	0x5
	.uleb128 0x5f
	.long	.LASF681
	.byte	0x5
	.uleb128 0x62
	.long	.LASF682
	.byte	0x5
	.uleb128 0x65
	.long	.LASF683
	.byte	0x5
	.uleb128 0x68
	.long	.LASF684
	.byte	0x5
	.uleb128 0x6b
	.long	.LASF685
	.byte	0x5
	.uleb128 0x6e
	.long	.LASF686
	.byte	0x5
	.uleb128 0x71
	.long	.LASF687
	.byte	0x5
	.uleb128 0x75
	.long	.LASF688
	.byte	0x5
	.uleb128 0x80
	.long	.LASF689
	.byte	0x5
	.uleb128 0x86
	.long	.LASF690
	.byte	0x5
	.uleb128 0x8c
	.long	.LASF691
	.byte	0x5
	.uleb128 0x93
	.long	.LASF692
	.byte	0x5
	.uleb128 0x9a
	.long	.LASF693
	.byte	0x5
	.uleb128 0xb9
	.long	.LASF694
	.byte	0x5
	.uleb128 0xc4
	.long	.LASF695
	.byte	0x5
	.uleb128 0xcc
	.long	.LASF696
	.byte	0x5
	.uleb128 0xd3
	.long	.LASF697
	.byte	0x5
	.uleb128 0xda
	.long	.LASF698
	.byte	0x5
	.uleb128 0xec
	.long	.LASF699
	.byte	0x5
	.uleb128 0xf4
	.long	.LASF700
	.byte	0x5
	.uleb128 0xfa
	.long	.LASF701
	.byte	0x5
	.uleb128 0x100
	.long	.LASF702
	.byte	0x5
	.uleb128 0x106
	.long	.LASF703
	.byte	0x5
	.uleb128 0x10c
	.long	.LASF704
	.byte	0x5
	.uleb128 0x114
	.long	.LASF705
	.byte	0x5
	.uleb128 0x11c
	.long	.LASF706
	.byte	0x5
	.uleb128 0x123
	.long	.LASF707
	.byte	0x5
	.uleb128 0x12c
	.long	.LASF708
	.byte	0x5
	.uleb128 0x132
	.long	.LASF709
	.byte	0x5
	.uleb128 0x138
	.long	.LASF710
	.byte	0x5
	.uleb128 0x13e
	.long	.LASF711
	.byte	0x5
	.uleb128 0x145
	.long	.LASF712
	.byte	0x5
	.uleb128 0x14f
	.long	.LASF713
	.byte	0x5
	.uleb128 0x161
	.long	.LASF714
	.byte	0x5
	.uleb128 0x170
	.long	.LASF715
	.byte	0x5
	.uleb128 0x17a
	.long	.LASF716
	.byte	0x5
	.uleb128 0x181
	.long	.LASF717
	.byte	0x5
	.uleb128 0x18a
	.long	.LASF718
	.byte	0x5
	.uleb128 0x192
	.long	.LASF719
	.byte	0x5
	.uleb128 0x19a
	.long	.LASF720
	.byte	0x5
	.uleb128 0x1a1
	.long	.LASF721
	.byte	0x5
	.uleb128 0x1ac
	.long	.LASF722
	.byte	0x5
	.uleb128 0x1b9
	.long	.LASF723
	.byte	0x5
	.uleb128 0x1c7
	.long	.LASF724
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.onewire.h.15.b937023de02f1fd8cef42acff09f2180,comdat
.Ldebug_macro6:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xf
	.long	.LASF726
	.byte	0x5
	.uleb128 0x18
	.long	.LASF727
	.byte	0x5
	.uleb128 0x19
	.long	.LASF728
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.ds18b20.h.20.b4f7cfa2b4420ac309ce875c0a4ce9b8,comdat
.Ldebug_macro7:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x14
	.long	.LASF729
	.byte	0x5
	.uleb128 0x15
	.long	.LASF730
	.byte	0x5
	.uleb128 0x16
	.long	.LASF731
	.byte	0x5
	.uleb128 0x17
	.long	.LASF732
	.byte	0x5
	.uleb128 0x18
	.long	.LASF733
	.byte	0x5
	.uleb128 0x19
	.long	.LASF734
	.byte	0x5
	.uleb128 0x1b
	.long	.LASF735
	.byte	0x5
	.uleb128 0x1c
	.long	.LASF736
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF737
	.byte	0x5
	.uleb128 0x1e
	.long	.LASF738
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF739
	.byte	0x5
	.uleb128 0x20
	.long	.LASF740
	.byte	0x5
	.uleb128 0x21
	.long	.LASF741
	.byte	0x5
	.uleb128 0x22
	.long	.LASF742
	.byte	0x5
	.uleb128 0x24
	.long	.LASF743
	.byte	0x5
	.uleb128 0x25
	.long	.LASF744
	.byte	0x5
	.uleb128 0x26
	.long	.LASF745
	.byte	0x5
	.uleb128 0x27
	.long	.LASF746
	.byte	0x5
	.uleb128 0x29
	.long	.LASF747
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF337:
	.string	"__AVR_HAVE_16BIT_SP__ 1"
.LASF299:
	.string	"__UHA_FBIT__ 8"
.LASF766:
	.string	"ds18b20rsp"
.LASF646:
	.string	"SCNuFAST8 \"hhu\""
.LASF189:
	.string	"__DEC128_EPSILON__ 1E-33DL"
.LASF669:
	.string	"SCNuPTR SCNu16"
.LASF314:
	.string	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 1"
.LASF70:
	.string	"__GXX_ABI_VERSION 1009"
.LASF775:
	.string	"onewireInit"
.LASF767:
	.string	"ds18b20wsp"
.LASF772:
	.string	"sizetype"
.LASF51:
	.string	"__INT_LEAST16_TYPE__ int"
.LASF604:
	.string	"PRIXFAST16 \"X\""
.LASF255:
	.string	"__LACCUM_EPSILON__ 0x1P-31LK"
.LASF135:
	.string	"__FLT_MAX__ 3.40282347e+38F"
.LASF188:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF699:
	.string	"frexpf frexp"
.LASF84:
	.string	"__INTMAX_C(c) c ## LL"
.LASF108:
	.string	"__UINT16_C(c) c ## U"
.LASF83:
	.string	"__INTMAX_MAX__ 0x7fffffffffffffffLL"
.LASF176:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF280:
	.string	"__TQ_IBIT__ 0"
.LASF549:
	.string	"WINT_MIN __WINT_MIN__"
.LASF94:
	.string	"__UINT16_MAX__ 0xffffU"
.LASF270:
	.string	"__ULLACCUM_EPSILON__ 0x1P-48ULLK"
.LASF14:
	.string	"__ATOMIC_CONSUME 1"
.LASF256:
	.string	"__ULACCUM_FBIT__ 32"
.LASF566:
	.string	"PRIiFAST8 \"i\""
.LASF497:
	.string	"__CONCATenate(left,right) left ## right"
.LASF653:
	.string	"SCNu16 \"u\""
.LASF730:
	.string	"DS18B20_ERROR_COMM 1"
.LASF19:
	.string	"__SIZEOF_LONG_LONG__ 8"
.LASF203:
	.string	"__FRACT_MIN__ (-0.5R-0.5R)"
.LASF529:
	.string	"INT_FAST32_MAX INT32_MAX"
.LASF162:
	.string	"__DECIMAL_DIG__ 9"
.LASF239:
	.string	"__USACCUM_MAX__ 0XFFFFP-8UHK"
.LASF173:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF276:
	.string	"__SQ_IBIT__ 0"
.LASF29:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF33:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF618:
	.string	"PRIuPTR PRIu16"
.LASF682:
	.string	"M_2_PI 0.63661977236758134308"
.LASF139:
	.string	"__FLT_HAS_DENORM__ 1"
.LASF42:
	.string	"__INT8_TYPE__ signed char"
.LASF575:
	.string	"PRIdFAST32 \"ld\""
.LASF238:
	.string	"__USACCUM_MIN__ 0.0UHK"
.LASF701:
	.string	"expf exp"
.LASF581:
	.string	"PRIo8 \"o\""
.LASF368:
	.string	"__BUILTIN_AVR_ROUNDUR 1"
.LASF643:
	.string	"SCNoFAST8 \"hho\""
.LASF2:
	.string	"__STDC_UTF_16__ 1"
.LASF106:
	.string	"__UINT8_C(c) c"
.LASF344:
	.string	"__BUILTIN_AVR_SEI 1"
.LASF744:
	.string	"DS18B20_RES10 ( 1 << 5 )"
.LASF150:
	.string	"__DBL_MIN__ ((double)1.17549435e-38L)"
.LASF77:
	.string	"__WCHAR_MAX__ 0x7fff"
.LASF348:
	.string	"__BUILTIN_AVR_SWAP 1"
.LASF667:
	.string	"SCNxFAST32 \"lx\""
.LASF4:
	.string	"__STDC_HOSTED__ 1"
.LASF226:
	.string	"__ULLFRACT_FBIT__ 64"
.LASF675:
	.string	"M_LOG10E 0.43429448190325182765"
.LASF716:
	.string	"signbitf signbit"
.LASF371:
	.string	"__BUILTIN_AVR_ROUNDHK 1"
.LASF61:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF746:
	.string	"DS18B20_RES12 ( 3 << 5 )"
.LASF614:
	.string	"PRIX32 \"lX\""
.LASF681:
	.string	"M_1_PI 0.31830988618379067154"
.LASF454:
	.string	"__SIZE_T__ "
.LASF545:
	.string	"SIZE_MAX UINT16_MAX"
.LASF723:
	.string	"lroundf lround"
.LASF263:
	.string	"__LLACCUM_MIN__ (-0X1P15LLK-0X1P15LLK)"
.LASF629:
	.string	"SCNdFAST16 \"d\""
.LASF199:
	.string	"__USFRACT_MAX__ 0XFFP-8UHR"
.LASF761:
	.string	"direction"
.LASF510:
	.string	"UINT64_MAX (__CONCAT(INT64_MAX, U) * 2ULL + 1ULL)"
.LASF359:
	.string	"__BUILTIN_AVR_ABSHK 1"
.LASF487:
	.string	"__need_wchar_t"
.LASF265:
	.string	"__LLACCUM_EPSILON__ 0x1P-47LLK"
.LASF685:
	.string	"M_SQRT1_2 0.70710678118654752440"
.LASF563:
	.string	"PRIdFAST8 \"d\""
.LASF382:
	.string	"__BUILTIN_AVR_COUNTLSLLR 1"
.LASF448:
	.string	"_BSD_PTRDIFF_T_ "
.LASF216:
	.string	"__ULFRACT_FBIT__ 32"
.LASF373:
	.string	"__BUILTIN_AVR_ROUNDLK 1"
.LASF577:
	.string	"PRIiLEAST32 \"li\""
.LASF291:
	.string	"__HA_FBIT__ 7"
.LASF347:
	.string	"__BUILTIN_AVR_SLEEP 1"
.LASF437:
	.string	"DEBUG 1"
.LASF1:
	.string	"__STDC_VERSION__ 199901L"
.LASF576:
	.string	"PRIi32 \"li\""
.LASF613:
	.string	"PRIxFAST32 \"lx\""
.LASF768:
	.string	"conf"
.LASF36:
	.string	"__WINT_TYPE__ int"
.LASF335:
	.string	"__AVR_MEGA__ 1"
.LASF195:
	.string	"__SFRACT_EPSILON__ 0x1P-7HR"
.LASF458:
	.string	"_T_SIZE "
.LASF102:
	.string	"__INT32_C(c) c ## L"
.LASF556:
	.string	"UINT32_C(c) __UINT32_C(c)"
.LASF28:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF361:
	.string	"__BUILTIN_AVR_ABSLK 1"
.LASF275:
	.string	"__SQ_FBIT__ 31"
.LASF531:
	.string	"UINT_FAST32_MAX UINT32_MAX"
.LASF439:
	.string	"F_CPU 16000000"
.LASF727:
	.string	"ONEWIRE_ERROR_OK 0"
.LASF544:
	.string	"SIG_ATOMIC_MIN INT8_MIN"
.LASF283:
	.string	"__UHQ_FBIT__ 16"
.LASF526:
	.string	"INT_FAST16_MAX INT16_MAX"
.LASF635:
	.string	"SCNdFAST32 \"ld\""
.LASF718:
	.string	"fmaf fma"
.LASF680:
	.string	"M_PI_4 0.78539816339744830962"
.LASF175:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF358:
	.string	"__BUILTIN_AVR_ABSLLR 1"
.LASF555:
	.string	"UINT16_C(c) __UINT16_C(c)"
.LASF252:
	.string	"__LACCUM_IBIT__ 32"
.LASF157:
	.string	"__LDBL_DIG__ 6"
.LASF420:
	.string	"__BUILTIN_AVR_KBITS 1"
.LASF237:
	.string	"__USACCUM_IBIT__ 8"
.LASF553:
	.string	"INT64_C(c) __INT64_C(c)"
.LASF305:
	.string	"__UTA_FBIT__ 48"
.LASF124:
	.string	"__GCC_IEC_559_COMPLEX 0"
.LASF174:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF475:
	.string	"_T_WCHAR "
.LASF149:
	.string	"__DBL_MAX__ ((double)3.40282347e+38L)"
.LASF117:
	.string	"__UINT_FAST8_MAX__ 0xff"
.LASF569:
	.string	"PRIdFAST16 \"d\""
.LASF546:
	.string	"WCHAR_MAX __WCHAR_MAX__"
.LASF456:
	.string	"_SYS_SIZE_T_H "
.LASF550:
	.string	"INT8_C(c) __INT8_C(c)"
.LASF663:
	.string	"SCNuLEAST32 \"lu\""
.LASF241:
	.string	"__ACCUM_FBIT__ 15"
.LASF247:
	.string	"__UACCUM_IBIT__ 16"
.LASF633:
	.string	"SCNd32 \"ld\""
.LASF116:
	.string	"__INT_FAST64_MAX__ 0x7fffffffffffffffLL"
.LASF185:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF738:
	.string	"DS18B20_COMMAND_CONVERT 0x44"
.LASF303:
	.string	"__UDA_FBIT__ 32"
.LASF453:
	.string	"__size_t__ "
.LASF179:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF610:
	.string	"PRIuFAST32 \"lu\""
.LASF86:
	.string	"__UINTMAX_C(c) c ## ULL"
.LASF50:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF310:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 1"
.LASF616:
	.string	"PRIXFAST32 \"lX\""
.LASF343:
	.string	"__BUILTIN_AVR_NOP 1"
.LASF615:
	.string	"PRIXLEAST32 \"lX\""
.LASF648:
	.string	"SCNxLEAST8 \"hhx\""
.LASF229:
	.string	"__ULLFRACT_MAX__ 0XFFFFFFFFFFFFFFFFP-64ULLR"
.LASF64:
	.string	"__UINT_FAST32_TYPE__ long unsigned int"
.LASF662:
	.string	"SCNu32 \"lu\""
.LASF449:
	.string	"___int_ptrdiff_t_h "
.LASF465:
	.string	"_SIZE_T_DECLARED "
.LASF40:
	.string	"__CHAR32_TYPE__ long unsigned int"
.LASF71:
	.string	"__USING_SJLJ_EXCEPTIONS__ 1"
.LASF665:
	.string	"SCNx32 \"lx\""
.LASF132:
	.string	"__FLT_MAX_EXP__ 128"
.LASF18:
	.string	"__SIZEOF_LONG__ 4"
.LASF592:
	.string	"PRIXFAST8 \"X\""
.LASF151:
	.string	"__DBL_EPSILON__ ((double)1.19209290e-7L)"
.LASF39:
	.string	"__CHAR16_TYPE__ unsigned int"
.LASF22:
	.string	"__SIZEOF_DOUBLE__ 4"
.LASF542:
	.string	"PTRDIFF_MIN INT16_MIN"
.LASF413:
	.string	"__BUILTIN_AVR_LRBITS 1"
.LASF714:
	.string	"isfinitef isfinite"
.LASF147:
	.string	"__DBL_MAX_10_EXP__ 38"
.LASF519:
	.string	"UINT_LEAST32_MAX UINT32_MAX"
.LASF80:
	.string	"__WINT_MIN__ (-__WINT_MAX__ - 1)"
.LASF435:
	.string	"__AVR_DEVICE_NAME__ atmega328p"
.LASF181:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF131:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF134:
	.string	"__FLT_DECIMAL_DIG__ 9"
.LASF652:
	.string	"SCNoFAST16 \"o\""
.LASF712:
	.string	"isnanf isnan"
.LASF101:
	.string	"__INT_LEAST32_MAX__ 0x7fffffffL"
.LASF749:
	.string	"signed char"
.LASF751:
	.string	"uint8_t"
.LASF552:
	.string	"INT32_C(c) __INT32_C(c)"
.LASF309:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF331:
	.string	"__AVR_HAVE_LPMX__ 1"
.LASF104:
	.string	"__INT64_C(c) c ## LL"
.LASF201:
	.string	"__FRACT_FBIT__ 15"
.LASF776:
	.string	"onewireRead"
.LASF141:
	.string	"__FLT_HAS_QUIET_NAN__ 1"
.LASF770:
	.string	"ds18b20read"
.LASF313:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 1"
.LASF650:
	.string	"SCNo16 \"o\""
.LASF508:
	.string	"INT64_MAX 0x7fffffffffffffffLL"
.LASF762:
	.string	"portin"
.LASF735:
	.string	"DS18B20_COMMAND_READ_ROM 0x33"
.LASF703:
	.string	"sinhf sinh"
.LASF425:
	.string	"__BUILTIN_AVR_ULKBITS 1"
.LASF695:
	.string	"hypotf hypot"
.LASF464:
	.string	"_BSD_SIZE_T_DEFINED_ "
.LASF396:
	.string	"__BUILTIN_AVR_BITSR 1"
.LASF466:
	.string	"___int_size_t_h "
.LASF3:
	.string	"__STDC_UTF_32__ 1"
.LASF232:
	.string	"__SACCUM_IBIT__ 8"
.LASF693:
	.string	"fmodf fmod"
.LASF133:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF204:
	.string	"__FRACT_MAX__ 0X7FFFP-15R"
.LASF597:
	.string	"PRIuLEAST16 \"u\""
.LASF422:
	.string	"__BUILTIN_AVR_LLKBITS 1"
.LASF655:
	.string	"SCNuFAST16 \"u\""
.LASF122:
	.string	"__UINTPTR_MAX__ 0xffffU"
.LASF10:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF416:
	.string	"__BUILTIN_AVR_URBITS 1"
.LASF543:
	.string	"SIG_ATOMIC_MAX INT8_MAX"
.LASF386:
	.string	"__BUILTIN_AVR_COUNTLSULLR 1"
.LASF55:
	.string	"__UINT_LEAST16_TYPE__ unsigned int"
.LASF279:
	.string	"__TQ_FBIT__ 127"
.LASF306:
	.string	"__UTA_IBIT__ 16"
.LASF190:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF285:
	.string	"__USQ_FBIT__ 32"
.LASF764:
	.string	"ds18b20crc8"
.LASF591:
	.string	"PRIXLEAST8 \"X\""
.LASF654:
	.string	"SCNuLEAST16 \"u\""
.LASF20:
	.string	"__SIZEOF_SHORT__ 2"
.LASF496:
	.string	"__USING_MINT8 0"
.LASF264:
	.string	"__LLACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-47LLK"
.LASF583:
	.string	"PRIoFAST8 \"o\""
.LASF462:
	.string	"_SIZE_T_DEFINED_ "
.LASF488:
	.string	"NULL"
.LASF698:
	.string	"ceilf ceil"
.LASF23:
	.string	"__SIZEOF_LONG_DOUBLE__ 4"
.LASF554:
	.string	"UINT8_C(c) __UINT8_C(c)"
.LASF322:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF548:
	.string	"WINT_MAX __WINT_MAX__"
.LASF302:
	.string	"__USA_IBIT__ 16"
.LASF366:
	.string	"__BUILTIN_AVR_ROUNDLLR 1"
.LASF658:
	.string	"SCNxFAST16 \"x\""
.LASF65:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF391:
	.string	"__BUILTIN_AVR_COUNTLSUHK 1"
.LASF668:
	.string	"SCNoPTR SCNo16"
.LASF429:
	.string	"__BUILTIN_AVR_COUNTLSFX 1"
.LASF208:
	.string	"__UFRACT_MIN__ 0.0UR"
.LASF318:
	.string	"__GCC_ATOMIC_LLONG_LOCK_FREE 1"
.LASF656:
	.string	"SCNx16 \"x\""
.LASF297:
	.string	"__TA_FBIT__ 47"
.LASF560:
	.string	"_GCC_WRAP_STDINT_H "
.LASF624:
	.string	"SCNi8 \"hhi\""
.LASF198:
	.string	"__USFRACT_MIN__ 0.0UHR"
.LASF598:
	.string	"PRIuFAST16 \"u\""
.LASF93:
	.string	"__UINT8_MAX__ 0xff"
.LASF393:
	.string	"__BUILTIN_AVR_COUNTLSULK 1"
.LASF434:
	.string	"__AVR_ATmega328P__ 1"
.LASF742:
	.string	"DS18B20_COMMAND_SEARCH_ROM 0xF0"
.LASF551:
	.string	"INT16_C(c) __INT16_C(c)"
.LASF578:
	.string	"PRIiFAST32 \"li\""
.LASF153:
	.string	"__DBL_HAS_DENORM__ 1"
.LASF568:
	.string	"PRIdLEAST16 \"d\""
.LASF571:
	.string	"PRIiLEAST16 \"i\""
.LASF702:
	.string	"coshf cosh"
.LASF627:
	.string	"SCNd16 \"d\""
.LASF713:
	.string	"isinff isinf"
.LASF295:
	.string	"__DA_FBIT__ 31"
.LASF755:
	.string	"long long int"
.LASF298:
	.string	"__TA_IBIT__ 16"
.LASF99:
	.string	"__INT_LEAST16_MAX__ 0x7fff"
.LASF639:
	.string	"SCNdPTR SCNd16"
.LASF421:
	.string	"__BUILTIN_AVR_LKBITS 1"
.LASF617:
	.string	"PRIoPTR PRIo16"
.LASF69:
	.string	"__has_include_next(STR) __has_include_next__(STR)"
.LASF110:
	.string	"__UINT32_C(c) c ## UL"
.LASF677:
	.string	"M_LN10 2.30258509299404568402"
.LASF248:
	.string	"__UACCUM_MIN__ 0.0UK"
.LASF411:
	.string	"__BUILTIN_AVR_HRBITS 1"
.LASF628:
	.string	"SCNdLEAST16 \"d\""
.LASF631:
	.string	"SCNiLEAST16 \"i\""
.LASF315:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 1"
.LASF58:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF138:
	.string	"__FLT_DENORM_MIN__ 1.40129846e-45F"
.LASF520:
	.string	"INT_LEAST64_MAX INT64_MAX"
.LASF666:
	.string	"SCNxLEAST32 \"lx\""
.LASF622:
	.string	"SCNdLEAST8 \"hhd\""
.LASF601:
	.string	"PRIxFAST16 \"x\""
.LASF483:
	.string	"__INT_WCHAR_T_H "
.LASF236:
	.string	"__USACCUM_FBIT__ 8"
.LASF470:
	.string	"__need_size_t"
.LASF319:
	.string	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1"
.LASF433:
	.string	"__ELF__ 1"
.LASF78:
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
.LASF168:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF579:
	.string	"PRIdPTR PRId16"
.LASF161:
	.string	"__LDBL_MAX_10_EXP__ 38"
.LASF375:
	.string	"__BUILTIN_AVR_ROUNDUHK 1"
.LASF469:
	.string	"__size_t "
.LASF91:
	.string	"__INT32_MAX__ 0x7fffffffL"
.LASF686:
	.string	"NAN __builtin_nan(\"\")"
.LASF499:
	.string	"INT8_MAX 0x7f"
.LASF105:
	.string	"__UINT_LEAST8_MAX__ 0xff"
.LASF494:
	.string	"__INTTYPES_H_ "
.LASF478:
	.string	"_BSD_WCHAR_T_ "
.LASF410:
	.string	"__BUILTIN_AVR_BITSULLK 1"
.LASF405:
	.string	"__BUILTIN_AVR_BITSLK 1"
.LASF431:
	.string	"__INT24_MIN__ (-__INT24_MAX__-1)"
.LASF262:
	.string	"__LLACCUM_IBIT__ 16"
.LASF379:
	.string	"__BUILTIN_AVR_COUNTLSHR 1"
.LASF506:
	.string	"INT32_MIN (-INT32_MAX - 1L)"
.LASF47:
	.string	"__UINT16_TYPE__ unsigned int"
.LASF183:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF707:
	.string	"atanf atan"
.LASF489:
	.string	"NULL ((void *)0)"
.LASF515:
	.string	"INT_LEAST16_MIN INT16_MIN"
.LASF196:
	.string	"__USFRACT_FBIT__ 8"
.LASF164:
	.string	"__LDBL_MIN__ 1.17549435e-38L"
.LASF360:
	.string	"__BUILTIN_AVR_ABSK 1"
.LASF490:
	.string	"__need_NULL"
.LASF308:
	.string	"__USER_LABEL_PREFIX__ "
.LASF96:
	.string	"__UINT64_MAX__ 0xffffffffffffffffULL"
.LASF596:
	.string	"PRIu16 \"u\""
.LASF95:
	.string	"__UINT32_MAX__ 0xffffffffUL"
.LASF97:
	.string	"__INT_LEAST8_MAX__ 0x7f"
.LASF700:
	.string	"ldexpf ldexp"
.LASF600:
	.string	"PRIxLEAST16 \"x\""
.LASF570:
	.string	"PRIi16 \"i\""
.LASF732:
	.string	"DS18B20_ERROR_PULL 3"
.LASF11:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF720:
	.string	"fminf fmin"
.LASF745:
	.string	"DS18B20_RES11 ( 2 << 5 )"
.LASF442:
	.string	"_ANSI_STDDEF_H "
.LASF68:
	.string	"__has_include(STR) __has_include__(STR)"
.LASF505:
	.string	"INT32_MAX 0x7fffffffL"
.LASF109:
	.string	"__UINT_LEAST32_MAX__ 0xffffffffUL"
.LASF32:
	.string	"__SIZEOF_POINTER__ 2"
.LASF524:
	.string	"INT_FAST8_MIN INT8_MIN"
.LASF765:
	.string	"ds18b20convert"
.LASF213:
	.string	"__LFRACT_MIN__ (-0.5LR-0.5LR)"
.LASF327:
	.string	"__AVR__ 1"
.LASF140:
	.string	"__FLT_HAS_INFINITY__ 1"
.LASF438:
	.string	"BOARD USER_BOARD"
.LASF244:
	.string	"__ACCUM_MAX__ 0X7FFFFFFFP-15K"
.LASF89:
	.string	"__INT8_MAX__ 0x7f"
.LASF321:
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
.LASF193:
	.string	"__SFRACT_MIN__ (-0.5HR-0.5HR)"
.LASF754:
	.string	"long unsigned int"
.LASF294:
	.string	"__SA_IBIT__ 16"
.LASF186:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF5:
	.string	"__GNUC__ 5"
.LASF780:
	.string	"ds18b20match"
.LASF585:
	.string	"PRIuLEAST8 \"u\""
.LASF340:
	.string	"__WITH_AVRLIBC__ 1"
.LASF457:
	.string	"_T_SIZE_ "
.LASF165:
	.string	"__LDBL_EPSILON__ 1.19209290e-7L"
.LASF119:
	.string	"__UINT_FAST32_MAX__ 0xffffffffUL"
.LASF332:
	.string	"__AVR_ENHANCED__ 1"
.LASF573:
	.string	"PRId32 \"ld\""
.LASF205:
	.string	"__FRACT_EPSILON__ 0x1P-15R"
.LASF602:
	.string	"PRIX16 \"X\""
.LASF407:
	.string	"__BUILTIN_AVR_BITSUHK 1"
.LASF605:
	.string	"PRIo32 \"lo\""
.LASF364:
	.string	"__BUILTIN_AVR_ROUNDR 1"
.LASF637:
	.string	"SCNiLEAST32 \"li\""
.LASF737:
	.string	"DS18B20_COMMAND_SKIP_ROM 0xCC"
.LASF338:
	.string	"__AVR_HAVE_SPH__ 1"
.LASF354:
	.string	"__BUILTIN_AVR_FLASH_SEGMENT 1"
.LASF725:
	.string	"DS18B20_H "
.LASF491:
	.string	"offsetof(TYPE,MEMBER) __builtin_offsetof (TYPE, MEMBER)"
.LASF112:
	.string	"__UINT64_C(c) c ## ULL"
.LASF57:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF547:
	.string	"WCHAR_MIN __WCHAR_MIN__"
.LASF606:
	.string	"PRIoLEAST32 \"lo\""
.LASF312:
	.string	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 1"
.LASF777:
	.string	"GNU C99 5.4.0 -mn-flash=1 -mno-skip-bug -mrelax -mmcu=avr5 -g3 -Og -std=gnu99 -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -fno-strict-aliasing"
.LASF367:
	.string	"__BUILTIN_AVR_ROUNDUHR 1"
.LASF608:
	.string	"PRIu32 \"lu\""
.LASF12:
	.string	"__ATOMIC_RELEASE 3"
.LASF409:
	.string	"__BUILTIN_AVR_BITSULK 1"
.LASF7:
	.string	"__GNUC_PATCHLEVEL__ 0"
.LASF128:
	.string	"__FLT_MANT_DIG__ 24"
.LASF374:
	.string	"__BUILTIN_AVR_ROUNDLLK 1"
.LASF705:
	.string	"acosf acos"
.LASF251:
	.string	"__LACCUM_FBIT__ 31"
.LASF739:
	.string	"DS18B20_COMMAND_WRITE_SP 0x4E"
.LASF15:
	.string	"__OPTIMIZE__ 1"
.LASF330:
	.string	"__AVR_HAVE_MOVW__ 1"
.LASF341:
	.string	"__FLASH 1"
.LASF444:
	.string	"_T_PTRDIFF_ "
.LASF521:
	.string	"INT_LEAST64_MIN INT64_MIN"
.LASF136:
	.string	"__FLT_MIN__ 1.17549435e-38F"
.LASF92:
	.string	"__INT64_MAX__ 0x7fffffffffffffffLL"
.LASF676:
	.string	"M_LN2 0.69314718055994530942"
.LASF66:
	.string	"__INTPTR_TYPE__ int"
.LASF504:
	.string	"UINT16_MAX (__CONCAT(INT16_MAX, U) * 2U + 1U)"
.LASF227:
	.string	"__ULLFRACT_IBIT__ 0"
.LASF378:
	.string	"__BUILTIN_AVR_ROUNDULLK 1"
.LASF612:
	.string	"PRIxLEAST32 \"lx\""
.LASF689:
	.string	"cosf cos"
.LASF412:
	.string	"__BUILTIN_AVR_RBITS 1"
.LASF328:
	.string	"AVR 1"
.LASF691:
	.string	"tanf tan"
.LASF474:
	.string	"_T_WCHAR_ "
.LASF152:
	.string	"__DBL_DENORM_MIN__ ((double)1.40129846e-45L)"
.LASF246:
	.string	"__UACCUM_FBIT__ 16"
.LASF363:
	.string	"__BUILTIN_AVR_ROUNDHR 1"
.LASF210:
	.string	"__UFRACT_EPSILON__ 0x1P-16UR"
.LASF8:
	.string	"__VERSION__ \"5.4.0\""
.LASF282:
	.string	"__UQQ_IBIT__ 0"
.LASF317:
	.string	"__GCC_ATOMIC_LONG_LOCK_FREE 1"
.LASF258:
	.string	"__ULACCUM_MIN__ 0.0ULK"
.LASF388:
	.string	"__BUILTIN_AVR_COUNTLSK 1"
.LASF200:
	.string	"__USFRACT_EPSILON__ 0x1P-8UHR"
.LASF339:
	.string	"__AVR_SFR_OFFSET__ 0x20"
.LASF460:
	.string	"_SIZE_T_ "
.LASF589:
	.string	"PRIxFAST8 \"x\""
.LASF127:
	.string	"__FLT_RADIX__ 2"
.LASF636:
	.string	"SCNi32 \"li\""
.LASF763:
	.string	"mask"
.LASF158:
	.string	"__LDBL_MIN_EXP__ (-125)"
.LASF169:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF443:
	.string	"_PTRDIFF_T "
.LASF365:
	.string	"__BUILTIN_AVR_ROUNDLR 1"
.LASF400:
	.string	"__BUILTIN_AVR_BITSUR 1"
.LASF432:
	.string	"__UINT24_MAX__ 16777215UL"
.LASF120:
	.string	"__UINT_FAST64_MAX__ 0xffffffffffffffffULL"
.LASF292:
	.string	"__HA_IBIT__ 8"
.LASF492:
	.string	"_UTIL_DELAY_H_ 1"
.LASF603:
	.string	"PRIXLEAST16 \"X\""
.LASF672:
	.string	"__MATH_H "
.LASF657:
	.string	"SCNxLEAST16 \"x\""
.LASF532:
	.string	"INT_FAST64_MAX INT64_MAX"
.LASF476:
	.string	"__WCHAR_T "
.LASF357:
	.string	"__BUILTIN_AVR_ABSLR 1"
.LASF103:
	.string	"__INT_LEAST64_MAX__ 0x7fffffffffffffffLL"
.LASF159:
	.string	"__LDBL_MIN_10_EXP__ (-37)"
.LASF619:
	.string	"PRIxPTR PRIx16"
.LASF536:
	.string	"INTPTR_MIN INT16_MIN"
.LASF45:
	.string	"__INT64_TYPE__ long long int"
.LASF211:
	.string	"__LFRACT_FBIT__ 31"
.LASF323:
	.string	"__SIZEOF_WCHAR_T__ 2"
.LASF79:
	.string	"__WINT_MAX__ 0x7fff"
.LASF113:
	.string	"__INT_FAST8_MAX__ 0x7f"
.LASF123:
	.string	"__GCC_IEC_559 0"
.LASF726:
	.string	"ONEWIRE_H "
.LASF81:
	.string	"__PTRDIFF_MAX__ 0x7fff"
.LASF403:
	.string	"__BUILTIN_AVR_BITSHK 1"
.LASF729:
	.string	"DS18B20_ERROR_OK 0"
.LASF342:
	.string	"__MEMX 1"
.LASF209:
	.string	"__UFRACT_MAX__ 0XFFFFP-16UR"
.LASF345:
	.string	"__BUILTIN_AVR_CLI 1"
.LASF192:
	.string	"__SFRACT_IBIT__ 0"
.LASF634:
	.string	"SCNdLEAST32 \"ld\""
.LASF640:
	.string	"SCNiPTR SCNi16"
.LASF30:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF717:
	.string	"fdimf fdim"
.LASF35:
	.string	"__WCHAR_TYPE__ int"
.LASF722:
	.string	"roundf round"
.LASF719:
	.string	"fmaxf fmax"
.LASF206:
	.string	"__UFRACT_FBIT__ 16"
.LASF287:
	.string	"__UDQ_FBIT__ 64"
.LASF503:
	.string	"INT16_MIN (-INT16_MAX - 1)"
.LASF748:
	.string	"unsigned int"
.LASF60:
	.string	"__INT_FAST32_TYPE__ long int"
.LASF512:
	.string	"INT_LEAST8_MIN INT8_MIN"
.LASF607:
	.string	"PRIoFAST32 \"lo\""
.LASF779:
	.string	"C:\\\\Users\\\\Joel\\\\Dropbox\\\\Projects\\\\hc3d\\\\hc3d-tm\\\\hc3d-tm\\\\Debug"
.LASF130:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF126:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF424:
	.string	"__BUILTIN_AVR_UKBITS 1"
.LASF595:
	.string	"PRIoFAST16 \"o\""
.LASF129:
	.string	"__FLT_DIG__ 6"
.LASF250:
	.string	"__UACCUM_EPSILON__ 0x1P-16UK"
.LASF527:
	.string	"INT_FAST16_MIN INT16_MIN"
.LASF485:
	.string	"_WCHAR_T_DECLARED "
.LASF25:
	.string	"__CHAR_BIT__ 8"
.LASF125:
	.string	"__FLT_EVAL_METHOD__ 0"
.LASF72:
	.string	"__SCHAR_MAX__ 0x7f"
.LASF580:
	.string	"PRIiPTR PRIi16"
.LASF743:
	.string	"DS18B20_RES09 ( 0 << 5 )"
.LASF445:
	.string	"_T_PTRDIFF "
.LASF281:
	.string	"__UQQ_FBIT__ 8"
.LASF661:
	.string	"SCNoFAST32 \"lo\""
.LASF642:
	.string	"SCNoLEAST8 \"hho\""
.LASF178:
	.string	"__DEC64_MIN_EXP__ (-382)"
.LASF249:
	.string	"__UACCUM_MAX__ 0XFFFFFFFFP-16UK"
.LASF565:
	.string	"PRIiLEAST8 \"i\""
.LASF325:
	.string	"__SIZEOF_PTRDIFF_T__ 2"
.LASF214:
	.string	"__LFRACT_MAX__ 0X7FFFFFFFP-31LR"
.LASF538:
	.string	"INTMAX_MAX INT64_MAX"
.LASF353:
	.string	"__BUILTIN_AVR_INSERT_BITS 1"
.LASF451:
	.string	"_PTRDIFF_T_DECLARED "
.LASF584:
	.string	"PRIu8 \"u\""
.LASF562:
	.string	"PRIdLEAST8 \"d\""
.LASF31:
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF46:
	.string	"__UINT8_TYPE__ unsigned char"
.LASF54:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF184:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF301:
	.string	"__USA_FBIT__ 16"
.LASF559:
	.string	"UINTMAX_C(c) __UINTMAX_C(c)"
.LASF759:
	.string	"byte"
.LASF753:
	.string	"long int"
.LASF311:
	.string	"__GCC_ATOMIC_CHAR_LOCK_FREE 1"
.LASF215:
	.string	"__LFRACT_EPSILON__ 0x1P-31LR"
.LASF326:
	.string	"__AVR 1"
.LASF53:
	.string	"__INT_LEAST64_TYPE__ long long int"
.LASF426:
	.string	"__BUILTIN_AVR_ULLKBITS 1"
.LASF146:
	.string	"__DBL_MAX_EXP__ 128"
.LASF750:
	.string	"unsigned char"
.LASF621:
	.string	"SCNd8 \"hhd\""
.LASF623:
	.string	"SCNdFAST8 \"hhd\""
.LASF114:
	.string	"__INT_FAST16_MAX__ 0x7fff"
.LASF473:
	.string	"_WCHAR_T "
.LASF641:
	.string	"SCNo8 \"hho\""
.LASF26:
	.string	"__BIGGEST_ALIGNMENT__ 1"
.LASF170:
	.string	"__DEC32_MANT_DIG__ 7"
.LASF355:
	.string	"__BUILTIN_AVR_ABSHR 1"
.LASF706:
	.string	"asinf asin"
.LASF450:
	.string	"_GCC_PTRDIFF_T "
.LASF690:
	.string	"sinf sin"
.LASF455:
	.string	"_SIZE_T "
.LASF481:
	.string	"_WCHAR_T_H "
.LASF172:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF376:
	.string	"__BUILTIN_AVR_ROUNDUK 1"
.LASF644:
	.string	"SCNu8 \"hhu\""
.LASF384:
	.string	"__BUILTIN_AVR_COUNTLSUR 1"
.LASF76:
	.string	"__LONG_LONG_MAX__ 0x7fffffffffffffffLL"
.LASF143:
	.string	"__DBL_DIG__ 6"
.LASF525:
	.string	"UINT_FAST8_MAX UINT8_MAX"
.LASF82:
	.string	"__SIZE_MAX__ 0xffffU"
.LASF678:
	.string	"M_PI 3.14159265358979323846"
.LASF207:
	.string	"__UFRACT_IBIT__ 0"
.LASF17:
	.string	"__SIZEOF_INT__ 2"
.LASF98:
	.string	"__INT8_C(c) c"
.LASF212:
	.string	"__LFRACT_IBIT__ 0"
.LASF441:
	.string	"_STDDEF_H_ "
.LASF320:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 1"
.LASF459:
	.string	"__SIZE_T "
.LASF774:
	.string	"onewireWrite"
.LASF567:
	.string	"PRId16 \"d\""
.LASF516:
	.string	"UINT_LEAST16_MAX UINT16_MAX"
.LASF500:
	.string	"INT8_MIN (-INT8_MAX - 1)"
.LASF349:
	.string	"__BUILTIN_AVR_FMUL 1"
.LASF736:
	.string	"DS18B20_COMMAND_MATCH_ROM 0x55"
.LASF530:
	.string	"INT_FAST32_MIN INT32_MIN"
.LASF684:
	.string	"M_SQRT2 1.41421356237309504880"
.LASF534:
	.string	"UINT_FAST64_MAX UINT64_MAX"
.LASF387:
	.string	"__BUILTIN_AVR_COUNTLSHK 1"
.LASF687:
	.string	"INFINITY __builtin_inf()"
.LASF498:
	.string	"__CONCAT(left,right) __CONCATenate(left, right)"
.LASF167:
	.string	"__LDBL_HAS_DENORM__ 1"
.LASF267:
	.string	"__ULLACCUM_IBIT__ 16"
.LASF243:
	.string	"__ACCUM_MIN__ (-0X1P15K-0X1P15K)"
.LASF484:
	.string	"_GCC_WCHAR_T "
.LASF423:
	.string	"__BUILTIN_AVR_UHKBITS 1"
.LASF52:
	.string	"__INT_LEAST32_TYPE__ long int"
.LASF137:
	.string	"__FLT_EPSILON__ 1.19209290e-7F"
.LASF710:
	.string	"log10f log10"
.LASF160:
	.string	"__LDBL_MAX_EXP__ 128"
.LASF111:
	.string	"__UINT_LEAST64_MAX__ 0xffffffffffffffffULL"
.LASF202:
	.string	"__FRACT_IBIT__ 0"
.LASF428:
	.string	"__BUILTIN_AVR_ROUNDFX 1"
.LASF383:
	.string	"__BUILTIN_AVR_COUNTLSUHR 1"
.LASF389:
	.string	"__BUILTIN_AVR_COUNTLSLK 1"
.LASF27:
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
.LASF390:
	.string	"__BUILTIN_AVR_COUNTLSLLK 1"
.LASF177:
	.string	"__DEC64_MANT_DIG__ 16"
.LASF756:
	.string	"long long unsigned int"
.LASF511:
	.string	"INT_LEAST8_MAX INT8_MAX"
.LASF257:
	.string	"__ULACCUM_IBIT__ 32"
.LASF517:
	.string	"INT_LEAST32_MAX INT32_MAX"
.LASF73:
	.string	"__SHRT_MAX__ 0x7fff"
.LASF34:
	.string	"__PTRDIFF_TYPE__ int"
.LASF463:
	.string	"_SIZE_T_DEFINED "
.LASF277:
	.string	"__DQ_FBIT__ 63"
.LASF41:
	.string	"__SIG_ATOMIC_TYPE__ char"
.LASF758:
	.string	"length"
.LASF582:
	.string	"PRIoLEAST8 \"o\""
.LASF446:
	.string	"__PTRDIFF_T "
.LASF284:
	.string	"__UHQ_IBIT__ 0"
.LASF59:
	.string	"__INT_FAST16_TYPE__ int"
.LASF385:
	.string	"__BUILTIN_AVR_COUNTLSULR 1"
.LASF233:
	.string	"__SACCUM_MIN__ (-0X1P7HK-0X1P7HK)"
.LASF219:
	.string	"__ULFRACT_MAX__ 0XFFFFFFFFP-32ULR"
.LASF88:
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
.LASF74:
	.string	"__INT_MAX__ 0x7fff"
.LASF254:
	.string	"__LACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-31LK"
.LASF362:
	.string	"__BUILTIN_AVR_ABSLLK 1"
.LASF166:
	.string	"__LDBL_DENORM_MIN__ 1.40129846e-45L"
.LASF638:
	.string	"SCNiFAST32 \"li\""
.LASF16:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF630:
	.string	"SCNi16 \"i\""
.LASF495:
	.string	"__STDINT_H_ "
.LASF740:
	.string	"DS18B20_COMMAND_READ_SP 0xBE"
.LASF352:
	.string	"__BUILTIN_AVR_DELAY_CYCLES 1"
.LASF683:
	.string	"M_2_SQRTPI 1.12837916709551257390"
.LASF350:
	.string	"__BUILTIN_AVR_FMULS 1"
.LASF480:
	.string	"_WCHAR_T_DEFINED "
.LASF259:
	.string	"__ULACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-32ULK"
.LASF269:
	.string	"__ULLACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-48ULLK"
.LASF731:
	.string	"DS18B20_ERROR_CRC 2"
.LASF218:
	.string	"__ULFRACT_MIN__ 0.0ULR"
.LASF163:
	.string	"__LDBL_MAX__ 3.40282347e+38L"
.LASF278:
	.string	"__DQ_IBIT__ 0"
.LASF329:
	.string	"__AVR_ARCH__ 5"
.LASF44:
	.string	"__INT32_TYPE__ long int"
.LASF334:
	.string	"__AVR_HAVE_JMP_CALL__ 1"
.LASF436:
	.string	"__AVR_DEV_LIB_NAME__ m328p"
.LASF461:
	.string	"_BSD_SIZE_T_ "
.LASF477:
	.string	"_WCHAR_T_ "
.LASF694:
	.string	"cbrtf cbrt"
.LASF522:
	.string	"UINT_LEAST64_MAX UINT64_MAX"
.LASF728:
	.string	"ONEWIRE_ERROR_COMM 1"
.LASF290:
	.string	"__UTQ_IBIT__ 0"
.LASF346:
	.string	"__BUILTIN_AVR_WDR 1"
.LASF293:
	.string	"__SA_FBIT__ 15"
.LASF771:
	.string	"temperature"
.LASF514:
	.string	"INT_LEAST16_MAX INT16_MAX"
.LASF528:
	.string	"UINT_FAST16_MAX UINT16_MAX"
.LASF408:
	.string	"__BUILTIN_AVR_BITSUK 1"
.LASF272:
	.string	"__QQ_IBIT__ 0"
.LASF540:
	.string	"UINTMAX_MAX UINT64_MAX"
.LASF674:
	.string	"M_LOG2E 1.4426950408889634074"
.LASF594:
	.string	"PRIoLEAST16 \"o\""
.LASF38:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF286:
	.string	"__USQ_IBIT__ 0"
.LASF402:
	.string	"__BUILTIN_AVR_BITSULLR 1"
.LASF6:
	.string	"__GNUC_MINOR__ 4"
.LASF56:
	.string	"__UINT_LEAST32_TYPE__ long unsigned int"
.LASF733:
	.string	"DS18B20_ERROR_OTHER 4"
.LASF37:
	.string	"__INTMAX_TYPE__ long long int"
.LASF316:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 1"
.LASF537:
	.string	"UINTPTR_MAX UINT16_MAX"
.LASF697:
	.string	"floorf floor"
.LASF398:
	.string	"__BUILTIN_AVR_BITSLLR 1"
.LASF468:
	.string	"_SIZET_ "
.LASF588:
	.string	"PRIxLEAST8 \"x\""
.LASF240:
	.string	"__USACCUM_EPSILON__ 0x1P-8UHK"
.LASF155:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF415:
	.string	"__BUILTIN_AVR_UHRBITS 1"
.LASF224:
	.string	"__LLFRACT_MAX__ 0X7FFFFFFFFFFFFFFFP-63LLR"
.LASF632:
	.string	"SCNiFAST16 \"i\""
.LASF507:
	.string	"UINT32_MAX (__CONCAT(INT32_MAX, U) * 2UL + 1UL)"
.LASF660:
	.string	"SCNoLEAST32 \"lo\""
.LASF234:
	.string	"__SACCUM_MAX__ 0X7FFFP-7HK"
.LASF356:
	.string	"__BUILTIN_AVR_ABSR 1"
.LASF67:
	.string	"__UINTPTR_TYPE__ unsigned int"
.LASF307:
	.string	"__REGISTER_PREFIX__ "
.LASF145:
	.string	"__DBL_MIN_10_EXP__ (-37)"
.LASF220:
	.string	"__ULFRACT_EPSILON__ 0x1P-32ULR"
.LASF24:
	.string	"__SIZEOF_SIZE_T__ 2"
.LASF609:
	.string	"PRIuLEAST32 \"lu\""
.LASF49:
	.string	"__UINT64_TYPE__ long long unsigned int"
.LASF187:
	.string	"__DEC128_MIN__ 1E-6143DL"
.LASF261:
	.string	"__LLACCUM_FBIT__ 47"
.LASF760:
	.string	"port"
.LASF87:
	.string	"__SIG_ATOMIC_MAX__ 0x7f"
.LASF493:
	.string	"__HAS_DELAY_CYCLES 1"
.LASF711:
	.string	"powf pow"
.LASF427:
	.string	"__BUILTIN_AVR_ABSFX 1"
.LASF741:
	.string	"DS18B20_COMMAND_COPY_SP 0x48"
.LASF369:
	.string	"__BUILTIN_AVR_ROUNDULR 1"
.LASF242:
	.string	"__ACCUM_IBIT__ 16"
.LASF62:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF747:
	.string	"DS18B20_MUL 16"
.LASF533:
	.string	"INT_FAST64_MIN INT64_MIN"
.LASF404:
	.string	"__BUILTIN_AVR_BITSK 1"
.LASF148:
	.string	"__DBL_DECIMAL_DIG__ 9"
.LASF440:
	.string	"_STDDEF_H "
.LASF651:
	.string	"SCNoLEAST16 \"o\""
.LASF304:
	.string	"__UDA_IBIT__ 32"
.LASF9:
	.string	"__ATOMIC_RELAXED 0"
.LASF394:
	.string	"__BUILTIN_AVR_COUNTLSULLK 1"
.LASF752:
	.string	"int16_t"
.LASF659:
	.string	"SCNo32 \"lo\""
.LASF564:
	.string	"PRIi8 \"i\""
.LASF688:
	.string	"__ATTR_CONST__ __attribute__((__const__))"
.LASF21:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF180:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF452:
	.string	"__need_ptrdiff_t"
.LASF447:
	.string	"_PTRDIFF_T_ "
.LASF399:
	.string	"__BUILTIN_AVR_BITSUHR 1"
.LASF509:
	.string	"INT64_MIN (-INT64_MAX - 1LL)"
.LASF572:
	.string	"PRIiFAST16 \"i\""
.LASF90:
	.string	"__INT16_MAX__ 0x7fff"
.LASF406:
	.string	"__BUILTIN_AVR_BITSLLK 1"
.LASF118:
	.string	"__UINT_FAST16_MAX__ 0xffffU"
.LASF502:
	.string	"INT16_MAX 0x7fff"
.LASF271:
	.string	"__QQ_FBIT__ 7"
.LASF501:
	.string	"UINT8_MAX (INT8_MAX * 2 + 1)"
.LASF230:
	.string	"__ULLFRACT_EPSILON__ 0x1P-64ULLR"
.LASF587:
	.string	"PRIx8 \"x\""
.LASF115:
	.string	"__INT_FAST32_MAX__ 0x7fffffffL"
.LASF401:
	.string	"__BUILTIN_AVR_BITSULR 1"
.LASF392:
	.string	"__BUILTIN_AVR_COUNTLSUK 1"
.LASF324:
	.string	"__SIZEOF_WINT_T__ 2"
.LASF590:
	.string	"PRIX8 \"X\""
.LASF107:
	.string	"__UINT_LEAST16_MAX__ 0xffffU"
.LASF351:
	.string	"__BUILTIN_AVR_FMULSU 1"
.LASF0:
	.string	"__STDC__ 1"
.LASF773:
	.string	"ds18b20rom"
.LASF372:
	.string	"__BUILTIN_AVR_ROUNDK 1"
.LASF253:
	.string	"__LACCUM_MIN__ (-0X1P31LK-0X1P31LK)"
.LASF670:
	.string	"SCNxPTR SCNx16"
.LASF171:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF268:
	.string	"__ULLACCUM_MIN__ 0.0ULLK"
.LASF620:
	.string	"PRIXPTR PRIX16"
.LASF75:
	.string	"__LONG_MAX__ 0x7fffffffL"
.LASF482:
	.string	"___int_wchar_t_h "
.LASF370:
	.string	"__BUILTIN_AVR_ROUNDULLR 1"
.LASF541:
	.string	"PTRDIFF_MAX INT16_MAX"
.LASF48:
	.string	"__UINT32_TYPE__ long unsigned int"
.LASF724:
	.string	"lrintf lrint"
.LASF539:
	.string	"INTMAX_MIN INT64_MIN"
.LASF692:
	.string	"fabsf fabs"
.LASF593:
	.string	"PRIo16 \"o\""
.LASF142:
	.string	"__DBL_MANT_DIG__ 24"
.LASF467:
	.string	"_GCC_SIZE_T "
.LASF417:
	.string	"__BUILTIN_AVR_ULRBITS 1"
.LASF696:
	.string	"squaref square"
.LASF228:
	.string	"__ULLFRACT_MIN__ 0.0ULLR"
.LASF288:
	.string	"__UDQ_IBIT__ 0"
.LASF535:
	.string	"INTPTR_MAX INT16_MAX"
.LASF486:
	.string	"_BSD_WCHAR_T_"
.LASF222:
	.string	"__LLFRACT_IBIT__ 0"
.LASF472:
	.string	"__WCHAR_T__ "
.LASF380:
	.string	"__BUILTIN_AVR_COUNTLSR 1"
.LASF223:
	.string	"__LLFRACT_MIN__ (-0.5LLR-0.5LLR)"
.LASF414:
	.string	"__BUILTIN_AVR_LLRBITS 1"
.LASF43:
	.string	"__INT16_TYPE__ int"
.LASF235:
	.string	"__SACCUM_EPSILON__ 0x1P-7HK"
.LASF121:
	.string	"__INTPTR_MAX__ 0x7fff"
.LASF679:
	.string	"M_PI_2 1.57079632679489661923"
.LASF626:
	.string	"SCNiFAST8 \"hhi\""
.LASF625:
	.string	"SCNiLEAST8 \"hhi\""
.LASF664:
	.string	"SCNuFAST32 \"lu\""
.LASF649:
	.string	"SCNxFAST8 \"hhx\""
.LASF63:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF704:
	.string	"tanhf tanh"
.LASF300:
	.string	"__UHA_IBIT__ 8"
.LASF245:
	.string	"__ACCUM_EPSILON__ 0x1P-15K"
.LASF260:
	.string	"__ULACCUM_EPSILON__ 0x1P-32ULK"
.LASF721:
	.string	"truncf trunc"
.LASF182:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF333:
	.string	"__AVR_HAVE_MUL__ 1"
.LASF221:
	.string	"__LLFRACT_FBIT__ 63"
.LASF471:
	.string	"__wchar_t__ "
.LASF645:
	.string	"SCNuLEAST8 \"hhu\""
.LASF586:
	.string	"PRIuFAST8 \"u\""
.LASF273:
	.string	"__HQ_FBIT__ 15"
.LASF395:
	.string	"__BUILTIN_AVR_BITSHR 1"
.LASF266:
	.string	"__ULLACCUM_FBIT__ 48"
.LASF561:
	.string	"PRId8 \"d\""
.LASF336:
	.string	"__AVR_2_BYTE_PC__ 1"
.LASF558:
	.string	"INTMAX_C(c) __INTMAX_C(c)"
.LASF154:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF430:
	.string	"__INT24_MAX__ 8388607L"
.LASF156:
	.string	"__LDBL_MANT_DIG__ 24"
.LASF599:
	.string	"PRIx16 \"x\""
.LASF397:
	.string	"__BUILTIN_AVR_BITSLR 1"
.LASF225:
	.string	"__LLFRACT_EPSILON__ 0x1P-63LLR"
.LASF194:
	.string	"__SFRACT_MAX__ 0X7FP-7HR"
.LASF418:
	.string	"__BUILTIN_AVR_ULLRBITS 1"
.LASF574:
	.string	"PRIdLEAST32 \"ld\""
.LASF100:
	.string	"__INT16_C(c) c"
.LASF296:
	.string	"__DA_IBIT__ 32"
.LASF419:
	.string	"__BUILTIN_AVR_HKBITS 1"
.LASF611:
	.string	"PRIx32 \"lx\""
.LASF197:
	.string	"__USFRACT_IBIT__ 0"
.LASF647:
	.string	"SCNx8 \"hhx\""
.LASF377:
	.string	"__BUILTIN_AVR_ROUNDULK 1"
.LASF13:
	.string	"__ATOMIC_ACQ_REL 4"
.LASF274:
	.string	"__HQ_IBIT__ 0"
.LASF479:
	.string	"_WCHAR_T_DEFINED_ "
.LASF709:
	.string	"logf log"
.LASF757:
	.string	"data"
.LASF523:
	.string	"INT_FAST8_MAX INT8_MAX"
.LASF769:
	.string	"ds18b20csp"
.LASF715:
	.string	"copysignf copysign"
.LASF191:
	.string	"__SFRACT_FBIT__ 7"
.LASF144:
	.string	"__DBL_MIN_EXP__ (-125)"
.LASF557:
	.string	"UINT64_C(c) __UINT64_C(c)"
.LASF673:
	.string	"M_E 2.7182818284590452354"
.LASF85:
	.string	"__UINTMAX_MAX__ 0xffffffffffffffffULL"
.LASF381:
	.string	"__BUILTIN_AVR_COUNTLSLR 1"
.LASF217:
	.string	"__ULFRACT_IBIT__ 0"
.LASF671:
	.string	"_UTIL_DELAY_BASIC_H_ 1"
.LASF518:
	.string	"INT_LEAST32_MIN INT32_MIN"
.LASF289:
	.string	"__UTQ_FBIT__ 128"
.LASF708:
	.string	"atan2f atan2"
.LASF734:
	.string	"DS18B20_OK DS18B20_ERROR_OK"
.LASF231:
	.string	"__SACCUM_FBIT__ 7"
.LASF778:
	.string	"../src/libraries/avr-ds80b20/ds18b20.c"
.LASF513:
	.string	"UINT_LEAST8_MAX UINT8_MAX"
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.6.2_1778) 5.4.0"
