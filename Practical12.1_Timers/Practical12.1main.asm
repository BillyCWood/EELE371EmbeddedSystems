;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	March 29, 2023
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

;	LEDs
	bis.b	#BIT0,	&P1DIR
	bic.b	#BIT0,	&P1OUT

	bis.b	#BIT6,	&P6DIR
	bis.b	#BIT6,	&P6OUT

	bic.w	#LOCKLPM5,	&PM5CTL0


;	TimerB0
	bis.w	#TBCLR,	&TB0CTL
	bis.w	#TBSSEL__SMCLK,	&TB0CTL
	bis.w	#MC__UP,	&TB0CTL

	mov.w	#12500,	&TB0CCR0
	bis.w	#ID__4,	&TB0CTL
	bis.w	#TBIDEX__5,	&TB0EX0
	bis.w	#CCIE,	&TB0CCTL0			;Enable Overflow Interrupt	(TBIE = 1)
	bic.w	#CCIFG, &TB0CCTL0			;Clear Interrupt Flag		(TBIFG = 0)

;	TimerB1
	bis.w	#TBCLR,	&TB1CTL
	bis.w	#TBSSEL__ACLK,	&TB1CTL
	bis.w	#MC__CONTINUOUS,	&TB1CTL
	bis.w	#CNTL_1,	&TB1CTL
	bis.w	#ID__2,	&TB1CTL
	bis.w	#TBIDEX__8,	&TB1EX0
	bis.w	#TBIE,	&TB1CTL			;Enable Overflow Interrupt	(TBIE = 1)
	bic.w	#TBIFG, &TB1CTL			;Clear Interrupt Flag		(TBIFG = 0)

	NOP
	bis.w	#GIE,	SR
	NOP

main:
	jmp	main
                                            




;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
TimerB0_250ms:
	xor.b	#BIT0,	&P1OUT
	bic.w	#CCIFG,	&TB0CCTL0
	reti

TimerB1_2s:
	xor.b	#BIT6,	&P6OUT
	bic.w	#TBIFG,	&TB1CTL
	reti



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
            
            .sect	".int43"
            .short	TimerB0_250ms

            .sect	".int40"
            .short	TimerB1_2s

