;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	February 15, 2023
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

	mov.b	#000h, &P5SEL0
	mov.b	#000h, &P5SEL1
	mov.b	#000h, &P5DIR

	bis.b	#00001111b,	&P5REN ; enable resistors
	bic.b	#00001111b,	&P5OUT ; set resistors as pull down

;------Set LEDs to LOW------

	; Clearing PxSEL0/1
	mov.b	#000h,	&P1SEL0
	mov.b	#000h,	&P1SEL1


	; Configuring LED1
	bis.b	#BIT0,	&P1DIR 	; Set P1.0 as an output. P1.0 = LED1
	bic.b	#BIT0,	&P1OUT


	; Clearing PxSEL0/1
	mov.b	#000h,	&P6SEL0
	mov.b	#000h,	&P6SEL1


	; Configuring LED2
	bis.b	#BIT6,	&P6DIR 	; Set P6.6 as an output. P6.6 = LED2
	bic.b	#BIT6,	&P6OUT


;------------------------------

	bic.w	#LOCKLPM5,	&PM5CTL0	; Disable Digital I/O low-power default

; DEMO 1
Main:

	mov.w	#0AAAAh, R4 ; Set R4 to AAAAh
	jmp	Add5



SubF:
	sub.w	#000Fh, R4 ; Subtract 000Fh to value in R4
	jmp ToggleAll

RotateLeft:

	rla.w	R4 ; Rotate all bits to the left without carry
	jmp	Done

ToggleAll:

	xor.w	#1111111111111111b, R4 ; Toggle all of the bits in R4
	jmp	RotateLeft

Add5:

	add.w	#0005h, R4 ; Add 0005h to value in R4
	jmp	SubF

Done:

	mov.b	&P5IN,	R5 ; Move data from P5IN to R5
	cmp.b	#00h, R5 ; Check if P5IN = 0 by checking if R5 = 0.  If R5 = 0, Z=1. Else Z=0

	;mov.b	#0Fh,	R5
	;cmp	#00h, R5 ; Check if R5 = 00.  If R5 = 00, Z=1. Else Z=0

	jz	SolidGreen
	jnz	SolidRed



;-------------------------------------------------------------------------------
; Blinky LED Subroutines DEMO 2
;-------------------------------------------------------------------------------

SolidGreen:

	; Turn on Green LED and turn off Red LED
	bis.b	#BIT6,	&P6OUT
	bic.b	#BIT0,	&P1OUT
	jmp	Done


SolidRed:

	; Turn on Red LED and turn off Green LED
	bis.b	#BIT0,	&P1OUT
	bic.b	#BIT6,	&P6OUT

	cmp.b	#04h, R5

	jge FastBlink ; jmp if >=4
	jl	SlowBlink ; jmp if <4


SlowBlink:

	bis.b	#BIT6,	&P6OUT ; Turn on Green LED
	mov.w	#0FFFFh,	R6


SlowDelayOn:
	dec	R6
	jnz SlowDelayOn
	bic.b	#BIT6,	&P6OUT ; Turn off Green LED
	mov.w	#0FFFFh, R6

SlowDelayOff:
	dec	R6
	jnz	SlowDelayOff
	jmp	Done

FastBlink:

	bis.b	#BIT6,	&P6OUT ; Turn on Green LED
	mov.w	#1111h, R6
	jmp SlowDelayOn


FastDelayOn:
	dec	R6
	tst.w	R6
	jn	ContinueOn
	jmp	FastDelayOn

ContinueOn:
	bic.b	#BIT6,	&P6OUT ; Turn off Green LED
	mov.w	#1111h, R6


FastDelayOff:
	dec	R6
	tst.w	R6
	jn	ContinueOff ; jmp if negative flag is set
	jmp FastDelayOff

ContinueOff:
	jmp Done

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
            
