;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
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

;--	Breakpoints and Stepping

init:
	bic.w	#0001h,	PM5CTL0
	bis.b	#01h,	P1DIR
	bic.b	#01h,	P1OUT

	;mov.w	#0FFFFh,	&2002h


main:
	mov.w	&2002h, R4
	dec		R4

	mov.w	R4,R5
	mov.w	R4,R6
	mov.w	R4,R15

	mov.w	R4,&2002h

	xor.b	#01h,P1OUT

	jmp		main

;-------------------------------------------------------------------------------
; Memory Allocation
;-------------------------------------------------------------------------------
		.data			;allocate variables in data memory

Block1: .short	0000h, 1111h, 2222h, 3333h, 4444h, 5555h, 6666h, 7777h, 8888h, 9999h, 0AAAAh, 0BBBBh, 0CCCCh, 0DDDDh, 0EEEEh, 0FFFFh
Block2:	.space	32
Block3:	.byte	01h, 23h, 45h, 67h, 89h, 0ABh, 0CDh, 0EFh
Block4:	.space	8

		.retain			;keep these statements even if not used


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
            
