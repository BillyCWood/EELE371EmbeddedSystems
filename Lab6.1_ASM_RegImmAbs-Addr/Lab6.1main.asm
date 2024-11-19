;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;William Wood EELE 371 January 27, 2023
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------





main:


	; Step 3: Immediate Mode Addressing
	mov.w	#4444h, R4
	mov.w	#5555h, R5
	mov.w	#6666h, R6


	; Step 4: Clearing w/ Immediate Mode Addressing
	mov.w	#0000h, R4
	mov.w	#0000h, R5
	mov.w	#0000h, R6


	; Step 5: Immediate Mode Addressing and 8-bit Operations
	mov.b	#77h, R7
	mov.b	#88h, R8
	mov.b	#99h, R9

;-------------------------------------------------------------------------------


	; Step 7: Register Mode Addressing and 8-bit Operations
	mov.b	R7, R10
	mov.b	R8,	R11
	mov.b	R9, R12

	; Step 8: Resister Mode Addressing and 16-bit Operations
	mov.w	SP, R13	;SP - Stack Pointer
	mov.w	PC, R14 ;PC - Program Counter

;-------------------------------------------------------------------------------


	; Step 11: Absolute Mode Addressing to Copy Info w/in Data Memory
	mov.w	&2002h,	&2022h
	mov.w	&2004h,	&2024h
	mov.w	&2006h,	&2026h
	mov.w	&2008h,	&2028h
	mov.w	&200Ah,	&202Ah


	mov.b	&2040h, &204Bh
	mov.b	&2043h, &204Ah
	mov.b	&2042h, &204Dh
	mov.b	&2044h, &204Ch
	mov.b	&2046h, &204Fh

                                            


	jmp		main
	NOP


;-------------------------------------------------------------------------------


	; Step 10: Initialize and Reserve Locations in Data Memory
		.data
Block1: .short	0000h, 1111h, 2222h, 3333h, 4444h, 5555h, 6666h, 7777h, 8888h, 9999h, 0AAAAh, 0BBBBh, 0CCCCh, 0DDDDh, 0EEEEh, 0FFFFh
Block2: .space	32
Block3: .byte	23h, 01h, 67h, 45h, 0ABh, 89h, 0EFh, 0CDh
Block4: .space	8
		.retain

;-------------------------------------------------------------------------------

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
