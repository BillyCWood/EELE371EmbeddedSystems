;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	March 8, 2023
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
init:
	mov.w	#0000h, R4
	mov.w	#0000h, R5
	mov.w	#0000h, R6

;SW1
	mov.b	#000h,	&P4SEL0
	mov.b	#000h,	&P4SEL1

	bic.b	#BIT1,	&P4DIR;set as input
	bis.b	#BIT1,	&P4REN;enable resistor
	bis.b	#BIT1,	&P4OUT;make pull-down
	bis.b	#BIT1,	&P4IES

	bis.b	#BIT1, &P4IE;Enable local interrupt


;SW2
	mov.b	#000h,	&P2SEL0
	mov.b	#000h,	&P2SEL1

	bic.b	#BIT3,	&P2DIR;set as input
	bis.b	#BIT3,	&P2REN;enable resistor
	bis.b	#BIT3,	&P2OUT;make pull-down
	bic.b	#BIT3,	&P2IES

	bis.b	#BIT3, &P2IE;Enable local interrupt


;Configure LED1 as output
	bis.b	#BIT0,	&P1DIR
	bic.b	#BIT0,	&P1OUT

;Configure LED2 as output
	bis.b	#BIT6,	&P6DIR
	bic.b	#BIT6,	&P6OUT





	bic.b	#BIT1,	&P4IFG;Clear Interrupt Flag
	bis.b	#BIT1,	&P4IE;Assert Local Enable

	bic.b	#BIT3,	&P2IFG;Clear Interrupt Flag
	bis.b	#BIT3,	&P2IE;Assert Local Enable

	NOP
	bis.w	#GIE,	SR;Assert Global Enable
	NOP

	bic.w	#LOCKLPM5,	&PM5CTL0




main:

BlinkRed:
	mov.w	#0005h, R5
	xor.b	#BIT0, &P1OUT
LongDelay:
	call	#DelayOnce
	dec R5
	cmp.w #00h, R5
	jnz LongDelay
;-------------- END BlinkRed --------------

	jmp main
;-------------- END MAIN --------------

DelayOnce:
	mov.w	#0FFFFh, R4
	call	#DelayOnceLoop

DelayOnceLoop:
	dec R4
	cmp.w	#00h, R4
	jnz DelayOnceLoop
	ret






;-------------------------------------------------------------------------------
; Interrupt Service Routines
;-------------------------------------------------------------------------------
SWITCH1TRIGGERED:
	mov.w 	R5, R7
	mov.w	#0ABCDh,	R5
 	xor.b	#BIT6, &P6OUT;Toggle LED2
 	bic.b	#BIT1,	&P4IFG;Clear P4IFG
 	mov.w	R7, R5
 	reti
;-------------- END SWITCH1TRIGGERED --------------


SWITCH2RELEASED:
	mov.w 	R5, R7
	bic.b	#BIT6, &P6OUT
;Flash LED2
	mov.w	#0003h, R5
	mov.w	R4, R8

LongGreenDelay:
	bis.b	#BIT6, &P6OUT
	call	#DelayGreenOnce
	dec R5
	cmp.w #00h, R5
	jnz LongGreenDelay
	jz endISR

DelayGreenOnce:
	mov.w	#0BBBBh, R4
	call	#DelayGreenOnceLoop

DelayGreenOnceLoop:
	dec R4
	cmp.w	#00h, R4
	jnz DelayGreenOnceLoop
	bic.b	#BIT6, &P6OUT
	ret



endISR:
 	bic.b	#BIT3,	&P2IFG;Clear P2IFG
 	mov.w 	R7, R5
 	mov.w	R8, R4
 	reti
;-------------- END SWITCH2RELEASED --------------



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
            
            .sect	".int22"				;Port 4 interrupt
			.short	SWITCH1TRIGGERED

			.sect	".int24"				;Port 2 interrupt
			.short	SWITCH2RELEASED

