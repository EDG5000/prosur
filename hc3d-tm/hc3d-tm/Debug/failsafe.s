	.file	"failsafe.c"
__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.Ltext0:
	.cfi_sections	.debug_frame
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Failsafe activated."
	.section	.text.failsafe_trigger,"ax",@progbits
.global	failsafe_trigger
	.type	failsafe_trigger, @function
failsafe_trigger:
.LFB1:
	.file 1 "../src/business_logic/failsafe.c"
	.loc 1 12 0
	.cfi_startproc
/* prologue: function */
/* frame size = 0 */
/* stack size = 0 */
.L__stack_usage = 0
	.loc 1 13 0
	ldi r24,0
	call driver_relay_set
.LVL0:
	.loc 1 14 0
	ldi r24,lo8(.LC0)
	ldi r25,hi8(.LC0)
	push r25
.LCFI0:
	.cfi_def_cfa_offset 3
	push r24
.LCFI1:
	.cfi_def_cfa_offset 4
	call printf
.LVL1:
	.loc 1 15 0
	pop __tmp_reg__
	pop __tmp_reg__
.LCFI2:
	.cfi_def_cfa_offset 2
	ret
	.cfi_endproc
.LFE1:
	.size	failsafe_trigger, .-failsafe_trigger
	.text
.Letext0:
	.file 2 "../src/drivers/driver_relay.h"
	.file 3 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\avr\\include\\stdio.h"
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0xbb
	.word	0x2
	.long	.Ldebug_abbrev0
	.byte	0x4
	.uleb128 0x1
	.long	.LASF704
	.byte	0xc
	.long	.LASF705
	.long	.LASF706
	.long	.Ldebug_ranges0+0
	.long	0
	.long	0
	.long	.Ldebug_line0
	.long	.Ldebug_macro0
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF694
	.uleb128 0x2
	.byte	0x1
	.byte	0x8
	.long	.LASF695
	.uleb128 0x3
	.byte	0x2
	.byte	0x5
	.string	"int"
	.uleb128 0x2
	.byte	0x2
	.byte	0x7
	.long	.LASF696
	.uleb128 0x2
	.byte	0x4
	.byte	0x5
	.long	.LASF697
	.uleb128 0x2
	.byte	0x4
	.byte	0x7
	.long	.LASF698
	.uleb128 0x2
	.byte	0x8
	.byte	0x5
	.long	.LASF699
	.uleb128 0x2
	.byte	0x8
	.byte	0x7
	.long	.LASF700
	.uleb128 0x2
	.byte	0x1
	.byte	0x6
	.long	.LASF701
	.uleb128 0x4
	.byte	0x1
	.long	.LASF707
	.byte	0x1
	.byte	0xc
	.byte	0x1
	.long	.LFB1
	.long	.LFE1
	.long	.LLST0
	.byte	0x1
	.long	0xa3
	.uleb128 0x5
	.long	.LVL0
	.long	0xa3
	.long	0x99
	.uleb128 0x6
	.byte	0x1
	.byte	0x68
	.byte	0x1
	.byte	0x30
	.byte	0
	.uleb128 0x7
	.long	.LVL1
	.long	0xb0
	.byte	0
	.uleb128 0x8
	.byte	0x1
	.byte	0x1
	.long	.LASF702
	.long	.LASF702
	.byte	0x2
	.byte	0x14
	.uleb128 0x9
	.byte	0x1
	.byte	0x1
	.long	.LASF703
	.long	.LASF703
	.byte	0x3
	.word	0x28b
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
	.uleb128 0xe
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
	.uleb128 0x8
	.byte	0
	.byte	0
	.uleb128 0x4
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
	.uleb128 0x5
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
	.uleb128 0x6
	.uleb128 0x410a
	.byte	0
	.uleb128 0x2
	.uleb128 0xa
	.uleb128 0x2111
	.uleb128 0xa
	.byte	0
	.byte	0
	.uleb128 0x7
	.uleb128 0x4109
	.byte	0
	.uleb128 0x11
	.uleb128 0x1
	.uleb128 0x31
	.uleb128 0x13
	.byte	0
	.byte	0
	.uleb128 0x8
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
	.uleb128 0x9
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
	.uleb128 0x5
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST0:
	.long	.LFB1
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
	.long	.LFE1
	.word	0x3
	.byte	0x92
	.uleb128 0x20
	.sleb128 2
	.long	0
	.long	0
	.section	.debug_aranges,"",@progbits
	.long	0x1c
	.word	0x2
	.long	.Ldebug_info0
	.byte	0x4
	.byte	0
	.word	0
	.word	0
	.long	.LFB1
	.long	.LFE1-.LFB1
	.long	0
	.long	0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
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
	.file 4 "../src/business_logic/failsafe.h"
	.byte	0x3
	.uleb128 0x8
	.uleb128 0x4
	.byte	0x4
	.byte	0x3
	.uleb128 0x9
	.uleb128 0x3
	.byte	0x5
	.uleb128 0x28
	.long	.LASF440
	.file 5 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\avr\\include\\inttypes.h"
	.byte	0x3
	.uleb128 0x2c
	.uleb128 0x5
	.byte	0x5
	.uleb128 0x23
	.long	.LASF441
	.file 6 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\lib\\gcc\\avr\\5.4.0\\include\\stdint.h"
	.byte	0x3
	.uleb128 0x25
	.uleb128 0x6
	.file 7 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\avr\\include\\stdint.h"
	.byte	0x3
	.uleb128 0x9
	.uleb128 0x7
	.byte	0x7
	.long	.Ldebug_macro1
	.byte	0x4
	.byte	0x5
	.uleb128 0xd
	.long	.LASF507
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro2
	.byte	0x4
	.file 8 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\lib\\gcc\\avr\\5.4.0\\include\\stdarg.h"
	.byte	0x3
	.uleb128 0x2d
	.uleb128 0x8
	.byte	0x7
	.long	.Ldebug_macro3
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro4
	.file 9 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\lib\\gcc\\avr\\5.4.0\\include\\stddef.h"
	.byte	0x3
	.uleb128 0x32
	.uleb128 0x9
	.byte	0x7
	.long	.Ldebug_macro5
	.byte	0x4
	.byte	0x7
	.long	.Ldebug_macro6
	.byte	0x4
	.byte	0x3
	.uleb128 0xa
	.uleb128 0x2
	.file 10 "c:\\program files (x86)\\atmel\\studio\\7.0\\toolchain\\avr8\\avr8-gnu-toolchain\\lib\\gcc\\avr\\5.4.0\\include\\stdbool.h"
	.byte	0x3
	.uleb128 0xe
	.uleb128 0xa
	.byte	0x7
	.long	.Ldebug_macro7
	.byte	0x4
	.byte	0x4
	.byte	0x4
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stdint.h.41.052d062c327f27e210bb72c3d087afe5,comdat
.Ldebug_macro1:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x29
	.long	.LASF442
	.byte	0x5
	.uleb128 0x3b
	.long	.LASF443
	.byte	0x5
	.uleb128 0x122
	.long	.LASF444
	.byte	0x5
	.uleb128 0x123
	.long	.LASF445
	.byte	0x5
	.uleb128 0x133
	.long	.LASF446
	.byte	0x5
	.uleb128 0x138
	.long	.LASF447
	.byte	0x5
	.uleb128 0x14b
	.long	.LASF448
	.byte	0x5
	.uleb128 0x150
	.long	.LASF449
	.byte	0x5
	.uleb128 0x155
	.long	.LASF450
	.byte	0x5
	.uleb128 0x15a
	.long	.LASF451
	.byte	0x5
	.uleb128 0x15f
	.long	.LASF452
	.byte	0x5
	.uleb128 0x164
	.long	.LASF453
	.byte	0x5
	.uleb128 0x169
	.long	.LASF454
	.byte	0x5
	.uleb128 0x170
	.long	.LASF455
	.byte	0x5
	.uleb128 0x175
	.long	.LASF456
	.byte	0x5
	.uleb128 0x17a
	.long	.LASF457
	.byte	0x5
	.uleb128 0x184
	.long	.LASF458
	.byte	0x5
	.uleb128 0x189
	.long	.LASF459
	.byte	0x5
	.uleb128 0x18e
	.long	.LASF460
	.byte	0x5
	.uleb128 0x193
	.long	.LASF461
	.byte	0x5
	.uleb128 0x198
	.long	.LASF462
	.byte	0x5
	.uleb128 0x19d
	.long	.LASF463
	.byte	0x5
	.uleb128 0x1a2
	.long	.LASF464
	.byte	0x5
	.uleb128 0x1a7
	.long	.LASF465
	.byte	0x5
	.uleb128 0x1ac
	.long	.LASF466
	.byte	0x5
	.uleb128 0x1b1
	.long	.LASF467
	.byte	0x5
	.uleb128 0x1b6
	.long	.LASF468
	.byte	0x5
	.uleb128 0x1bb
	.long	.LASF469
	.byte	0x5
	.uleb128 0x1c6
	.long	.LASF470
	.byte	0x5
	.uleb128 0x1cb
	.long	.LASF471
	.byte	0x5
	.uleb128 0x1d0
	.long	.LASF472
	.byte	0x5
	.uleb128 0x1d5
	.long	.LASF473
	.byte	0x5
	.uleb128 0x1da
	.long	.LASF474
	.byte	0x5
	.uleb128 0x1df
	.long	.LASF475
	.byte	0x5
	.uleb128 0x1e4
	.long	.LASF476
	.byte	0x5
	.uleb128 0x1e9
	.long	.LASF477
	.byte	0x5
	.uleb128 0x1ee
	.long	.LASF478
	.byte	0x5
	.uleb128 0x1f3
	.long	.LASF479
	.byte	0x5
	.uleb128 0x1f8
	.long	.LASF480
	.byte	0x5
	.uleb128 0x1fd
	.long	.LASF481
	.byte	0x5
	.uleb128 0x208
	.long	.LASF482
	.byte	0x5
	.uleb128 0x20d
	.long	.LASF483
	.byte	0x5
	.uleb128 0x212
	.long	.LASF484
	.byte	0x5
	.uleb128 0x21d
	.long	.LASF485
	.byte	0x5
	.uleb128 0x222
	.long	.LASF486
	.byte	0x5
	.uleb128 0x227
	.long	.LASF487
	.byte	0x5
	.uleb128 0x234
	.long	.LASF488
	.byte	0x5
	.uleb128 0x239
	.long	.LASF489
	.byte	0x5
	.uleb128 0x242
	.long	.LASF490
	.byte	0x5
	.uleb128 0x247
	.long	.LASF491
	.byte	0x5
	.uleb128 0x24d
	.long	.LASF492
	.byte	0x5
	.uleb128 0x259
	.long	.LASF493
	.byte	0x5
	.uleb128 0x25a
	.long	.LASF494
	.byte	0x5
	.uleb128 0x25d
	.long	.LASF495
	.byte	0x5
	.uleb128 0x25e
	.long	.LASF496
	.byte	0x5
	.uleb128 0x271
	.long	.LASF497
	.byte	0x5
	.uleb128 0x272
	.long	.LASF498
	.byte	0x5
	.uleb128 0x273
	.long	.LASF499
	.byte	0x5
	.uleb128 0x274
	.long	.LASF500
	.byte	0x5
	.uleb128 0x275
	.long	.LASF501
	.byte	0x5
	.uleb128 0x276
	.long	.LASF502
	.byte	0x5
	.uleb128 0x277
	.long	.LASF503
	.byte	0x5
	.uleb128 0x278
	.long	.LASF504
	.byte	0x5
	.uleb128 0x279
	.long	.LASF505
	.byte	0x5
	.uleb128 0x27a
	.long	.LASF506
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.inttypes.h.96.afb9c4be73a069861f8689c997efc518,comdat
.Ldebug_macro2:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x60
	.long	.LASF508
	.byte	0x5
	.uleb128 0x63
	.long	.LASF509
	.byte	0x5
	.uleb128 0x66
	.long	.LASF510
	.byte	0x5
	.uleb128 0x6a
	.long	.LASF511
	.byte	0x5
	.uleb128 0x6d
	.long	.LASF512
	.byte	0x5
	.uleb128 0x70
	.long	.LASF513
	.byte	0x5
	.uleb128 0x75
	.long	.LASF514
	.byte	0x5
	.uleb128 0x78
	.long	.LASF515
	.byte	0x5
	.uleb128 0x7b
	.long	.LASF516
	.byte	0x5
	.uleb128 0x7f
	.long	.LASF517
	.byte	0x5
	.uleb128 0x82
	.long	.LASF518
	.byte	0x5
	.uleb128 0x85
	.long	.LASF519
	.byte	0x5
	.uleb128 0x8a
	.long	.LASF520
	.byte	0x5
	.uleb128 0x8d
	.long	.LASF521
	.byte	0x5
	.uleb128 0x90
	.long	.LASF522
	.byte	0x5
	.uleb128 0x94
	.long	.LASF523
	.byte	0x5
	.uleb128 0x97
	.long	.LASF524
	.byte	0x5
	.uleb128 0x9a
	.long	.LASF525
	.byte	0x5
	.uleb128 0xaf
	.long	.LASF526
	.byte	0x5
	.uleb128 0xb2
	.long	.LASF527
	.byte	0x5
	.uleb128 0xb6
	.long	.LASF528
	.byte	0x5
	.uleb128 0xb9
	.long	.LASF529
	.byte	0x5
	.uleb128 0xbc
	.long	.LASF530
	.byte	0x5
	.uleb128 0xc0
	.long	.LASF531
	.byte	0x5
	.uleb128 0xc3
	.long	.LASF532
	.byte	0x5
	.uleb128 0xc6
	.long	.LASF533
	.byte	0x5
	.uleb128 0xca
	.long	.LASF534
	.byte	0x5
	.uleb128 0xcd
	.long	.LASF535
	.byte	0x5
	.uleb128 0xd0
	.long	.LASF536
	.byte	0x5
	.uleb128 0xd4
	.long	.LASF537
	.byte	0x5
	.uleb128 0xd7
	.long	.LASF538
	.byte	0x5
	.uleb128 0xda
	.long	.LASF539
	.byte	0x5
	.uleb128 0xdf
	.long	.LASF540
	.byte	0x5
	.uleb128 0xe2
	.long	.LASF541
	.byte	0x5
	.uleb128 0xe5
	.long	.LASF542
	.byte	0x5
	.uleb128 0xe9
	.long	.LASF543
	.byte	0x5
	.uleb128 0xec
	.long	.LASF544
	.byte	0x5
	.uleb128 0xef
	.long	.LASF545
	.byte	0x5
	.uleb128 0xf3
	.long	.LASF546
	.byte	0x5
	.uleb128 0xf6
	.long	.LASF547
	.byte	0x5
	.uleb128 0xf9
	.long	.LASF548
	.byte	0x5
	.uleb128 0xfd
	.long	.LASF549
	.byte	0x5
	.uleb128 0x100
	.long	.LASF550
	.byte	0x5
	.uleb128 0x103
	.long	.LASF551
	.byte	0x5
	.uleb128 0x108
	.long	.LASF552
	.byte	0x5
	.uleb128 0x10b
	.long	.LASF553
	.byte	0x5
	.uleb128 0x10e
	.long	.LASF554
	.byte	0x5
	.uleb128 0x112
	.long	.LASF555
	.byte	0x5
	.uleb128 0x115
	.long	.LASF556
	.byte	0x5
	.uleb128 0x118
	.long	.LASF557
	.byte	0x5
	.uleb128 0x11c
	.long	.LASF558
	.byte	0x5
	.uleb128 0x11f
	.long	.LASF559
	.byte	0x5
	.uleb128 0x122
	.long	.LASF560
	.byte	0x5
	.uleb128 0x126
	.long	.LASF561
	.byte	0x5
	.uleb128 0x129
	.long	.LASF562
	.byte	0x5
	.uleb128 0x12c
	.long	.LASF563
	.byte	0x5
	.uleb128 0x14a
	.long	.LASF564
	.byte	0x5
	.uleb128 0x14d
	.long	.LASF565
	.byte	0x5
	.uleb128 0x150
	.long	.LASF566
	.byte	0x5
	.uleb128 0x153
	.long	.LASF567
	.byte	0x5
	.uleb128 0x158
	.long	.LASF568
	.byte	0x5
	.uleb128 0x15b
	.long	.LASF569
	.byte	0x5
	.uleb128 0x15e
	.long	.LASF570
	.byte	0x5
	.uleb128 0x162
	.long	.LASF571
	.byte	0x5
	.uleb128 0x165
	.long	.LASF572
	.byte	0x5
	.uleb128 0x168
	.long	.LASF573
	.byte	0x5
	.uleb128 0x16d
	.long	.LASF574
	.byte	0x5
	.uleb128 0x170
	.long	.LASF575
	.byte	0x5
	.uleb128 0x173
	.long	.LASF576
	.byte	0x5
	.uleb128 0x177
	.long	.LASF577
	.byte	0x5
	.uleb128 0x17a
	.long	.LASF578
	.byte	0x5
	.uleb128 0x17d
	.long	.LASF579
	.byte	0x5
	.uleb128 0x182
	.long	.LASF580
	.byte	0x5
	.uleb128 0x185
	.long	.LASF581
	.byte	0x5
	.uleb128 0x188
	.long	.LASF582
	.byte	0x5
	.uleb128 0x18c
	.long	.LASF583
	.byte	0x5
	.uleb128 0x18f
	.long	.LASF584
	.byte	0x5
	.uleb128 0x192
	.long	.LASF585
	.byte	0x5
	.uleb128 0x1a6
	.long	.LASF586
	.byte	0x5
	.uleb128 0x1a9
	.long	.LASF587
	.byte	0x5
	.uleb128 0x1ad
	.long	.LASF588
	.byte	0x5
	.uleb128 0x1b0
	.long	.LASF589
	.byte	0x5
	.uleb128 0x1b3
	.long	.LASF590
	.byte	0x5
	.uleb128 0x1b7
	.long	.LASF591
	.byte	0x5
	.uleb128 0x1ba
	.long	.LASF592
	.byte	0x5
	.uleb128 0x1bd
	.long	.LASF593
	.byte	0x5
	.uleb128 0x1c1
	.long	.LASF594
	.byte	0x5
	.uleb128 0x1c4
	.long	.LASF595
	.byte	0x5
	.uleb128 0x1c7
	.long	.LASF596
	.byte	0x5
	.uleb128 0x1cb
	.long	.LASF597
	.byte	0x5
	.uleb128 0x1ce
	.long	.LASF598
	.byte	0x5
	.uleb128 0x1d1
	.long	.LASF599
	.byte	0x5
	.uleb128 0x1d5
	.long	.LASF600
	.byte	0x5
	.uleb128 0x1d8
	.long	.LASF601
	.byte	0x5
	.uleb128 0x1db
	.long	.LASF602
	.byte	0x5
	.uleb128 0x1df
	.long	.LASF603
	.byte	0x5
	.uleb128 0x1e2
	.long	.LASF604
	.byte	0x5
	.uleb128 0x1e5
	.long	.LASF605
	.byte	0x5
	.uleb128 0x1ea
	.long	.LASF606
	.byte	0x5
	.uleb128 0x1ed
	.long	.LASF607
	.byte	0x5
	.uleb128 0x1f0
	.long	.LASF608
	.byte	0x5
	.uleb128 0x1f4
	.long	.LASF609
	.byte	0x5
	.uleb128 0x1f7
	.long	.LASF610
	.byte	0x5
	.uleb128 0x1fa
	.long	.LASF611
	.byte	0x5
	.uleb128 0x1fe
	.long	.LASF612
	.byte	0x5
	.uleb128 0x201
	.long	.LASF613
	.byte	0x5
	.uleb128 0x204
	.long	.LASF614
	.byte	0x5
	.uleb128 0x21d
	.long	.LASF615
	.byte	0x5
	.uleb128 0x220
	.long	.LASF616
	.byte	0x5
	.uleb128 0x223
	.long	.LASF617
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stdarg.h.31.72c3aa8d68b291953fa52b9471bcdff7,comdat
.Ldebug_macro3:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x1f
	.long	.LASF618
	.byte	0x5
	.uleb128 0x20
	.long	.LASF619
	.byte	0x6
	.uleb128 0x22
	.long	.LASF620
	.byte	0x5
	.uleb128 0x27
	.long	.LASF621
	.byte	0x5
	.uleb128 0x2f
	.long	.LASF622
	.byte	0x5
	.uleb128 0x30
	.long	.LASF623
	.byte	0x5
	.uleb128 0x31
	.long	.LASF624
	.byte	0x5
	.uleb128 0x33
	.long	.LASF625
	.byte	0x5
	.uleb128 0x35
	.long	.LASF626
	.byte	0x5
	.uleb128 0x68
	.long	.LASF627
	.byte	0x5
	.uleb128 0x6b
	.long	.LASF628
	.byte	0x5
	.uleb128 0x6e
	.long	.LASF629
	.byte	0x5
	.uleb128 0x71
	.long	.LASF630
	.byte	0x5
	.uleb128 0x74
	.long	.LASF631
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stdio.h.48.03f793588f1f7fb1580b876d18fe65ca,comdat
.Ldebug_macro4:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x30
	.long	.LASF632
	.byte	0x5
	.uleb128 0x31
	.long	.LASF633
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stddef.h.187.2ff233552538c6ff9b8575ca8ea52cb3,comdat
.Ldebug_macro5:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xbb
	.long	.LASF634
	.byte	0x5
	.uleb128 0xbc
	.long	.LASF635
	.byte	0x5
	.uleb128 0xbd
	.long	.LASF636
	.byte	0x5
	.uleb128 0xbe
	.long	.LASF637
	.byte	0x5
	.uleb128 0xbf
	.long	.LASF638
	.byte	0x5
	.uleb128 0xc0
	.long	.LASF639
	.byte	0x5
	.uleb128 0xc1
	.long	.LASF640
	.byte	0x5
	.uleb128 0xc2
	.long	.LASF641
	.byte	0x5
	.uleb128 0xc3
	.long	.LASF642
	.byte	0x5
	.uleb128 0xc4
	.long	.LASF643
	.byte	0x5
	.uleb128 0xc5
	.long	.LASF644
	.byte	0x5
	.uleb128 0xc6
	.long	.LASF645
	.byte	0x5
	.uleb128 0xc7
	.long	.LASF646
	.byte	0x5
	.uleb128 0xc8
	.long	.LASF647
	.byte	0x5
	.uleb128 0xc9
	.long	.LASF648
	.byte	0x5
	.uleb128 0xca
	.long	.LASF649
	.byte	0x5
	.uleb128 0xd2
	.long	.LASF650
	.byte	0x6
	.uleb128 0xee
	.long	.LASF651
	.byte	0x6
	.uleb128 0x191
	.long	.LASF652
	.byte	0x5
	.uleb128 0x196
	.long	.LASF653
	.byte	0x6
	.uleb128 0x19c
	.long	.LASF654
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stdio.h.248.5fbade1a796be71fda180118fce7900d,comdat
.Ldebug_macro6:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0xf8
	.long	.LASF655
	.byte	0x5
	.uleb128 0xf9
	.long	.LASF656
	.byte	0x5
	.uleb128 0xfa
	.long	.LASF657
	.byte	0x5
	.uleb128 0xfb
	.long	.LASF658
	.byte	0x5
	.uleb128 0xfc
	.long	.LASF659
	.byte	0x5
	.uleb128 0xfd
	.long	.LASF660
	.byte	0x5
	.uleb128 0xfe
	.long	.LASF661
	.byte	0x5
	.uleb128 0xff
	.long	.LASF662
	.byte	0x5
	.uleb128 0x11e
	.long	.LASF663
	.byte	0x5
	.uleb128 0x127
	.long	.LASF664
	.byte	0x5
	.uleb128 0x132
	.long	.LASF665
	.byte	0x5
	.uleb128 0x13a
	.long	.LASF666
	.byte	0x5
	.uleb128 0x141
	.long	.LASF667
	.byte	0x5
	.uleb128 0x145
	.long	.LASF668
	.byte	0x5
	.uleb128 0x15e
	.long	.LASF669
	.byte	0x5
	.uleb128 0x167
	.long	.LASF670
	.byte	0x5
	.uleb128 0x168
	.long	.LASF671
	.byte	0x5
	.uleb128 0x169
	.long	.LASF672
	.byte	0x5
	.uleb128 0x170
	.long	.LASF673
	.byte	0x5
	.uleb128 0x177
	.long	.LASF674
	.byte	0x5
	.uleb128 0x185
	.long	.LASF675
	.byte	0x5
	.uleb128 0x1c2
	.long	.LASF676
	.byte	0x5
	.uleb128 0x280
	.long	.LASF677
	.byte	0x5
	.uleb128 0x285
	.long	.LASF678
	.byte	0x5
	.uleb128 0x316
	.long	.LASF679
	.byte	0x5
	.uleb128 0x31c
	.long	.LASF680
	.byte	0x5
	.uleb128 0x354
	.long	.LASF681
	.byte	0x5
	.uleb128 0x35f
	.long	.LASF682
	.byte	0x5
	.uleb128 0x36a
	.long	.LASF683
	.byte	0x5
	.uleb128 0x3b4
	.long	.LASF684
	.byte	0x5
	.uleb128 0x3b5
	.long	.LASF685
	.byte	0x5
	.uleb128 0x3d5
	.long	.LASF686
	.byte	0x5
	.uleb128 0x3d6
	.long	.LASF687
	.byte	0x5
	.uleb128 0x3d7
	.long	.LASF688
	.byte	0
	.section	.debug_macro,"G",@progbits,wm4.stdbool.h.29.07dce69c3b78884144b7f7bd19483461,comdat
.Ldebug_macro7:
	.word	0x4
	.byte	0
	.byte	0x5
	.uleb128 0x1d
	.long	.LASF689
	.byte	0x5
	.uleb128 0x21
	.long	.LASF690
	.byte	0x5
	.uleb128 0x22
	.long	.LASF691
	.byte	0x5
	.uleb128 0x23
	.long	.LASF692
	.byte	0x5
	.uleb128 0x34
	.long	.LASF693
	.byte	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF675:
	.string	"FDEV_SETUP_STREAM(p,g,f) { .put = p, .get = g, .flags = f, .udata = 0, }"
.LASF36:
	.string	"__WINT_TYPE__ int"
.LASF641:
	.string	"_SIZE_T_ "
.LASF353:
	.string	"__BUILTIN_AVR_INSERT_BITS 1"
.LASF65:
	.string	"__UINT_FAST64_TYPE__ long long unsigned int"
.LASF135:
	.string	"__FLT_MAX__ 3.40282347e+38F"
.LASF515:
	.string	"PRIdLEAST16 \"d\""
.LASF183:
	.string	"__DEC64_SUBNORMAL_MIN__ 0.000000000000001E-383DD"
.LASF125:
	.string	"__FLT_EVAL_METHOD__ 0"
.LASF370:
	.string	"__BUILTIN_AVR_ROUNDULLR 1"
.LASF530:
	.string	"PRIoFAST8 \"o\""
.LASF361:
	.string	"__BUILTIN_AVR_ABSLK 1"
.LASF567:
	.string	"PRIXPTR PRIX16"
.LASF450:
	.string	"INT16_MIN (-INT16_MAX - 1)"
.LASF519:
	.string	"PRIiFAST16 \"i\""
.LASF182:
	.string	"__DEC64_EPSILON__ 1E-15DD"
.LASF260:
	.string	"__ULACCUM_EPSILON__ 0x1P-32ULK"
.LASF424:
	.string	"__BUILTIN_AVR_UKBITS 1"
.LASF658:
	.string	"__SPGM 0x0008"
.LASF333:
	.string	"__AVR_HAVE_MUL__ 1"
.LASF701:
	.string	"char"
.LASF603:
	.string	"SCNx16 \"x\""
.LASF106:
	.string	"__UINT8_C(c) c"
.LASF552:
	.string	"PRIo32 \"lo\""
.LASF497:
	.string	"INT8_C(c) __INT8_C(c)"
.LASF395:
	.string	"__BUILTIN_AVR_BITSHR 1"
.LASF272:
	.string	"__QQ_IBIT__ 0"
.LASF288:
	.string	"__UDQ_IBIT__ 0"
.LASF448:
	.string	"UINT8_MAX (INT8_MAX * 2 + 1)"
.LASF582:
	.string	"SCNdFAST32 \"ld\""
.LASF596:
	.string	"SCNxFAST8 \"hhx\""
.LASF368:
	.string	"__BUILTIN_AVR_ROUNDUR 1"
.LASF629:
	.string	"_VA_LIST_DEFINED "
.LASF226:
	.string	"__ULLFRACT_FBIT__ 64"
.LASF262:
	.string	"__LLACCUM_IBIT__ 16"
.LASF312:
	.string	"__GCC_ATOMIC_CHAR16_T_LOCK_FREE 1"
.LASF69:
	.string	"__has_include_next(STR) __has_include_next__(STR)"
.LASF619:
	.string	"_ANSI_STDARG_H_ "
.LASF524:
	.string	"PRIiLEAST32 \"li\""
.LASF533:
	.string	"PRIuFAST8 \"u\""
.LASF324:
	.string	"__SIZEOF_WINT_T__ 2"
.LASF466:
	.string	"UINT_LEAST32_MAX UINT32_MAX"
.LASF222:
	.string	"__LLFRACT_IBIT__ 0"
.LASF152:
	.string	"__DBL_DENORM_MIN__ ((double)1.40129846e-45L)"
.LASF632:
	.string	"__need_NULL "
.LASF502:
	.string	"UINT16_C(c) __UINT16_C(c)"
.LASF636:
	.string	"_SIZE_T "
.LASF161:
	.string	"__LDBL_MAX_10_EXP__ 38"
.LASF560:
	.string	"PRIxFAST32 \"lx\""
.LASF198:
	.string	"__USFRACT_MIN__ 0.0UHR"
.LASF539:
	.string	"PRIXFAST8 \"X\""
.LASF666:
	.string	"EOF (-1)"
.LASF484:
	.string	"UINTPTR_MAX UINT16_MAX"
.LASF105:
	.string	"__UINT_LEAST8_MAX__ 0xff"
.LASF6:
	.string	"__GNUC_MINOR__ 4"
.LASF384:
	.string	"__BUILTIN_AVR_COUNTLSUR 1"
.LASF374:
	.string	"__BUILTIN_AVR_ROUNDLLK 1"
.LASF648:
	.string	"_GCC_SIZE_T "
.LASF440:
	.string	"_STDIO_H_ 1"
.LASF696:
	.string	"unsigned int"
.LASF508:
	.string	"PRId8 \"d\""
.LASF373:
	.string	"__BUILTIN_AVR_ROUNDLK 1"
.LASF344:
	.string	"__BUILTIN_AVR_SEI 1"
.LASF24:
	.string	"__SIZEOF_SIZE_T__ 2"
.LASF678:
	.string	"putchar(__c) fputc(__c, stdout)"
.LASF20:
	.string	"__SIZEOF_SHORT__ 2"
.LASF23:
	.string	"__SIZEOF_LONG_DOUBLE__ 4"
.LASF676:
	.string	"fdev_close() ((void)0)"
.LASF337:
	.string	"__AVR_HAVE_16BIT_SP__ 1"
.LASF682:
	.string	"feof(s) ((s)->flags & __SEOF)"
.LASF5:
	.string	"__GNUC__ 5"
.LASF28:
	.string	"__ORDER_BIG_ENDIAN__ 4321"
.LASF229:
	.string	"__ULLFRACT_MAX__ 0XFFFFFFFFFFFFFFFFP-64ULLR"
.LASF475:
	.string	"UINT_FAST16_MAX UINT16_MAX"
.LASF604:
	.string	"SCNxLEAST16 \"x\""
.LASF465:
	.string	"INT_LEAST32_MIN INT32_MIN"
.LASF685:
	.string	"_IONBF 0"
.LASF57:
	.string	"__UINT_LEAST64_TYPE__ long long unsigned int"
.LASF389:
	.string	"__BUILTIN_AVR_COUNTLSLK 1"
.LASF12:
	.string	"__ATOMIC_RELEASE 3"
.LASF556:
	.string	"PRIuLEAST32 \"lu\""
.LASF34:
	.string	"__PTRDIFF_TYPE__ int"
.LASF546:
	.string	"PRIx16 \"x\""
.LASF388:
	.string	"__BUILTIN_AVR_COUNTLSK 1"
.LASF175:
	.string	"__DEC32_EPSILON__ 1E-6DF"
.LASF18:
	.string	"__SIZEOF_LONG__ 4"
.LASF460:
	.string	"UINT_LEAST8_MAX UINT8_MAX"
.LASF435:
	.string	"__AVR_DEVICE_NAME__ atmega328p"
.LASF10:
	.string	"__ATOMIC_SEQ_CST 5"
.LASF100:
	.string	"__INT16_C(c) c"
.LASF564:
	.string	"PRIoPTR PRIo16"
.LASF137:
	.string	"__FLT_EPSILON__ 1.19209290e-7F"
.LASF434:
	.string	"__AVR_ATmega328P__ 1"
.LASF97:
	.string	"__INT_LEAST8_MAX__ 0x7f"
.LASF307:
	.string	"__REGISTER_PREFIX__ "
.LASF650:
	.string	"__size_t "
.LASF86:
	.string	"__UINTMAX_C(c) c ## ULL"
.LASF64:
	.string	"__UINT_FAST32_TYPE__ long unsigned int"
.LASF555:
	.string	"PRIu32 \"lu\""
.LASF367:
	.string	"__BUILTIN_AVR_ROUNDUHR 1"
.LASF30:
	.string	"__BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__"
.LASF176:
	.string	"__DEC32_SUBNORMAL_MIN__ 0.000001E-95DF"
.LASF490:
	.string	"SIG_ATOMIC_MAX INT8_MAX"
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
.LASF492:
	.string	"SIZE_MAX UINT16_MAX"
.LASF362:
	.string	"__BUILTIN_AVR_ABSLLK 1"
.LASF72:
	.string	"__SCHAR_MAX__ 0x7f"
.LASF441:
	.string	"__INTTYPES_H_ "
.LASF190:
	.string	"__DEC128_SUBNORMAL_MIN__ 0.000000000000000000000000000000001E-6143DL"
.LASF227:
	.string	"__ULLFRACT_IBIT__ 0"
.LASF383:
	.string	"__BUILTIN_AVR_COUNTLSUHR 1"
.LASF58:
	.string	"__INT_FAST8_TYPE__ signed char"
.LASF9:
	.string	"__ATOMIC_RELAXED 0"
.LASF52:
	.string	"__INT_LEAST32_TYPE__ long int"
.LASF609:
	.string	"SCNu32 \"lu\""
.LASF253:
	.string	"__LACCUM_MIN__ (-0X1P31LK-0X1P31LK)"
.LASF41:
	.string	"__SIG_ATOMIC_TYPE__ char"
.LASF258:
	.string	"__ULACCUM_MIN__ 0.0ULK"
.LASF504:
	.string	"UINT64_C(c) __UINT64_C(c)"
.LASF380:
	.string	"__BUILTIN_AVR_COUNTLSR 1"
.LASF140:
	.string	"__FLT_HAS_INFINITY__ 1"
.LASF653:
	.string	"NULL ((void *)0)"
.LASF114:
	.string	"__INT_FAST16_MAX__ 0x7fff"
.LASF325:
	.string	"__SIZEOF_PTRDIFF_T__ 2"
.LASF304:
	.string	"__UDA_IBIT__ 32"
.LASF476:
	.string	"INT_FAST32_MAX INT32_MAX"
.LASF61:
	.string	"__INT_FAST64_TYPE__ long long int"
.LASF98:
	.string	"__INT8_C(c) c"
.LASF639:
	.string	"_T_SIZE "
.LASF694:
	.string	"signed char"
.LASF565:
	.string	"PRIuPTR PRIu16"
.LASF706:
	.string	"C:\\\\Users\\\\Joel\\\\Dropbox\\\\Projects\\\\hc3d\\\\hc3d-tm\\\\hc3d-tm\\\\Debug"
.LASF579:
	.string	"SCNiFAST16 \"i\""
.LASF478:
	.string	"UINT_FAST32_MAX UINT32_MAX"
.LASF144:
	.string	"__DBL_MIN_EXP__ (-125)"
.LASF428:
	.string	"__BUILTIN_AVR_ROUNDFX 1"
.LASF268:
	.string	"__ULLACCUM_MIN__ 0.0ULLK"
.LASF580:
	.string	"SCNd32 \"ld\""
.LASF507:
	.string	"_GCC_WRAP_STDINT_H "
.LASF396:
	.string	"__BUILTIN_AVR_BITSR 1"
.LASF364:
	.string	"__BUILTIN_AVR_ROUNDR 1"
.LASF529:
	.string	"PRIoLEAST8 \"o\""
.LASF67:
	.string	"__UINTPTR_TYPE__ unsigned int"
.LASF411:
	.string	"__BUILTIN_AVR_HRBITS 1"
.LASF535:
	.string	"PRIxLEAST8 \"x\""
.LASF622:
	.string	"va_start(v,l) __builtin_va_start(v,l)"
.LASF617:
	.string	"SCNxPTR SCNx16"
.LASF472:
	.string	"UINT_FAST8_MAX UINT8_MAX"
.LASF294:
	.string	"__SA_IBIT__ 16"
.LASF224:
	.string	"__LLFRACT_MAX__ 0X7FFFFFFFFFFFFFFFP-63LLR"
.LASF116:
	.string	"__INT_FAST64_MAX__ 0x7fffffffffffffffLL"
.LASF561:
	.string	"PRIX32 \"lX\""
.LASF610:
	.string	"SCNuLEAST32 \"lu\""
.LASF121:
	.string	"__INTPTR_MAX__ 0x7fff"
.LASF129:
	.string	"__FLT_DIG__ 6"
.LASF642:
	.string	"_BSD_SIZE_T_ "
.LASF670:
	.string	"_FDEV_SETUP_READ __SRD"
.LASF295:
	.string	"__DA_FBIT__ 31"
.LASF477:
	.string	"INT_FAST32_MIN INT32_MIN"
.LASF420:
	.string	"__BUILTIN_AVR_KBITS 1"
.LASF306:
	.string	"__UTA_IBIT__ 16"
.LASF173:
	.string	"__DEC32_MIN__ 1E-95DF"
.LASF615:
	.string	"SCNoPTR SCNo16"
.LASF240:
	.string	"__USACCUM_EPSILON__ 0x1P-8UHK"
.LASF663:
	.string	"stdin (__iob[0])"
.LASF645:
	.string	"_BSD_SIZE_T_DEFINED_ "
.LASF259:
	.string	"__ULACCUM_MAX__ 0XFFFFFFFFFFFFFFFFP-32ULK"
.LASF209:
	.string	"__UFRACT_MAX__ 0XFFFFP-16UR"
.LASF194:
	.string	"__SFRACT_MAX__ 0X7FP-7HR"
.LASF594:
	.string	"SCNx8 \"hhx\""
.LASF522:
	.string	"PRIdFAST32 \"ld\""
.LASF584:
	.string	"SCNiLEAST32 \"li\""
.LASF592:
	.string	"SCNuLEAST8 \"hhu\""
.LASF700:
	.string	"long long unsigned int"
.LASF601:
	.string	"SCNuLEAST16 \"u\""
.LASF185:
	.string	"__DEC128_MIN_EXP__ (-6142)"
.LASF614:
	.string	"SCNxFAST32 \"lx\""
.LASF447:
	.string	"INT8_MIN (-INT8_MAX - 1)"
.LASF534:
	.string	"PRIx8 \"x\""
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
.LASF513:
	.string	"PRIiFAST8 \"i\""
.LASF111:
	.string	"__UINT_LEAST64_MAX__ 0xffffffffffffffffULL"
.LASF127:
	.string	"__FLT_RADIX__ 2"
.LASF403:
	.string	"__BUILTIN_AVR_BITSHK 1"
.LASF684:
	.string	"BUFSIZ 1024"
.LASF454:
	.string	"UINT32_MAX (__CONCAT(INT32_MAX, U) * 2UL + 1UL)"
.LASF228:
	.string	"__ULLFRACT_MIN__ 0.0ULLR"
.LASF155:
	.string	"__DBL_HAS_QUIET_NAN__ 1"
.LASF248:
	.string	"__UACCUM_MIN__ 0.0UK"
.LASF547:
	.string	"PRIxLEAST16 \"x\""
.LASF215:
	.string	"__LFRACT_EPSILON__ 0x1P-31LR"
.LASF453:
	.string	"INT32_MIN (-INT32_MAX - 1L)"
.LASF376:
	.string	"__BUILTIN_AVR_ROUNDUK 1"
.LASF661:
	.string	"__SUNGET 0x040"
.LASF63:
	.string	"__UINT_FAST16_TYPE__ unsigned int"
.LASF117:
	.string	"__UINT_FAST8_MAX__ 0xff"
.LASF496:
	.string	"WINT_MIN __WINT_MIN__"
.LASF39:
	.string	"__CHAR16_TYPE__ unsigned int"
.LASF231:
	.string	"__SACCUM_FBIT__ 7"
.LASF542:
	.string	"PRIoFAST16 \"o\""
.LASF577:
	.string	"SCNi16 \"i\""
.LASF181:
	.string	"__DEC64_MAX__ 9.999999999999999E384DD"
.LASF203:
	.string	"__FRACT_MIN__ (-0.5R-0.5R)"
.LASF316:
	.string	"__GCC_ATOMIC_INT_LOCK_FREE 1"
.LASF664:
	.string	"stdout (__iob[1])"
.LASF83:
	.string	"__INTMAX_MAX__ 0x7fffffffffffffffLL"
.LASF400:
	.string	"__BUILTIN_AVR_BITSUR 1"
.LASF250:
	.string	"__UACCUM_EPSILON__ 0x1P-16UK"
.LASF439:
	.string	"F_CPU 16000000"
.LASF563:
	.string	"PRIXFAST32 \"lX\""
.LASF242:
	.string	"__ACCUM_IBIT__ 16"
.LASF392:
	.string	"__BUILTIN_AVR_COUNTLSUK 1"
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
.LASF444:
	.string	"__CONCATenate(left,right) left ## right"
.LASF184:
	.string	"__DEC128_MANT_DIG__ 34"
.LASF548:
	.string	"PRIxFAST16 \"x\""
.LASF156:
	.string	"__LDBL_MANT_DIG__ 24"
.LASF21:
	.string	"__SIZEOF_FLOAT__ 4"
.LASF430:
	.string	"__INT24_MAX__ 8388607L"
.LASF110:
	.string	"__UINT32_C(c) c ## UL"
.LASF172:
	.string	"__DEC32_MAX_EXP__ 97"
.LASF625:
	.string	"va_copy(d,s) __builtin_va_copy(d,s)"
.LASF525:
	.string	"PRIiFAST32 \"li\""
.LASF689:
	.string	"_STDBOOL_H "
.LASF518:
	.string	"PRIiLEAST16 \"i\""
.LASF261:
	.string	"__LLACCUM_FBIT__ 47"
.LASF531:
	.string	"PRIu8 \"u\""
.LASF26:
	.string	"__BIGGEST_ALIGNMENT__ 1"
.LASF536:
	.string	"PRIxFAST8 \"x\""
.LASF540:
	.string	"PRIo16 \"o\""
.LASF296:
	.string	"__DA_IBIT__ 32"
.LASF252:
	.string	"__LACCUM_IBIT__ 32"
.LASF146:
	.string	"__DBL_MAX_EXP__ 128"
.LASF199:
	.string	"__USFRACT_MAX__ 0XFFP-8UHR"
.LASF643:
	.string	"_SIZE_T_DEFINED_ "
.LASF397:
	.string	"__BUILTIN_AVR_BITSLR 1"
.LASF598:
	.string	"SCNoLEAST16 \"o\""
.LASF489:
	.string	"PTRDIFF_MIN INT16_MIN"
.LASF15:
	.string	"__OPTIMIZE__ 1"
.LASF293:
	.string	"__SA_FBIT__ 15"
.LASF352:
	.string	"__BUILTIN_AVR_DELAY_CYCLES 1"
.LASF355:
	.string	"__BUILTIN_AVR_ABSHR 1"
.LASF70:
	.string	"__GXX_ABI_VERSION 1009"
.LASF553:
	.string	"PRIoLEAST32 \"lo\""
.LASF593:
	.string	"SCNuFAST8 \"hhu\""
.LASF235:
	.string	"__SACCUM_EPSILON__ 0x1P-7HK"
.LASF263:
	.string	"__LLACCUM_MIN__ (-0X1P15LLK-0X1P15LLK)"
.LASF501:
	.string	"UINT8_C(c) __UINT8_C(c)"
.LASF59:
	.string	"__INT_FAST16_TYPE__ int"
.LASF687:
	.string	"SEEK_CUR 1"
.LASF459:
	.string	"INT_LEAST8_MIN INT8_MIN"
.LASF627:
	.string	"_VA_LIST_ "
.LASF654:
	.string	"__need_NULL"
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
.LASF481:
	.string	"UINT_FAST64_MAX UINT64_MAX"
.LASF505:
	.string	"INTMAX_C(c) __INTMAX_C(c)"
.LASF76:
	.string	"__LONG_LONG_MAX__ 0x7fffffffffffffffLL"
.LASF461:
	.string	"INT_LEAST16_MAX INT16_MAX"
.LASF133:
	.string	"__FLT_MAX_10_EXP__ 38"
.LASF87:
	.string	"__SIG_ATOMIC_MAX__ 0x7f"
.LASF588:
	.string	"SCNo8 \"hho\""
.LASF532:
	.string	"PRIuLEAST8 \"u\""
.LASF605:
	.string	"SCNxFAST16 \"x\""
.LASF537:
	.string	"PRIX8 \"X\""
.LASF463:
	.string	"UINT_LEAST16_MAX UINT16_MAX"
.LASF608:
	.string	"SCNoFAST32 \"lo\""
.LASF511:
	.string	"PRIi8 \"i\""
.LASF576:
	.string	"SCNdFAST16 \"d\""
.LASF590:
	.string	"SCNoFAST8 \"hho\""
.LASF237:
	.string	"__USACCUM_IBIT__ 8"
.LASF218:
	.string	"__ULFRACT_MIN__ 0.0ULR"
.LASF128:
	.string	"__FLT_MANT_DIG__ 24"
.LASF286:
	.string	"__USQ_IBIT__ 0"
.LASF520:
	.string	"PRId32 \"ld\""
.LASF479:
	.string	"INT_FAST64_MAX INT64_MAX"
.LASF690:
	.string	"bool _Bool"
.LASF659:
	.string	"__SERR 0x0010"
.LASF247:
	.string	"__UACCUM_IBIT__ 16"
.LASF166:
	.string	"__LDBL_DENORM_MIN__ 1.40129846e-45L"
.LASF162:
	.string	"__DECIMAL_DIG__ 9"
.LASF443:
	.string	"__USING_MINT8 0"
.LASF378:
	.string	"__BUILTIN_AVR_ROUNDULLK 1"
.LASF468:
	.string	"INT_LEAST64_MIN INT64_MIN"
.LASF349:
	.string	"__BUILTIN_AVR_FMUL 1"
.LASF139:
	.string	"__FLT_HAS_DENORM__ 1"
.LASF418:
	.string	"__BUILTIN_AVR_ULLRBITS 1"
.LASF607:
	.string	"SCNoLEAST32 \"lo\""
.LASF47:
	.string	"__UINT16_TYPE__ unsigned int"
.LASF201:
	.string	"__FRACT_FBIT__ 15"
.LASF469:
	.string	"UINT_LEAST64_MAX UINT64_MAX"
.LASF426:
	.string	"__BUILTIN_AVR_ULLKBITS 1"
.LASF623:
	.string	"va_end(v) __builtin_va_end(v)"
.LASF638:
	.string	"_T_SIZE_ "
.LASF404:
	.string	"__BUILTIN_AVR_BITSK 1"
.LASF94:
	.string	"__UINT16_MAX__ 0xffffU"
.LASF606:
	.string	"SCNo32 \"lo\""
.LASF467:
	.string	"INT_LEAST64_MAX INT64_MAX"
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
.LASF591:
	.string	"SCNu8 \"hhu\""
.LASF635:
	.string	"__SIZE_T__ "
.LASF221:
	.string	"__LLFRACT_FBIT__ 63"
.LASF637:
	.string	"_SYS_SIZE_T_H "
.LASF655:
	.string	"__SRD 0x0001"
.LASF456:
	.string	"INT64_MIN (-INT64_MAX - 1LL)"
.LASF301:
	.string	"__USA_FBIT__ 16"
.LASF93:
	.string	"__UINT8_MAX__ 0xff"
.LASF437:
	.string	"DEBUG 1"
.LASF649:
	.string	"_SIZET_ "
.LASF375:
	.string	"__BUILTIN_AVR_ROUNDUHK 1"
.LASF516:
	.string	"PRIdFAST16 \"d\""
.LASF679:
	.string	"getc(__stream) fgetc(__stream)"
.LASF174:
	.string	"__DEC32_MAX__ 9.999999E96DF"
.LASF211:
	.string	"__LFRACT_FBIT__ 31"
.LASF558:
	.string	"PRIx32 \"lx\""
.LASF673:
	.string	"_FDEV_ERR (-1)"
.LASF707:
	.string	"failsafe_trigger"
.LASF16:
	.string	"__FINITE_MATH_ONLY__ 0"
.LASF600:
	.string	"SCNu16 \"u\""
.LASF544:
	.string	"PRIuLEAST16 \"u\""
.LASF691:
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
.LASF287:
	.string	"__UDQ_FBIT__ 64"
.LASF339:
	.string	"__AVR_SFR_OFFSET__ 0x20"
.LASF232:
	.string	"__SACCUM_IBIT__ 8"
.LASF688:
	.string	"SEEK_END 2"
.LASF356:
	.string	"__BUILTIN_AVR_ABSR 1"
.LASF289:
	.string	"__UTQ_FBIT__ 128"
.LASF264:
	.string	"__LLACCUM_MAX__ 0X7FFFFFFFFFFFFFFFP-47LLK"
.LASF699:
	.string	"long long int"
.LASF25:
	.string	"__CHAR_BIT__ 8"
.LASF523:
	.string	"PRIi32 \"li\""
.LASF265:
	.string	"__LLACCUM_EPSILON__ 0x1P-47LLK"
.LASF702:
	.string	"driver_relay_set"
.LASF703:
	.string	"printf"
.LASF54:
	.string	"__UINT_LEAST8_TYPE__ unsigned char"
.LASF483:
	.string	"INTPTR_MIN INT16_MIN"
.LASF157:
	.string	"__LDBL_DIG__ 6"
.LASF234:
	.string	"__SACCUM_MAX__ 0X7FFFP-7HK"
.LASF528:
	.string	"PRIo8 \"o\""
.LASF568:
	.string	"SCNd8 \"hhd\""
.LASF372:
	.string	"__BUILTIN_AVR_ROUNDK 1"
.LASF280:
	.string	"__TQ_IBIT__ 0"
.LASF299:
	.string	"__UHA_FBIT__ 8"
.LASF462:
	.string	"INT_LEAST16_MIN INT16_MIN"
.LASF616:
	.string	"SCNuPTR SCNu16"
.LASF704:
	.string	"GNU C99 5.4.0 -mn-flash=1 -mno-skip-bug -mrelax -mmcu=avr5 -g3 -Og -std=gnu99 -ffunction-sections -fdata-sections -fpack-struct -fshort-enums -fno-strict-aliasing"
.LASF487:
	.string	"UINTMAX_MAX UINT64_MAX"
.LASF562:
	.string	"PRIXLEAST32 \"lX\""
.LASF423:
	.string	"__BUILTIN_AVR_UHKBITS 1"
.LASF599:
	.string	"SCNoFAST16 \"o\""
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
.LASF200:
	.string	"__USFRACT_EPSILON__ 0x1P-8UHR"
.LASF11:
	.string	"__ATOMIC_ACQUIRE 2"
.LASF369:
	.string	"__BUILTIN_AVR_ROUNDULR 1"
.LASF634:
	.string	"__size_t__ "
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
.LASF545:
	.string	"PRIuFAST16 \"u\""
.LASF493:
	.string	"WCHAR_MAX __WCHAR_MAX__"
.LASF517:
	.string	"PRIi16 \"i\""
.LASF75:
	.string	"__LONG_MAX__ 0x7fffffffL"
.LASF90:
	.string	"__INT16_MAX__ 0x7fff"
.LASF216:
	.string	"__ULFRACT_FBIT__ 32"
.LASF626:
	.string	"__va_copy(d,s) __builtin_va_copy(d,s)"
.LASF22:
	.string	"__SIZEOF_DOUBLE__ 4"
.LASF60:
	.string	"__INT_FAST32_TYPE__ long int"
.LASF243:
	.string	"__ACCUM_MIN__ (-0X1P15K-0X1P15K)"
.LASF118:
	.string	"__UINT_FAST16_MAX__ 0xffffU"
.LASF458:
	.string	"INT_LEAST8_MAX INT8_MAX"
.LASF7:
	.string	"__GNUC_PATCHLEVEL__ 0"
.LASF405:
	.string	"__BUILTIN_AVR_BITSLK 1"
.LASF677:
	.string	"putc(__c,__stream) fputc(__c, __stream)"
.LASF204:
	.string	"__FRACT_MAX__ 0X7FFFP-15R"
.LASF45:
	.string	"__INT64_TYPE__ long long int"
.LASF256:
	.string	"__ULACCUM_FBIT__ 32"
.LASF656:
	.string	"__SWR 0x0002"
.LASF208:
	.string	"__UFRACT_MIN__ 0.0UR"
.LASF326:
	.string	"__AVR 1"
.LASF186:
	.string	"__DEC128_MAX_EXP__ 6145"
.LASF526:
	.string	"PRIdPTR PRId16"
.LASF330:
	.string	"__AVR_HAVE_MOVW__ 1"
.LASF2:
	.string	"__STDC_UTF_16__ 1"
.LASF386:
	.string	"__BUILTIN_AVR_COUNTLSULLR 1"
.LASF509:
	.string	"PRIdLEAST8 \"d\""
.LASF202:
	.string	"__FRACT_IBIT__ 0"
.LASF471:
	.string	"INT_FAST8_MIN INT8_MIN"
.LASF168:
	.string	"__LDBL_HAS_INFINITY__ 1"
.LASF124:
	.string	"__GCC_IEC_559_COMPLEX 0"
.LASF95:
	.string	"__UINT32_MAX__ 0xffffffffUL"
.LASF136:
	.string	"__FLT_MIN__ 1.17549435e-38F"
.LASF628:
	.string	"_VA_LIST "
.LASF323:
	.string	"__SIZEOF_WCHAR_T__ 2"
.LASF503:
	.string	"UINT32_C(c) __UINT32_C(c)"
.LASF267:
	.string	"__ULLACCUM_IBIT__ 16"
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
.LASF495:
	.string	"WINT_MAX __WINT_MAX__"
.LASF401:
	.string	"__BUILTIN_AVR_BITSULR 1"
.LASF159:
	.string	"__LDBL_MIN_10_EXP__ (-37)"
.LASF163:
	.string	"__LDBL_MAX__ 3.40282347e+38L"
.LASF225:
	.string	"__LLFRACT_EPSILON__ 0x1P-63LLR"
.LASF620:
	.string	"__need___va_list"
.LASF672:
	.string	"_FDEV_SETUP_RW (__SRD|__SWR)"
.LASF665:
	.string	"stderr (__iob[2])"
.LASF681:
	.string	"clearerror(s) do { (s)->flags &= ~(__SERR | __SEOF); } while(0)"
.LASF191:
	.string	"__SFRACT_FBIT__ 7"
.LASF40:
	.string	"__CHAR32_TYPE__ long unsigned int"
.LASF192:
	.string	"__SFRACT_IBIT__ 0"
.LASF597:
	.string	"SCNo16 \"o\""
.LASF602:
	.string	"SCNuFAST16 \"u\""
.LASF274:
	.string	"__HQ_IBIT__ 0"
.LASF514:
	.string	"PRId16 \"d\""
.LASF308:
	.string	"__USER_LABEL_PREFIX__ "
.LASF651:
	.string	"__need_size_t"
.LASF56:
	.string	"__UINT_LEAST32_TYPE__ long unsigned int"
.LASF277:
	.string	"__DQ_FBIT__ 63"
.LASF239:
	.string	"__USACCUM_MAX__ 0XFFFFP-8UHK"
.LASF506:
	.string	"UINTMAX_C(c) __UINTMAX_C(c)"
.LASF455:
	.string	"INT64_MAX 0x7fffffffffffffffLL"
.LASF332:
	.string	"__AVR_ENHANCED__ 1"
.LASF73:
	.string	"__SHRT_MAX__ 0x7fff"
.LASF29:
	.string	"__ORDER_PDP_ENDIAN__ 3412"
.LASF668:
	.string	"fdev_get_udata(stream) ((stream)->udata)"
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
.LASF574:
	.string	"SCNd16 \"d\""
.LASF630:
	.string	"_VA_LIST_T_H "
.LASF621:
	.string	"__GNUC_VA_LIST "
.LASF281:
	.string	"__UQQ_FBIT__ 8"
.LASF113:
	.string	"__INT_FAST8_MAX__ 0x7f"
.LASF491:
	.string	"SIG_ATOMIC_MIN INT8_MIN"
.LASF336:
	.string	"__AVR_2_BYTE_PC__ 1"
.LASF366:
	.string	"__BUILTIN_AVR_ROUNDLLR 1"
.LASF551:
	.string	"PRIXFAST16 \"X\""
.LASF538:
	.string	"PRIXLEAST8 \"X\""
.LASF179:
	.string	"__DEC64_MAX_EXP__ 385"
.LASF346:
	.string	"__BUILTIN_AVR_WDR 1"
.LASF464:
	.string	"INT_LEAST32_MAX INT32_MAX"
.LASF44:
	.string	"__INT32_TYPE__ long int"
.LASF414:
	.string	"__BUILTIN_AVR_LLRBITS 1"
.LASF697:
	.string	"long int"
.LASF500:
	.string	"INT64_C(c) __INT64_C(c)"
.LASF572:
	.string	"SCNiLEAST8 \"hhi\""
.LASF510:
	.string	"PRIdFAST8 \"d\""
.LASF457:
	.string	"UINT64_MAX (__CONCAT(INT64_MAX, U) * 2ULL + 1ULL)"
.LASF275:
	.string	"__SQ_FBIT__ 31"
.LASF80:
	.string	"__WINT_MIN__ (-__WINT_MAX__ - 1)"
.LASF213:
	.string	"__LFRACT_MIN__ (-0.5LR-0.5LR)"
.LASF473:
	.string	"INT_FAST16_MAX INT16_MAX"
.LASF187:
	.string	"__DEC128_MIN__ 1E-6143DL"
.LASF345:
	.string	"__BUILTIN_AVR_CLI 1"
.LASF680:
	.string	"getchar() fgetc(stdin)"
.LASF109:
	.string	"__UINT_LEAST32_MAX__ 0xffffffffUL"
.LASF438:
	.string	"BOARD USER_BOARD"
.LASF82:
	.string	"__SIZE_MAX__ 0xffffU"
.LASF62:
	.string	"__UINT_FAST8_TYPE__ unsigned char"
.LASF586:
	.string	"SCNdPTR SCNd16"
.LASF674:
	.string	"_FDEV_EOF (-2)"
.LASF169:
	.string	"__LDBL_HAS_QUIET_NAN__ 1"
.LASF42:
	.string	"__INT8_TYPE__ signed char"
.LASF35:
	.string	"__WCHAR_TYPE__ int"
.LASF573:
	.string	"SCNiFAST8 \"hhi\""
.LASF427:
	.string	"__BUILTIN_AVR_ABSFX 1"
.LASF360:
	.string	"__BUILTIN_AVR_ABSK 1"
.LASF279:
	.string	"__TQ_FBIT__ 127"
.LASF633:
	.string	"__need_size_t "
.LASF485:
	.string	"INTMAX_MAX INT64_MAX"
.LASF55:
	.string	"__UINT_LEAST16_TYPE__ unsigned int"
.LASF283:
	.string	"__UHQ_FBIT__ 16"
.LASF338:
	.string	"__AVR_HAVE_SPH__ 1"
.LASF581:
	.string	"SCNdLEAST32 \"ld\""
.LASF585:
	.string	"SCNiFAST32 \"li\""
.LASF340:
	.string	"__WITH_AVRLIBC__ 1"
.LASF120:
	.string	"__UINT_FAST64_MAX__ 0xffffffffffffffffULL"
.LASF570:
	.string	"SCNdFAST8 \"hhd\""
.LASF196:
	.string	"__USFRACT_FBIT__ 8"
.LASF104:
	.string	"__INT64_C(c) c ## LL"
.LASF273:
	.string	"__HQ_FBIT__ 15"
.LASF300:
	.string	"__UHA_IBIT__ 8"
.LASF521:
	.string	"PRIdLEAST32 \"ld\""
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
.LASF50:
	.string	"__INT_LEAST8_TYPE__ signed char"
.LASF482:
	.string	"INTPTR_MAX INT16_MAX"
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
.LASF569:
	.string	"SCNdLEAST8 \"hhd\""
.LASF32:
	.string	"__SIZEOF_POINTER__ 2"
.LASF421:
	.string	"__BUILTIN_AVR_LKBITS 1"
.LASF249:
	.string	"__UACCUM_MAX__ 0XFFFFFFFFP-16UK"
.LASF377:
	.string	"__BUILTIN_AVR_ROUNDULK 1"
.LASF474:
	.string	"INT_FAST16_MIN INT16_MIN"
.LASF313:
	.string	"__GCC_ATOMIC_CHAR32_T_LOCK_FREE 1"
.LASF219:
	.string	"__ULFRACT_MAX__ 0XFFFFFFFFP-32ULR"
.LASF291:
	.string	"__HA_FBIT__ 7"
.LASF357:
	.string	"__BUILTIN_AVR_ABSLR 1"
.LASF669:
	.string	"fdev_setup_stream(stream,p,g,f) do { (stream)->put = p; (stream)->get = g; (stream)->flags = f; (stream)->udata = 0; } while(0)"
.LASF359:
	.string	"__BUILTIN_AVR_ABSHK 1"
.LASF371:
	.string	"__BUILTIN_AVR_ROUNDHK 1"
.LASF233:
	.string	"__SACCUM_MIN__ (-0X1P7HK-0X1P7HK)"
.LASF644:
	.string	"_SIZE_T_DEFINED "
.LASF705:
	.string	"../src/business_logic/failsafe.c"
.LASF412:
	.string	"__BUILTIN_AVR_RBITS 1"
.LASF112:
	.string	"__UINT64_C(c) c ## ULL"
.LASF557:
	.string	"PRIuFAST32 \"lu\""
.LASF554:
	.string	"PRIoFAST32 \"lo\""
.LASF255:
	.string	"__LACCUM_EPSILON__ 0x1P-31LK"
.LASF43:
	.string	"__INT16_TYPE__ int"
.LASF575:
	.string	"SCNdLEAST16 \"d\""
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
.LASF698:
	.string	"long unsigned int"
.LASF77:
	.string	"__WCHAR_MAX__ 0x7fff"
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
.LASF541:
	.string	"PRIoLEAST16 \"o\""
.LASF647:
	.string	"___int_size_t_h "
.LASF205:
	.string	"__FRACT_EPSILON__ 0x1P-15R"
.LASF4:
	.string	"__STDC_HOSTED__ 1"
.LASF611:
	.string	"SCNuFAST32 \"lu\""
.LASF486:
	.string	"INTMAX_MIN INT64_MIN"
.LASF394:
	.string	"__BUILTIN_AVR_COUNTLSULLK 1"
.LASF8:
	.string	"__VERSION__ \"5.4.0\""
.LASF320:
	.string	"__GCC_ATOMIC_POINTER_LOCK_FREE 1"
.LASF68:
	.string	"__has_include(STR) __has_include__(STR)"
.LASF480:
	.string	"INT_FAST64_MIN INT64_MIN"
.LASF165:
	.string	"__LDBL_EPSILON__ 1.19209290e-7L"
.LASF398:
	.string	"__BUILTIN_AVR_BITSLLR 1"
.LASF543:
	.string	"PRIu16 \"u\""
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
.LASF695:
	.string	"unsigned char"
.LASF171:
	.string	"__DEC32_MIN_EXP__ (-94)"
.LASF38:
	.string	"__UINTMAX_TYPE__ long long unsigned int"
.LASF652:
	.string	"NULL"
.LASF408:
	.string	"__BUILTIN_AVR_BITSUK 1"
.LASF66:
	.string	"__INTPTR_TYPE__ int"
.LASF571:
	.string	"SCNi8 \"hhi\""
.LASF126:
	.string	"__DEC_EVAL_METHOD__ 2"
.LASF238:
	.string	"__USACCUM_MIN__ 0.0UHK"
.LASF662:
	.string	"__SMALLOC 0x80"
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
.LASF667:
	.string	"fdev_set_udata(stream,u) do { (stream)->udata = u; } while(0)"
.LASF147:
	.string	"__DBL_MAX_10_EXP__ 38"
.LASF488:
	.string	"PTRDIFF_MAX INT16_MAX"
.LASF33:
	.string	"__SIZE_TYPE__ unsigned int"
.LASF494:
	.string	"WCHAR_MIN __WCHAR_MIN__"
.LASF449:
	.string	"INT16_MAX 0x7fff"
.LASF512:
	.string	"PRIiLEAST8 \"i\""
.LASF416:
	.string	"__BUILTIN_AVR_URBITS 1"
.LASF446:
	.string	"INT8_MAX 0x7f"
.LASF315:
	.string	"__GCC_ATOMIC_SHORT_LOCK_FREE 1"
.LASF693:
	.string	"__bool_true_false_are_defined 1"
.LASF657:
	.string	"__SSTR 0x0004"
.LASF297:
	.string	"__TA_FBIT__ 47"
.LASF402:
	.string	"__BUILTIN_AVR_BITSULLR 1"
.LASF381:
	.string	"__BUILTIN_AVR_COUNTLSLR 1"
.LASF527:
	.string	"PRIiPTR PRIi16"
.LASF131:
	.string	"__FLT_MIN_10_EXP__ (-37)"
.LASF445:
	.string	"__CONCAT(left,right) __CONCATenate(left, right)"
.LASF618:
	.string	"_STDARG_H "
.LASF660:
	.string	"__SEOF 0x0020"
.LASF154:
	.string	"__DBL_HAS_INFINITY__ 1"
.LASF583:
	.string	"SCNi32 \"li\""
.LASF589:
	.string	"SCNoLEAST8 \"hho\""
.LASF671:
	.string	"_FDEV_SETUP_WRITE __SWR"
.LASF410:
	.string	"__BUILTIN_AVR_BITSULLK 1"
.LASF442:
	.string	"__STDINT_H_ "
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
.LASF99:
	.string	"__INT_LEAST16_MAX__ 0x7fff"
.LASF142:
	.string	"__DBL_MANT_DIG__ 24"
.LASF71:
	.string	"__USING_SJLJ_EXCEPTIONS__ 1"
.LASF470:
	.string	"INT_FAST8_MAX INT8_MAX"
.LASF646:
	.string	"_SIZE_T_DECLARED "
.LASF451:
	.string	"UINT16_MAX (__CONCAT(INT16_MAX, U) * 2U + 1U)"
.LASF49:
	.string	"__UINT64_TYPE__ long long unsigned int"
.LASF350:
	.string	"__BUILTIN_AVR_FMULS 1"
.LASF452:
	.string	"INT32_MAX 0x7fffffffL"
.LASF566:
	.string	"PRIxPTR PRIx16"
.LASF391:
	.string	"__BUILTIN_AVR_COUNTLSUHK 1"
.LASF309:
	.string	"__GNUC_STDC_INLINE__ 1"
.LASF271:
	.string	"__QQ_FBIT__ 7"
.LASF595:
	.string	"SCNxLEAST8 \"hhx\""
.LASF417:
	.string	"__BUILTIN_AVR_ULRBITS 1"
.LASF358:
	.string	"__BUILTIN_AVR_ABSLLR 1"
.LASF578:
	.string	"SCNiLEAST16 \"i\""
.LASF270:
	.string	"__ULLACCUM_EPSILON__ 0x1P-48ULLK"
.LASF143:
	.string	"__DBL_DIG__ 6"
.LASF130:
	.string	"__FLT_MIN_EXP__ (-125)"
.LASF379:
	.string	"__BUILTIN_AVR_COUNTLSHR 1"
.LASF310:
	.string	"__GCC_ATOMIC_BOOL_LOCK_FREE 1"
.LASF188:
	.string	"__DEC128_MAX__ 9.999999999999999999999999999999999E6144DL"
.LASF266:
	.string	"__ULLACCUM_FBIT__ 48"
.LASF413:
	.string	"__BUILTIN_AVR_LRBITS 1"
.LASF102:
	.string	"__INT32_C(c) c ## L"
.LASF692:
	.string	"false 0"
.LASF640:
	.string	"__SIZE_T "
.LASF587:
	.string	"SCNiPTR SCNi16"
.LASF329:
	.string	"__AVR_ARCH__ 5"
.LASF331:
	.string	"__AVR_HAVE_LPMX__ 1"
.LASF549:
	.string	"PRIX16 \"X\""
.LASF631:
	.string	"__va_list__ "
.LASF347:
	.string	"__BUILTIN_AVR_SLEEP 1"
.LASF612:
	.string	"SCNx32 \"lx\""
.LASF214:
	.string	"__LFRACT_MAX__ 0X7FFFFFFFP-31LR"
.LASF559:
	.string	"PRIxLEAST32 \"lx\""
.LASF303:
	.string	"__UDA_FBIT__ 32"
.LASF432:
	.string	"__UINT24_MAX__ 16777215UL"
.LASF422:
	.string	"__BUILTIN_AVR_LLKBITS 1"
.LASF342:
	.string	"__MEMX 1"
.LASF613:
	.string	"SCNxLEAST32 \"lx\""
.LASF81:
	.string	"__PTRDIFF_MAX__ 0x7fff"
.LASF101:
	.string	"__INT_LEAST32_MAX__ 0x7fffffffL"
.LASF498:
	.string	"INT16_C(c) __INT16_C(c)"
.LASF180:
	.string	"__DEC64_MIN__ 1E-383DD"
.LASF499:
	.string	"INT32_C(c) __INT32_C(c)"
.LASF686:
	.string	"SEEK_SET 0"
.LASF683:
	.string	"ferror(s) ((s)->flags & __SERR)"
.LASF322:
	.string	"__PRAGMA_REDEFINE_EXTNAME 1"
.LASF624:
	.string	"va_arg(v,l) __builtin_va_arg(v,l)"
.LASF223:
	.string	"__LLFRACT_MIN__ (-0.5LLR-0.5LLR)"
.LASF328:
	.string	"AVR 1"
.LASF230:
	.string	"__ULLFRACT_EPSILON__ 0x1P-64ULLR"
.LASF167:
	.string	"__LDBL_HAS_DENORM__ 1"
.LASF158:
	.string	"__LDBL_MIN_EXP__ (-125)"
.LASF550:
	.string	"PRIXLEAST16 \"X\""
.LASF177:
	.string	"__DEC64_MANT_DIG__ 16"
.LASF123:
	.string	"__GCC_IEC_559 0"
	.ident	"GCC: (AVR_8_bit_GNU_Toolchain_3.6.2_1778) 5.4.0"
.global __do_copy_data
