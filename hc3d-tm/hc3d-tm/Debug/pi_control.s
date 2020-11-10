	.file	"pi_control.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.section	.text.pi_control,"ax",@progbits
.global	pi_control
	.type	pi_control, @function
pi_control:
.LFB0:
	.file 1 "../src/libraries/pi_control/pi_control.c"
	.loc 1 33 0
	.cfi_startproc
.LVL0:
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
	push r28
.LCFI8:
	.cfi_def_cfa_offset 11
	.cfi_offset 28, -10
	push r29
.LCFI9:
	.cfi_def_cfa_offset 12
	.cfi_offset 29, -11
/* prologue: function */
/* frame size = 0 */
/* stack size = 10 */
.L__stack_usage = 10
	movw r30,r24
	movw r28,r22
	.loc 1 39 0
	ldd r12,Z+9
	ldd r13,Z+10
	ldd r14,Z+11
	ldd r15,Z+12
	movw r18,r22
	lsl r23
	sbc r20,r20
	sbc r21,r21
	add r12,r18
	adc r13,r19
	adc r14,r20
	adc r15,r21
.LVL1:
	.loc 1 40 0
	ld r26,Z
	ldd r27,Z+1
	call __mulshisi3
.LVL2:
	movw r8,r22
	movw r10,r24
	ldd r26,Z+2
	ldd r27,Z+3
	movw r20,r14
	movw r18,r12
	call __mulshisi3
	movw r20,r22
	movw r22,r24
	add r20,r8
	adc r21,r9
	adc r22,r10
	adc r23,r11
	ldd r0,Z+4
	rjmp 2f
	1:
	asr r23
	ror r22
	ror r21
	ror r20
	2:
	dec r0
	brpl 1b
.LVL3:
	.loc 1 47 0
	ldd r24,Z+5
	ldd r25,Z+6
.LVL4:
	mov __tmp_reg__,r25
	lsl r0
	sbc r26,r26
	sbc r27,r27
	cp r24,r20
	cpc r25,r21
	cpc r26,r22
	cpc r27,r23
	brge .L2
.LVL5:
	.loc 1 53 0
	cp __zero_reg__,r28
	cpc __zero_reg__,r29
	brlt .L5
	.loc 1 44 0
	ldi r18,lo8(1)
	rjmp .L3
.LVL6:
.L2:
	.loc 1 59 0
	ldd r24,Z+7
	ldd r25,Z+8
	mov __tmp_reg__,r25
	lsl r0
	sbc r26,r26
	sbc r27,r27
	cp r20,r24
	cpc r21,r25
	cpc r22,r26
	cpc r23,r27
	brge .L6
.LVL7:
	.loc 1 63 0
	tst r29
	brlt .L7
	.loc 1 44 0
	ldi r18,lo8(1)
	rjmp .L3
.L5:
	.loc 1 55 0
	ldi r18,0
	rjmp .L3
.LVL8:
.L6:
	.loc 1 40 0
	movw r26,r22
	movw r24,r20
	.loc 1 44 0
	ldi r18,lo8(1)
	rjmp .L3
.LVL9:
.L7:
	.loc 1 65 0
	ldi r18,0
.L3:
.LVL10:
	.loc 1 70 0
	tst r18
	breq .L4
	.loc 1 72 0
	std Z+9,r12
	std Z+10,r13
	std Z+11,r14
	std Z+12,r15
.L4:
/* epilogue start */
	.loc 1 76 0
	pop r29
	pop r28
.LVL11:
	pop r15
	pop r14
	pop r13
	pop r12
.LVL12:
	pop r11
	pop r10
	pop r9
	pop r8
	ret
	.cfi_endproc
.LFE0:
	.size	pi_control, .-pi_control
	.section	.text.pi_control_init,"ax",@progbits
.global	pi_control_init
	.type	pi_control_init, @function
pi_control_init:
.LFB1:
	.loc 1 86 0
	.cfi_startproc
.LVL13:
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	.loc 1 87 0
	movw r30,r24
	std Z+9,__zero_reg__
	std Z+10,__zero_reg__
	std Z+11,__zero_reg__
	std Z+12,__zero_reg__
	ret
	.cfi_endproc
.LFE1:
	.size	pi_control_init, .-pi_control_init
	.text
.Letext0:
	.file 2 "../src/libraries/pi_control/pi_control.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x134
	.word	0x2
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF451
	.byte	0xc
	.long	.LASF452
	.long	.LASF453
	.long	.Ldebug_ranges0+0
	.long	0
	.long	0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.long	.LASF454
	.byte	0xd
	.byte	0x2
	.byte	0x1c
	.long	0x8a
	.uleb128 0x3
	.string	"kp"
	.byte	0x2
	.byte	0x1e
	.long	0x8a
	.byte	0x2
	.byte	0x23
	.uleb128 0
	.uleb128 0x3
	.string	"ki"
	.byte	0x2
	.byte	0x1f
	.long	0x8a
	.byte	0x2
	.byte	0x23
	.uleb128 0x2
	.uleb128 0x4
	.long	.LASF445
	.byte	0x2
	.byte	0x20
	.long	0x91
	.byte	0x2
	.byte	0x23
	.uleb128 0x4
	.uleb128 0x3
	.string	"max"
	.byte	0x2
	.byte	0x21
	.long	0x8a
	.byte	0x2
	.byte	0x23
	.uleb128 0x5
	.uleb128 0x3
	.string	"min"
	.byte	0x2
	.byte	0x22
	.long	0x8a
	.byte	0x2
	.byte	0x23
	.uleb128 0x7
	.uleb128 0x3
	.string	"i"
	.byte	0x2
	.byte	0x23
	.long	0x98
	.byte	0x2
	.byte	0x23
	.uleb128 0x9
	.byte	0
	.uleb128 0x5
	.byte	0x2
	.byte	0x5
	.string	"int"
	.uleb128 0x6
	.byte	0x1
	.byte	0x8
	.long	.LASF446
	.uleb128 0x6
	.byte	0x4
	.byte	0x5
	.long	.LASF447
	.uleb128 0x7
	.byte	0x1
	.long	.LASF455
	.byte	0x1
	.byte	0x20
	.byte	0x1
	.long	0x8a
	.long	.LFB0
	.long	.LFE0
	.long	.LLST0
	.byte	0x1
	.long	0x103
	.uleb128 0x8
	.string	"p"
	.byte	0x1
	.byte	0x20
	.long	0x103
	.long	.LLST1
	.uleb128 0x8
	.string	"e"
	.byte	0x1
	.byte	0x20
	.long	0x8a
	.long	.LLST2
	.uleb128 0x9
	.long	.LASF448
	.byte	0x1
	.byte	0x22
	.long	0x109
	.long	.LLST3
	.uleb128 0x9
	.long	.LASF449
	.byte	0x1
	.byte	0x23
	.long	0x98
	.long	.LLST4
	.uleb128 0xa
	.string	"u"
	.byte	0x1
	.byte	0x24
	.long	0x98
	.long	.LLST5
	.byte	0
	.uleb128 0xb
	.byte	0x2
	.long	0x2d
	.uleb128 0x6
	.byte	0x1
	.byte	0x2
	.long	.LASF450
	.uleb128 0xc
	.byte	0x1
	.long	.LASF456
	.byte	0x1
	.byte	0x55
	.byte	0x1
	.long	.LFB1
	.long	.LFE1
	.byte	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.byte	0x1
	.uleb128 0xd
	.string	"p"
	.byte	0x1
	.byte	0x55
	.long	0x103
	.byte	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.byte	0
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
	.uleb128 0x13
	.byte	0x1
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x1
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x3
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0x8
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x4
	.uleb128 0xd
	.byte	0
	.uleb128 0x3
	.uleb128 0xe
	.uleb128 0x3a
	.uleb128 0xb
	.uleb128 0x3b
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.uleb128 0x38
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x5
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
	.uleb128 0x6
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
	.uleb128 0x7
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
	.uleb128 0x8
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
	.uleb128 0xb
	.uleb128 0xf
	.byte	0
	.uleb128 0xb
	.uleb128 0xb
	.uleb128 0x49
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0xc
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
	.uleb128 0xa
	.uleb128 0x2117
	.uleb128 0xc
	.byte	0
	.byte	0
	.uleb128 0xd
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
	.uleb128 0xa
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST0:
	.long	.LFB0
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
	.long	.LFE0
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 12
	.long	0
	.long	0
.LLST1:
	.long	.LVL0
	.long	.LVL4
	.word	0x6
	.byte	0x68
	.byte	0x93
	.uleb128 0x1
	.byte	0x69
	.byte	0x93
	.uleb128 0x1
	.long	.LVL4
	.long	.LFE0
	.word	0x6
	.byte	0x6e
	.byte	0x93
	.uleb128 0x1
	.byte	0x6f
	.byte	0x93
	.uleb128 0x1
	.long	0
	.long	0
.LLST2:
	.long	.LVL0
	.long	.LVL2
	.word	0x6
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL2
	.long	.LVL11
	.word	0x6
	.byte	0x6c
	.byte	0x93
	.uleb128 0x1
	.byte	0x6d
	.byte	0x93
	.uleb128 0x1
	.long	.LVL11
	.long	.LFE0
	.word	0x4
	.byte	0xf3
	.uleb128 0x1
	.byte	0x66
	.byte	0x9f
	.long	0
	.long	0
.LLST3:
	.long	.LVL3
	.long	.LVL10
	.word	0x2
	.byte	0x31
	.byte	0x9f
	.long	.LVL10
	.long	.LFE0
	.word	0x1
	.byte	0x62
	.long	0
	.long	0
.LLST4:
	.long	.LVL1
	.long	.LVL12
	.word	0xc
	.byte	0x5c
	.byte	0x93
	.uleb128 0x1
	.byte	0x5d
	.byte	0x93
	.uleb128 0x1
	.byte	0x5e
	.byte	0x93
	.uleb128 0x1
	.byte	0x5f
	.byte	0x93
	.uleb128 0x1
	.long	0
	.long	0
.LLST5:
	.long	.LVL3
	.long	.LVL5
	.word	0xc
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL6
	.long	.LVL7
	.word	0xc
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	.LVL8
	.long	.LVL9
	.word	0xc
	.byte	0x64
	.byte	0x93
	.uleb128 0x1
	.byte	0x65
	.byte	0x93
	.uleb128 0x1
	.byte	0x66
	.byte	0x93
	.uleb128 0x1
	.byte	0x67
	.byte	0x93
	.uleb128 0x1
	.long	0
	.long	0
	.section	.debug_aranges,"",@progbits
	.long	0x24
	.word	0x2
	.long	.Ldebug_info0
	.byte	0x4
	.byte	0
	.word	0
	.word	0
	.long	.LFB0
	.long	.LFE0-.LFB0
	.long	.LFB1
	.long	.LFE1-.LFB1
	.long	0
	.long	0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.long	.LFB0
	.long	.LFE0
	.long	.LFB1
	.long	.LFE1
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
	.file 3 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\lib\\gcc\\avr\\5.4.0\\include\\stdbool.h"
	.byte	0x3
	.uleb128 0x15
	.uleb128 0x3
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.byte	0x3
	.uleb128 0x16
	.uleb128 0x2
	.byte	0x4
	.byte	0x4
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stdbool.h.29.07dce69c3b78884144b7f7bd19483461,comdat
.Ldebug_macro1:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF440
	.byte	0x5
	.uleb128 0x21
	.long	.LASF441
	.byte	0x5
	.uleb128 0x22
	.long	.LASF442
	.byte	0x5
	.uleb128 0x23
	.long	.LASF443
	.byte	0x5
	.uleb128 0x34
	.long	.LASF444
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF36:
	.string	"__WINT_TYPE__ int"
.LASF447:
	.string	"long int"
.LASF135:
	.string	"__FLT_MAX__ 3.40282347e+38F"
.LASF183:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF455:
	.string	"pi_control"
.LASF131:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF182:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF260:
	.string	"__ULACCUM_EPSILON__ 0x1P-32ULK"
.LASF424:
	.string	"__BUILTIN_AVR_UKBITS 1"
.LASF333:
	.string	"__AVR_HAVE_MUL__ 1"
.LASF106:
	.string	"__UINT8_C(c) c"
.LASF395:
	.string	"__BUILTIN_AVR_BITSHR 1"
.LASF272:
	.string	"__QQ_IBIT__ 0"
.LASF288:
	.string	"__UDQ_IBIT__ 0"
.LASF368:
	.string	"__BUILTIN_AVR_ROUNDUR 1"
.LASF226:
	.string	"__ULLFRACT_FBIT__ 64"
.LASF262:
	.string	"__LLACCUM_IBIT__ 16"
.LASF312:
	.string	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 1"
.LASF69:
	.string	"__has_include_next(STR) __has_include_next__(STR)"
.LASF324:
	.string	"__SIZEOF_WINT_T__ 2"
.LASF222:
	.string	"__LLFRACT_IBIT__ 0"
.LASF152:
	.string	"__DBL_DENORM_MIN__ ((double)1.40129846e-45L)"
.LASF161:
	.string	"__LDBL_MAX_10_EXP__ 38"
.LASF198:
	.string	"__USFRACT_MIN__ 0.0UHR"
.LASF6:
	.string	"__GNUC_MINOR__ 4"
.LASF384:
	.string	"__BUILTIN_AVR_COUNTLSUR 1"
.LASF374:
	.string	"__BUILTIN_AVR_ROUNDLLK 1"
.LASF373:
	.string	"__BUILTIN_AVR_ROUNDLK 1"
.LASF344:
	.string	"__BUILTIN_AVR_SEI 1"
.LASF24:
	.string	"__SIZEOF_SIZE_T__ 2"
.LASF20:
	.string	"__SIZEOF_SHORT__ 2"
.LASF23:
	.string	"__SIZEOF_LONG_DOUBLE__ 4"
.LASF337:
	.string	"__AVR_HAVE_16BIT_SP__ 1"
.LASF5:
	.string	"__GNUC__ 5"
.LASF28:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF229:
	.string	"__ULLFRACT_MAX__ 0XFFFFFFFFFFFFFFFFP-64ULLR"
.LASF57:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF389:
	.string	"__BUILTIN_AVR_COUNTLSLK 1"
.LASF12:
	.string	"__ATOMIC_RELEASE 3"
.LASF34:
	.string	"__PTRDIFF_TYPE__ int"
.LASF388:
	.string	"__BUILTIN_AVR_COUNTLSK 1"
.LASF175:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF18:
	.string	"__SIZEOF_LONG__ 4"
.LASF435:
	.string	"__AVR_DEVICE_NAME__ atmega328p"
.LASF10:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF100:
	.string	"__INT16_C(c) c"
.LASF137:
	.string	"__FLT_EPSILON__ 1.19209290e-7F"
.LASF434:
	.string	"__AVR_ATmega328P__ 1"
.LASF97:
	.string	"__INT_LEAST8_MAX__ 0x7f"
.LASF307:
	.string	"__REGISTER_PREFIX__ "
.LASF86:
	.string	"__UINTMAX_C(c) c ## ULL"
.LASF64:
	.string	"__UINT_FAST32_TYPE__ long unsigned int"
.LASF367:
	.string	"__BUILTIN_AVR_ROUNDUHR 1"
.LASF30:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF176:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF382:
	.string	"__BUILTIN_AVR_COUNTLSLLR 1"
.LASF153:
	.string	"__DBL_HAS_DENORM__ 1"
.LASF212:
	.string	"__LFRACT_IBIT__ 0"
.LASF78:
	.string	"__WCHAR_MIN__ (-__WCHAR_MAX__ - 1)"
.LASF79:
	.string	"__WINT_MAX__ 0x7fff"
.LASF3:
	.string	"__STDC_UTF_32__ 1"
.LASF327:
	.string	"__AVR__ 1"
.LASF99:
	.string	"__INT_LEAST16_MAX__ 0x7fff"
.LASF72:
	.string	"__SCHAR_MAX__ 0x7f"
.LASF190:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF227:
	.string	"__ULLFRACT_IBIT__ 0"
.LASF456:
	.string	"pi_control_init"
.LASF58:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF9:
	.string	"__ATOMIC_RELAXED 0"
.LASF52:
	.string	"__INT_LEAST32_TYPE__ long int"
.LASF253:
	.string	"__LACCUM_MIN__ (-0X1P31LK-0X1P31LK)"
.LASF41:
	.string	"__SIG_ATOMIC_TYPE__ char"
.LASF258:
	.string	"__ULACCUM_MIN__ 0.0ULK"
.LASF380:
	.string	"__BUILTIN_AVR_COUNTLSR 1"
.LASF140:
	.string	"__FLT_HAS_INFINITY__ 1"
.LASF114:
	.string	"__INT_FAST16_MAX__ 0x7fff"
.LASF325:
	.string	"__SIZEOF_PTRDIFF_T__ 2"
.LASF304:
	.string	"__UDA_IBIT__ 32"
.LASF61:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF98:
	.string	"__INT8_C(c) c"
.LASF370:
	.string	"__BUILTIN_AVR_ROUNDULLR 1"
.LASF453:
	.string	"C:\\\\Users\\\\Joel\\\\Dropbox\\\\Projects\\\\hc3d\\\\hc3d-tm\\\\hc3d-tm\\\\Debug"
.LASF144:
	.string	"__DBL_MIN_EXP__ (-125)"
.LASF428:
	.string	"__BUILTIN_AVR_ROUNDFX 1"
.LASF268:
	.string	"__ULLACCUM_MIN__ 0.0ULLK"
.LASF396:
	.string	"__BUILTIN_AVR_BITSR 1"
.LASF364:
	.string	"__BUILTIN_AVR_ROUNDR 1"
.LASF67:
	.string	"__UINTPTR_TYPE__ unsigned int"
.LASF411:
	.string	"__BUILTIN_AVR_HRBITS 1"
.LASF294:
	.string	"__SA_IBIT__ 16"
.LASF224:
	.string	"__LLFRACT_MAX__ 0X7FFFFFFFFFFFFFFFP-63LLR"
.LASF116:
	.string	"__INT_FAST64_MAX__ 0x7fffffffffffffffLL"
.LASF121:
	.string	"__INTPTR_MAX__ 0x7fff"
.LASF129:
	.string	"__FLT_DIG__ 6"
.LASF445:
	.string	"shift"
.LASF295:
	.string	"__DA_FBIT__ 31"
.LASF420:
	.string	"__BUILTIN_AVR_KBITS 1"
.LASF306:
	.string	"__UTA_IBIT__ 16"
.LASF173:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF240:
	.string	"__USACCUM_EPSILON__ 0x1P-8UHK"
.LASF259:
	.string	"__ULACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-32ULK"
.LASF209:
	.string	"__UFRACT_MAX__ 0XFFFFP-16UR"
.LASF194:
	.string	"__SFRACT_MAX__ 0X7FP-7HR"
.LASF105:
	.string	"__UINT_LEAST8_MAX__ 0xff"
.LASF185:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF89:
	.string	"__INT8_MAX__ 0x7f"
.LASF220:
	.string	"__ULFRACT_EPSILON__ 0x1P-32ULR"
.LASF189:
	.string	"__DEC128_EPSILON__ 1E-33DL"
.LASF217:
	.string	"__ULFRACT_IBIT__ 0"
.LASF290:
	.string	"__UTQ_IBIT__ 0"
.LASF385:
	.string	"__BUILTIN_AVR_COUNTLSULR 1"
.LASF111:
	.string	"__UINT_LEAST64_MAX__ 0xffffffffffffffffULL"
.LASF127:
	.string	"__FLT_RADIX__ 2"
.LASF403:
	.string	"__BUILTIN_AVR_BITSHK 1"
.LASF228:
	.string	"__ULLFRACT_MIN__ 0.0ULLR"
.LASF155:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF248:
	.string	"__UACCUM_MIN__ 0.0UK"
.LASF215:
	.string	"__LFRACT_EPSILON__ 0x1P-31LR"
.LASF376:
	.string	"__BUILTIN_AVR_ROUNDUK 1"
.LASF63:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF117:
	.string	"__UINT_FAST8_MAX__ 0xff"
.LASF39:
	.string	"__CHAR16_TYPE__ unsigned int"
.LASF231:
	.string	"__SACCUM_FBIT__ 7"
.LASF181:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF203:
	.string	"__FRACT_MIN__ (-0.5R-0.5R)"
.LASF316:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 1"
.LASF83:
	.string	"__INTMAX_MAX__ 0x7fffffffffffffffLL"
.LASF400:
	.string	"__BUILTIN_AVR_BITSUR 1"
.LASF250:
	.string	"__UACCUM_EPSILON__ 0x1P-16UK"
.LASF439:
	.string	"F_CPU 16000000"
.LASF242:
	.string	"__ACCUM_IBIT__ 16"
.LASF353:
	.string	"__BUILTIN_AVR_INSERT_BITS 1"
.LASF278:
	.string	"__DQ_IBIT__ 0"
.LASF305:
	.string	"__UTA_FBIT__ 48"
.LASF236:
	.string	"__USACCUM_FBIT__ 8"
.LASF27:
	.string	"__ORDER_LITTLE_ENDIAN__ 1234"
.LASF399:
	.string	"__BUILTIN_AVR_BITSUHR 1"
.LASF351:
	.string	"__BUILTIN_AVR_FMULSU 1"
.LASF193:
	.string	"__SFRACT_MIN__ (-0.5HR-0.5HR)"
.LASF302:
	.string	"__USA_IBIT__ 16"
.LASF184:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF156:
	.string	"__LDBL_MANT_DIG__ 24"
.LASF21:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF239:
	.string	"__USACCUM_MAX__ 0XFFFFP-8UHK"
.LASF110:
	.string	"__UINT32_C(c) c ## UL"
.LASF172:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF440:
	.string	"_STDBOOL_H "
.LASF261:
	.string	"__LLACCUM_FBIT__ 47"
.LASF26:
	.string	"__BIGGEST_ALIGNMENT__ 1"
.LASF296:
	.string	"__DA_IBIT__ 32"
.LASF252:
	.string	"__LACCUM_IBIT__ 32"
.LASF146:
	.string	"__DBL_MAX_EXP__ 128"
.LASF199:
	.string	"__USFRACT_MAX__ 0XFFP-8UHR"
.LASF397:
	.string	"__BUILTIN_AVR_BITSLR 1"
.LASF15:
	.string	"__OPTIMIZE__ 1"
.LASF293:
	.string	"__SA_FBIT__ 15"
.LASF352:
	.string	"__BUILTIN_AVR_DELAY_CYCLES 1"
.LASF70:
	.string	"__GXX_ABI_VERSION 1009"
.LASF235:
	.string	"__SACCUM_EPSILON__ 0x1P-7HK"
.LASF263:
	.string	"__LLACCUM_MIN__ (-0X1P15LLK-0X1P15LLK)"
.LASF59:
	.string	"__INT_FAST16_TYPE__ int"
.LASF390:
	.string	"__BUILTIN_AVR_COUNTLSLLK 1"
.LASF406:
	.string	"__BUILTIN_AVR_BITSLLK 1"
.LASF311:
	.string	"__GCC_ATOMIC_CHAR_LOCK_FREE 1"
.LASF343:
	.string	"__BUILTIN_AVR_NOP 1"
.LASF284:
	.string	"__UHQ_IBIT__ 0"
.LASF206:
	.string	"__UFRACT_FBIT__ 16"
.LASF76:
	.string	"__LONG_LONG_MAX__ 0x7fffffffffffffffLL"
.LASF133:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF87:
	.string	"__SIG_ATOMIC_MAX__ 0x7f"
.LASF218:
	.string	"__ULFRACT_MIN__ 0.0ULR"
.LASF128:
	.string	"__FLT_MANT_DIG__ 24"
.LASF286:
	.string	"__USQ_IBIT__ 0"
.LASF247:
	.string	"__UACCUM_IBIT__ 16"
.LASF166:
	.string	"__LDBL_DENORM_MIN__ 1.40129846e-45L"
.LASF162:
	.string	"__DECIMAL_DIG__ 9"
.LASF378:
	.string	"__BUILTIN_AVR_ROUNDULLK 1"
.LASF237:
	.string	"__USACCUM_IBIT__ 8"
.LASF158:
	.string	"__LDBL_MIN_EXP__ (-125)"
.LASF418:
	.string	"__BUILTIN_AVR_ULLRBITS 1"
.LASF47:
	.string	"__UINT16_TYPE__ unsigned int"
.LASF201:
	.string	"__FRACT_FBIT__ 15"
.LASF426:
	.string	"__BUILTIN_AVR_ULLKBITS 1"
.LASF449:
	.string	"new_i"
.LASF125:
	.string	"__FLT_EVAL_METHOD__ 0"
.LASF94:
	.string	"__UINT16_MAX__ 0xffffU"
.LASF103:
	.string	"__INT_LEAST64_MAX__ 0x7fffffffffffffffLL"
.LASF431:
	.string	"__INT24_MIN__ (-__INT24_MAX__-1)"
.LASF241:
	.string	"__ACCUM_FBIT__ 15"
.LASF314:
	.string	"__GCC_ATOMIC_WCHAR_T_LOCK_FREE 1"
.LASF178:
	.string	"__DEC64_MIN_EXP__ (-382)"
.LASF257:
	.string	"__ULACCUM_IBIT__ 32"
.LASF221:
	.string	"__LLFRACT_FBIT__ 63"
.LASF301:
	.string	"__USA_FBIT__ 16"
.LASF93:
	.string	"__UINT8_MAX__ 0xff"
.LASF437:
	.string	"DEBUG 1"
.LASF375:
	.string	"__BUILTIN_AVR_ROUNDUHK 1"
.LASF174:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF211:
	.string	"__LFRACT_FBIT__ 31"
.LASF16:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF442:
	.string	"true 1"
.LASF393:
	.string	"__BUILTIN_AVR_COUNTLSULK 1"
.LASF251:
	.string	"__LACCUM_FBIT__ 31"
.LASF210:
	.string	"__UFRACT_EPSILON__ 0x1P-16UR"
.LASF317:
	.string	"__GCC_ATOMIC_LONG_LOCK_FREE 1"
.LASF245:
	.string	"__ACCUM_EPSILON__ 0x1P-15K"
.LASF355:
	.string	"__BUILTIN_AVR_ABSHR 1"
.LASF339:
	.string	"__AVR_SFR_OFFSET__ 0x20"
.LASF232:
	.string	"__SACCUM_IBIT__ 8"
.LASF356:
	.string	"__BUILTIN_AVR_ABSR 1"
.LASF289:
	.string	"__UTQ_FBIT__ 128"
.LASF264:
	.string	"__LLACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-47LLK"
.LASF25:
	.string	"__CHAR_BIT__ 8"
.LASF265:
	.string	"__LLACCUM_EPSILON__ 0x1P-47LLK"
.LASF50:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF310:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 1"
.LASF54:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF157:
	.string	"__LDBL_DIG__ 6"
.LASF234:
	.string	"__SACCUM_MAX__ 0X7FFFP-7HK"
.LASF372:
	.string	"__BUILTIN_AVR_ROUNDK 1"
.LASF280:
	.string	"__TQ_IBIT__ 0"
.LASF299:
	.string	"__UHA_FBIT__ 8"
.LASF451:
	.string	"GNU C99 5.4.0 -mn-flash=1 -mno-skip-bug -mrelax -mmcu=avr5 -g3 -Og -std=gnu99 -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -fno-strict-aliasing"
.LASF423:
	.string	"__BUILTIN_AVR_UHKBITS 1"
.LASF433:
	.string	"__ELF__ 1"
.LASF74:
	.string	"__INT_MAX__ 0x7fff"
.LASF407:
	.string	"__BUILTIN_AVR_BITSUHK 1"
.LASF319:
	.string	"__GCC_ATOMIC_TEST_AND_SET_TRUEVAL 1"
.LASF321:
	.string	"__GCC_HAVE_DWARF2_CFI_ASM 1"
.LASF409:
	.string	"__BUILTIN_AVR_BITSULK 1"
.LASF96:
	.string	"__UINT64_MAX__ 0xffffffffffffffffULL"
.LASF254:
	.string	"__LACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-31LK"
.LASF404:
	.string	"__BUILTIN_AVR_BITSK 1"
.LASF200:
	.string	"__USFRACT_EPSILON__ 0x1P-8UHR"
.LASF11:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF369:
	.string	"__BUILTIN_AVR_ROUNDULR 1"
.LASF92:
	.string	"__INT64_MAX__ 0x7fffffffffffffffLL"
.LASF415:
	.string	"__BUILTIN_AVR_UHRBITS 1"
.LASF298:
	.string	"__TA_IBIT__ 16"
.LASF0:
	.string	"__STDC__ 1"
.LASF115:
	.string	"__INT_FAST32_MAX__ 0x7fffffffL"
.LASF108:
	.string	"__UINT16_C(c) c ## U"
.LASF246:
	.string	"__UACCUM_FBIT__ 16"
.LASF363:
	.string	"__BUILTIN_AVR_ROUNDHR 1"
.LASF14:
	.string	"__ATOMIC_CONSUME 1"
.LASF75:
	.string	"__LONG_MAX__ 0x7fffffffL"
.LASF90:
	.string	"__INT16_MAX__ 0x7fff"
.LASF216:
	.string	"__ULFRACT_FBIT__ 32"
.LASF22:
	.string	"__SIZEOF_DOUBLE__ 4"
.LASF60:
	.string	"__INT_FAST32_TYPE__ long int"
.LASF243:
	.string	"__ACCUM_MIN__ (-0X1P15K-0X1P15K)"
.LASF118:
	.string	"__UINT_FAST16_MAX__ 0xffffU"
.LASF7:
	.string	"__GNUC_PATCHLEVEL__ 0"
.LASF405:
	.string	"__BUILTIN_AVR_BITSLK 1"
.LASF204:
	.string	"__FRACT_MAX__ 0X7FFFP-15R"
.LASF45:
	.string	"__INT64_TYPE__ long long int"
.LASF256:
	.string	"__ULACCUM_FBIT__ 32"
.LASF208:
	.string	"__UFRACT_MIN__ 0.0UR"
.LASF326:
	.string	"__AVR 1"
.LASF186:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF330:
	.string	"__AVR_HAVE_MOVW__ 1"
.LASF2:
	.string	"__STDC_UTF_16__ 1"
.LASF386:
	.string	"__BUILTIN_AVR_COUNTLSULLR 1"
.LASF202:
	.string	"__FRACT_IBIT__ 0"
.LASF168:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF124:
	.string	"__GCC_IEC_559_COMPLEX 0"
.LASF95:
	.string	"__UINT32_MAX__ 0xffffffffUL"
.LASF136:
	.string	"__FLT_MIN__ 1.17549435e-38F"
.LASF323:
	.string	"__SIZEOF_WCHAR_T__ 2"
.LASF441:
	.string	"bool _Bool"
.LASF267:
	.string	"__ULLACCUM_IBIT__ 16"
.LASF450:
	.string	"_Bool"
.LASF88:
	.string	"__SIG_ATOMIC_MIN__ (-__SIG_ATOMIC_MAX__ - 1)"
.LASF31:
	.string	"__FLOAT_WORD_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF244:
	.string	"__ACCUM_MAX__ 0X7FFFFFFFP-15K"
.LASF207:
	.string	"__UFRACT_IBIT__ 0"
.LASF170:
	.string	"__DEC32_MANT_DIG__ 7"
.LASF401:
	.string	"__BUILTIN_AVR_BITSULR 1"
.LASF159:
	.string	"__LDBL_MIN_10_EXP__ (-37)"
.LASF163:
	.string	"__LDBL_MAX__ 3.40282347e+38L"
.LASF225:
	.string	"__LLFRACT_EPSILON__ 0x1P-63LLR"
.LASF362:
	.string	"__BUILTIN_AVR_ABSLLK 1"
.LASF191:
	.string	"__SFRACT_FBIT__ 7"
.LASF40:
	.string	"__CHAR32_TYPE__ long unsigned int"
.LASF192:
	.string	"__SFRACT_IBIT__ 0"
.LASF383:
	.string	"__BUILTIN_AVR_COUNTLSUHR 1"
.LASF274:
	.string	"__HQ_IBIT__ 0"
.LASF308:
	.string	"__USER_LABEL_PREFIX__ "
.LASF56:
	.string	"__UINT_LEAST32_TYPE__ long unsigned int"
.LASF277:
	.string	"__DQ_FBIT__ 63"
.LASF300:
	.string	"__UHA_IBIT__ 8"
.LASF332:
	.string	"__AVR_ENHANCED__ 1"
.LASF73:
	.string	"__SHRT_MAX__ 0x7fff"
.LASF29:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF276:
	.string	"__SQ_IBIT__ 0"
.LASF119:
	.string	"__UINT_FAST32_MAX__ 0xffffffffUL"
.LASF134:
	.string	"__FLT_DECIMAL_DIG__ 9"
.LASF51:
	.string	"__INT_LEAST16_TYPE__ int"
.LASF91:
	.string	"__INT32_MAX__ 0x7fffffffL"
.LASF361:
	.string	"__BUILTIN_AVR_ABSLK 1"
.LASF281:
	.string	"__UQQ_FBIT__ 8"
.LASF113:
	.string	"__INT_FAST8_MAX__ 0x7f"
.LASF336:
	.string	"__AVR_2_BYTE_PC__ 1"
.LASF249:
	.string	"__UACCUM_MAX__ 0XFFFFFFFFP-16UK"
.LASF179:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF346:
	.string	"__BUILTIN_AVR_WDR 1"
.LASF44:
	.string	"__INT32_TYPE__ long int"
.LASF414:
	.string	"__BUILTIN_AVR_LLRBITS 1"
.LASF329:
	.string	"__AVR_ARCH__ 5"
.LASF275:
	.string	"__SQ_FBIT__ 31"
.LASF80:
	.string	"__WINT_MIN__ (-__WINT_MAX__ - 1)"
.LASF213:
	.string	"__LFRACT_MIN__ (-0.5LR-0.5LR)"
.LASF187:
	.string	"__DEC128_MIN__ 1E-6143DL"
.LASF345:
	.string	"__BUILTIN_AVR_CLI 1"
.LASF109:
	.string	"__UINT_LEAST32_MAX__ 0xffffffffUL"
.LASF438:
	.string	"BOARD USER_BOARD"
.LASF82:
	.string	"__SIZE_MAX__ 0xffffU"
.LASF62:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF169:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF42:
	.string	"__INT8_TYPE__ signed char"
.LASF35:
	.string	"__WCHAR_TYPE__ int"
.LASF427:
	.string	"__BUILTIN_AVR_ABSFX 1"
.LASF360:
	.string	"__BUILTIN_AVR_ABSK 1"
.LASF279:
	.string	"__TQ_FBIT__ 127"
.LASF55:
	.string	"__UINT_LEAST16_TYPE__ unsigned int"
.LASF283:
	.string	"__UHQ_FBIT__ 16"
.LASF338:
	.string	"__AVR_HAVE_SPH__ 1"
.LASF340:
	.string	"__WITH_AVRLIBC__ 1"
.LASF120:
	.string	"__UINT_FAST64_MAX__ 0xffffffffffffffffULL"
.LASF196:
	.string	"__USFRACT_FBIT__ 8"
.LASF104:
	.string	"__INT64_C(c) c ## LL"
.LASF273:
	.string	"__HQ_FBIT__ 15"
.LASF452:
	.string	"../src/libraries/pi_control/pi_control.c"
.LASF335:
	.string	"__AVR_MEGA__ 1"
.LASF107:
	.string	"__UINT_LEAST16_MAX__ 0xffffU"
.LASF19:
	.string	"__SIZEOF_LONG_LONG__ 8"
.LASF145:
	.string	"__DBL_MIN_10_EXP__ (-37)"
.LASF46:
	.string	"__UINT8_TYPE__ unsigned char"
.LASF354:
	.string	"__BUILTIN_AVR_FLASH_SEGMENT 1"
.LASF149:
	.string	"__DBL_MAX__ ((double)3.40282347e+38L)"
.LASF160:
	.string	"__LDBL_MAX_EXP__ 128"
.LASF53:
	.string	"__INT_LEAST64_TYPE__ long long int"
.LASF419:
	.string	"__BUILTIN_AVR_HKBITS 1"
.LASF48:
	.string	"__UINT32_TYPE__ long unsigned int"
.LASF122:
	.string	"__UINTPTR_MAX__ 0xffffU"
.LASF32:
	.string	"__SIZEOF_POINTER__ 2"
.LASF421:
	.string	"__BUILTIN_AVR_LKBITS 1"
.LASF377:
	.string	"__BUILTIN_AVR_ROUNDULK 1"
.LASF313:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 1"
.LASF219:
	.string	"__ULFRACT_MAX__ 0XFFFFFFFFP-32ULR"
.LASF291:
	.string	"__HA_FBIT__ 7"
.LASF357:
	.string	"__BUILTIN_AVR_ABSLR 1"
.LASF359:
	.string	"__BUILTIN_AVR_ABSHK 1"
.LASF371:
	.string	"__BUILTIN_AVR_ROUNDHK 1"
.LASF233:
	.string	"__SACCUM_MIN__ (-0X1P7HK-0X1P7HK)"
.LASF320:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 1"
.LASF412:
	.string	"__BUILTIN_AVR_RBITS 1"
.LASF112:
	.string	"__UINT64_C(c) c ## ULL"
.LASF255:
	.string	"__LACCUM_EPSILON__ 0x1P-31LK"
.LASF43:
	.string	"__INT16_TYPE__ int"
.LASF195:
	.string	"__SFRACT_EPSILON__ 0x1P-7HR"
.LASF341:
	.string	"__FLASH 1"
.LASF282:
	.string	"__UQQ_IBIT__ 0"
.LASF285:
	.string	"__USQ_FBIT__ 32"
.LASF292:
	.string	"__HA_IBIT__ 8"
.LASF77:
	.string	"__WCHAR_MAX__ 0x7fff"
.LASF448:
	.string	"int_ok"
.LASF1:
	.string	"__STDC_VERSION__ 199901L"
.LASF269:
	.string	"__ULLACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-48ULLK"
.LASF138:
	.string	"__FLT_DENORM_MIN__ 1.40129846e-45F"
.LASF387:
	.string	"__BUILTIN_AVR_COUNTLSHK 1"
.LASF85:
	.string	"__UINTMAX_MAX__ 0xffffffffffffffffULL"
.LASF429:
	.string	"__BUILTIN_AVR_COUNTLSFX 1"
.LASF205:
	.string	"__FRACT_EPSILON__ 0x1P-15R"
.LASF4:
	.string	"__STDC_HOSTED__ 1"
.LASF394:
	.string	"__BUILTIN_AVR_COUNTLSULLK 1"
.LASF366:
	.string	"__BUILTIN_AVR_ROUNDLLR 1"
.LASF8:
	.string	"__VERSION__ \"5.4.0\""
.LASF68:
	.string	"__has_include(STR) __has_include__(STR)"
.LASF430:
	.string	"__INT24_MAX__ 8388607L"
.LASF165:
	.string	"__LDBL_EPSILON__ 1.19209290e-7L"
.LASF398:
	.string	"__BUILTIN_AVR_BITSLLR 1"
.LASF425:
	.string	"__BUILTIN_AVR_ULKBITS 1"
.LASF334:
	.string	"__AVR_HAVE_JMP_CALL__ 1"
.LASF318:
	.string	"__GCC_ATOMIC_LLONG_LOCK_FREE 1"
.LASF164:
	.string	"__LDBL_MIN__ 1.17549435e-38L"
.LASF132:
	.string	"__FLT_MAX_EXP__ 128"
.LASF13:
	.string	"__ATOMIC_ACQ_REL 4"
.LASF65:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF446:
	.string	"unsigned char"
.LASF171:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF38:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF392:
	.string	"__BUILTIN_AVR_COUNTLSUK 1"
.LASF408:
	.string	"__BUILTIN_AVR_BITSUK 1"
.LASF66:
	.string	"__INTPTR_TYPE__ int"
.LASF126:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF238:
	.string	"__USACCUM_MIN__ 0.0UHK"
.LASF197:
	.string	"__USFRACT_IBIT__ 0"
.LASF151:
	.string	"__DBL_EPSILON__ ((double)1.19209290e-7L)"
.LASF348:
	.string	"__BUILTIN_AVR_SWAP 1"
.LASF150:
	.string	"__DBL_MIN__ ((double)1.17549435e-38L)"
.LASF365:
	.string	"__BUILTIN_AVR_ROUNDLR 1"
.LASF147:
	.string	"__DBL_MAX_10_EXP__ 38"
.LASF33:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF416:
	.string	"__BUILTIN_AVR_URBITS 1"
.LASF315:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 1"
.LASF444:
	.string	"__bool_true_false_are_defined 1"
.LASF297:
	.string	"__TA_FBIT__ 47"
.LASF402:
	.string	"__BUILTIN_AVR_BITSULLR 1"
.LASF381:
	.string	"__BUILTIN_AVR_COUNTLSLR 1"
.LASF454:
	.string	"PIControl"
.LASF154:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF410:
	.string	"__BUILTIN_AVR_BITSULLK 1"
.LASF17:
	.string	"__SIZEOF_INT__ 2"
.LASF141:
	.string	"__FLT_HAS_QUIET_NAN__ 1"
.LASF436:
	.string	"__AVR_DEV_LIB_NAME__ m328p"
.LASF148:
	.string	"__DBL_DECIMAL_DIG__ 9"
.LASF37:
	.string	"__INTMAX_TYPE__ long long int"
.LASF84:
	.string	"__INTMAX_C(c) c ## LL"
.LASF142:
	.string	"__DBL_MANT_DIG__ 24"
.LASF71:
	.string	"__USING_SJLJ_EXCEPTIONS__ 1"
.LASF49:
	.string	"__UINT64_TYPE__ long long unsigned int"
.LASF350:
	.string	"__BUILTIN_AVR_FMULS 1"
.LASF391:
	.string	"__BUILTIN_AVR_COUNTLSUHK 1"
.LASF309:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF271:
	.string	"__QQ_FBIT__ 7"
.LASF123:
	.string	"__GCC_IEC_559 0"
.LASF417:
	.string	"__BUILTIN_AVR_ULRBITS 1"
.LASF358:
	.string	"__BUILTIN_AVR_ABSLLR 1"
.LASF270:
	.string	"__ULLACCUM_EPSILON__ 0x1P-48ULLK"
.LASF143:
	.string	"__DBL_DIG__ 6"
.LASF130:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF379:
	.string	"__BUILTIN_AVR_COUNTLSHR 1"
.LASF188:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF266:
	.string	"__ULLACCUM_FBIT__ 48"
.LASF413:
	.string	"__BUILTIN_AVR_LRBITS 1"
.LASF102:
	.string	"__INT32_C(c) c ## L"
.LASF443:
	.string	"false 0"
.LASF331:
	.string	"__AVR_HAVE_LPMX__ 1"
.LASF347:
	.string	"__BUILTIN_AVR_SLEEP 1"
.LASF214:
	.string	"__LFRACT_MAX__ 0X7FFFFFFFP-31LR"
.LASF303:
	.string	"__UDA_FBIT__ 32"
.LASF432:
	.string	"__UINT24_MAX__ 16777215UL"
.LASF422:
	.string	"__BUILTIN_AVR_LLKBITS 1"
.LASF342:
	.string	"__MEMX 1"
.LASF349:
	.string	"__BUILTIN_AVR_FMUL 1"
.LASF81:
	.string	"__PTRDIFF_MAX__ 0x7fff"
.LASF101:
	.string	"__INT_LEAST32_MAX__ 0x7fffffffL"
.LASF180:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF322:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF223:
	.string	"__LLFRACT_MIN__ (-0.5LLR-0.5LLR)"
.LASF328:
	.string	"AVR 1"
.LASF230:
	.string	"__ULLFRACT_EPSILON__ 0x1P-64ULLR"
.LASF167:
	.string	"__LDBL_HAS_DENORM__ 1"
.LASF287:
	.string	"__UDQ_FBIT__ 64"
.LASF177:
	.string	"__DEC64_MANT_DIG__ 16"
.LASF139:
	.string	"__FLT_HAS_DENORM__ 1"
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.6.2_1778) 5.4.0"
