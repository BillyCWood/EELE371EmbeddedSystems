;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	March 10, 2023
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
	mov.w	#0000h, R8




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
	bis.b	#BIT3,	&P2IES

	bis.b	#BIT3, &P2IE;Enable local interrupt


;Port 3.4-7 as OUTPUT
	bis.b	#BIT4,	&P3DIR
	bis.b	#BIT5,	&P3DIR
	bis.b	#BIT6,	&P3DIR
	bis.b	#BIT7,	&P3DIR


	bic.b	#BIT4,	&P3OUT
	bic.b	#BIT5,	&P3OUT
	bic.b	#BIT6,	&P3OUT
	bic.b	#BIT7,	&P3OUT

	mov.b	#00000000b, &P3OUT	;Clear any 1s in P3OUT



;Configure LED1 as output
	bis.b	#BIT0,	&P1DIR
	bic.b	#BIT0,	&P1OUT

;Configure LED2 as output
	bis.b	#BIT6,	&P6DIR
	bic.b	#BIT6,	&P6OUT



;Port Interrupt Configure
	bic.b	#BIT1,	&P4IFG;Clear Interrupt Flag
	bis.b	#BIT1,	&P4IE;Assert Local Enable

	bic.b	#BIT3,	&P2IFG;Clear Interrupt Flag
	bis.b	#BIT3,	&P2IE;Assert Local Enable



	bis.w	#GIE,	SR;Assert Global Enable

	bic.w	#LOCKLPM5,	&PM5CTL0




main:

BlinkGreen:
	mov.w	#0005h, R5
	xor.b	#BIT6, &P6OUT
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

DelayOnceLoop:
	dec R4
	cmp.w	#00h, R4
	jnz DelayOnceLoop
	ret



lightDec:
	cmp.b	#00100000b, &P3OUT
	jl endifDec
	jge ifDec


ifDec:
	sub.b #00010000b, &P3OUT
	sub.b #00010000b, &P3OUT
	jmp endifDec
endifDec:
	ret
;-------------- END LIGHTDEC --------------

lightInc:
	cmp.b	#11110000b, &P3OUT
	jnz ifInc
	jz endifInc

ifInc:
	add.b #00010000b, &P3OUT

	jmp endifInc

endifInc:
	ret

;-------------- END LIGHTINC --------------


;-------------------------------------------------------------------------------
; Interrupt Service Routines
;-------------------------------------------------------------------------------
SWITCH1TRIGGERED:
	call #lightInc

	;inc R6
	cmp.b	#00001111b, R6
	jz flashRed
	jnz incRegister



;--------------
;FLASH RED LED|
;--------------
flashRed:
	mov.w	#0FFFFh, R5
	mov.w	#00h, R12
	jmp ForRedFlash

ForRedFlash:
	cmp.w #03h, R12
	jl RedDelayOn
	jge	EndForRedFlash

RedDelayOn:
	bis.b	#BIT0,	&P1OUT
	dec	R7
	jnz RedDelayOn
	inc R12
	bic.b	#BIT0,	&P1OUT
	mov.w	#0FFFFh, R7

RedDelayOff:
	dec R7
	jnz RedDelayOff
	jz ForRedFlash

EndForRedFlash:
	jmp switchEnd
;--------------
;FLASH RED LED|
;--------------



incRegister:
	add.b #00000001b, R6

switchEnd:
	bic.b	#BIT1,	&P4IFG;Clear P4IFG
	reti
;-------------- END SWITCH1TRIGGERED --------------


SWITCH2TRIGGERED:
	call #lightDec
	;dec R6
	cmp.w	#00000000b, R6
	jz flashRed2
	cmp.w	#00000001b, R6
	jz flashRed2
	jnz decRegister



;--------------
;FLASH RED LED|
;--------------
flashRed2:
	mov.w	#0FFFFh, R5
	mov.w	#00h, R12
	jmp ForRedFlash2

ForRedFlash2:
	cmp.w #03h, R12
	jl RedDelayOn2
	jge	EndForRedFlash2

RedDelayOn2:
	bis.b	#BIT0,	&P1OUT
	dec	R7
	jnz RedDelayOn2
	inc R12
	bic.b	#BIT0,	&P1OUT
	mov.w	#0FFFFh, R7

RedDelayOff2:
	dec R7
	jnz RedDelayOff2
	jz ForRedFlash2

EndForRedFlash2:
	jmp switch2End
;--------------
;FLASH RED LED|
;--------------



decRegister:
	sub.b #00000001b, R6
	sub.b #00000001b, R6
	jmp switch2End

switch2End:
	bic.b	#BIT3,	&P2IFG;Clear P2IFG
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
			.short	SWITCH2TRIGGERED
