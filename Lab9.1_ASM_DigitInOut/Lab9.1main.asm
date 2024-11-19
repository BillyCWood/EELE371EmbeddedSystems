;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	William Wood	EELE 371	February 13, 2023
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

; PORTS TO BE USED: 1, 2, 3, 4, 6

; Clearing Registers
	mov.b	#000h, R4
	mov.b	#000h, R5
	mov.b	#000h, R6
	mov.b	#000h, R7
	mov.b	#000h, R8
	mov.b	#000h, R9



; PINS OF MY CHOICE USING PORTS 3 AND 5

	bis.b	#BIT2,	&P3DIR 	; Set P3.2 as an output.
	bic.b	#BIT2,	&P3OUT

	bic.b	#BIT1,	&P5DIR ; Set P5.1 as an input.
	bis.b	#BIT1,	&P5REN	;enable pull up/down resistor
	bic.b	#BIT1,	&P5OUT	;make it a pull down resistor

;---------------LED2---------------

	; Clearing PxSEL0/1
	mov.b	#000h,	&P6SEL0
	mov.b	#000h,	&P6SEL1


	; Configuring LED2
	bis.b	#BIT6,	&P6DIR 	; Set P6.6 as an output. P6.6 = LED2
	bic.b	#BIT6,	&P6OUT




;---------------LED1---------------

	; Clearing PxSEL0/1
	mov.b	#000h,	&P1SEL0
	mov.b	#000h,	&P1SEL1


	; Configuring LED1
	bis.b	#BIT0,	&P1DIR 	; Set P1.0 as an output. P1.0 = LED1
	bic.b	#BIT0,	&P1OUT


;---------------S1---------------
; S1 == P4.1

	; Clearing PxSEL0/1
	mov.b	#000h,	&P4SEL0
	mov.b	#000h,	&P4SEL1

	; Set S1 as input
	bic.b	#BIT1,	&P4DIR
	bis.b	#BIT1,	&P4REN	;enable pull up/down resistor
	bis.b	#BIT1,	&P4OUT	;make it a pull up resistor

;---------------S2---------------
; S2 == P2.3

	; Clearing PxSEL0/1
	mov.b	#000h,	&P2SEL0
	mov.b	#000h,	&P2SEL1

	; Set S2 as input
	bic.b	#BIT3,	&P2DIR
	bis.b	#BIT3,	&P2REN
	bis.b	#BIT3,	&P2OUT




	bic.w	#LOCKLPM5,	&PM5CTL0	; Disable Digital I/O low-power default



main:

	; Turn external LED on
	;bis.b	#BIT2, &P3OUT




	; Turn on and off Green LED
	bis.b	#BIT6,	&P6OUT
	bic.b	#BIT6,	&P6OUT

	; Turn of and off Red LED
	bis.b	#BIT0,	&P1OUT
	bic.b	#BIT0,	&P1OUT


	mov.b	&P4IN,	R4 ; Result of S1
	mov.b	&P2IN,	R5 ; Result of S2
	mov.b	&P5IN,	R6 ; RESULT OF 3RD INPUT

	mov.b	&P4IN,	R4 ; Result of S1
	mov.b	&P2IN,	R5 ; Result of S2
	mov.b	&P5IN,	R6 ; RESULT OF 3RD INPUT

	mov.b	&P4IN,	R4 ; Result of S1
	mov.b	&P2IN,	R5 ; Result of S2
	mov.b	&P5IN,	R6 ; RESULT OF 3RD INPUT

	mov.b	&P4IN,	R4 ; Result of S1
	mov.b	&P2IN,	R5 ; Result of S2
	mov.b	&P5IN,	R6 ; RESULT OF 3RD INPUT


	; Turn external LED off
	bic.b	#BIT2, &P3OUT

	jmp	main
	NOP




                                            

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
            
