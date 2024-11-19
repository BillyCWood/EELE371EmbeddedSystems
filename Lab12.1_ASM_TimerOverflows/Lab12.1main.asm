;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	March 20, 2023
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

;Configure LED1 as output
	bis.b	#BIT0,	&P1DIR
	bic.b	#BIT0,	&P1OUT

;Configure LED2 as output
	bis.b	#BIT6,	&P6DIR
	bic.b	#BIT6,	&P6OUT



;Timer B0
	bis.w	#TBCLR, &TB0CTL 		;Clear Timer and Dividers 	(TBCLR = 1)
	bis.w	#TBSSEL__ACLK, &TB0CTL	;Select ACLK as Timer Source(TBSSEL = 01)
	bis.w	#MC__CONTINUOUS, &TB0CTL;Choose Continuous Counting	(MC = 10)
	bis.w	#CNTL_3, &TB0CTL		;Choose 8-bit Counter Length(CNTL = 11)


;Timer B1
	bis.w	#TBCLR, &TB1CTL 		;Clear Timer and Dividers 	(TBCLR = 1)
	bis.w	#TBSSEL__ACLK, &TB1CTL	;Select ACLK as Timer Source(TBSSEL = 01)
	bis.w	#MC__CONTINUOUS, &TB1CTL;Choose Continuous Counting	(MC = 10)
	bis.w	#CNTL_0, &TB1CTL		;Choose 16-bit Counter Length(CNTL = 00)
	bis.w	#ID__2, &TB1CTL			;Set Div-by-2 in the First Divider(ID = 01)
	;bis.w	#TBIE,	&TB1CTL			;Enable Overflow Interrupt	(TBIE = 1)
	;bic.w	#TBIFG, &TB1CTL			;Clear Interrupt Flag		(TBIFG = 0)


	bic.b	#TB0IE, &TB0CTL;Enable Overflow Interrupt
	bic.b	#TB0IFG, &TB0CTL;Clear Interrupt Flag

	bic.b	#TB1IE, &TB1CTL
	bic.b	#TB1IFG, &TB1CTL


	bis.w	#GIE SR



	bic.b	#LOCKLPM5,	&PM5CTL0


main:
	jmp	main


;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
TimerB0_1s:
	xor.b	#BIT0,	&P1OUT
	bic.w	#TBIFG,	&TB0CTL
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
            
            .sect	".int42"
            .short	TimerB0_1s

            .sect	".int41"
            .short	TimerB1_2s
