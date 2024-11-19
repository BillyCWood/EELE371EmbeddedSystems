;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	February 22, 2023
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
	mov.w	#00000000b, &P4IN
	mov.w	#0000h, R4 ; Clear R4

;----LED 1----
	bis.b	#BIT0,	&P1DIR 	; Set P1.0 as an output. P1.0 = LED1
	bic.b	#BIT0,	&P1OUT


;----LED 2----
	bis.b	#BIT6,	&P6DIR 	; Set P6.6 as an output. P6.6 = LED2
	bic.b	#BIT6,	&P6OUT


;-----S1-----
; S1 == P4.1

	; Clearing PxSEL0/1
	mov.b	#000h,	&P4SEL0
	mov.b	#000h,	&P4SEL1

	; Set S1 as input
	bic.b	#BIT1,	&P4DIR
	bis.b	#BIT1,	&P4REN	;enable pull up/down resistor
	bis.b	#BIT1,	&P4OUT	;make it a pull up resistor

;-----S2-----
; S2 == P2.3

	; Clearing PxSEL0/1
	mov.b	#000h,	&P2SEL0
	mov.b	#000h,	&P2SEL1

	; Set S2 as input
	bic.b	#BIT3,	&P2DIR
	bis.b	#BIT3,	&P2REN
	bis.b	#BIT3,	&P2OUT



	; Disable Digital I/O low-power default
	bic.w	#LOCKLPM5,	&PM5CTL0


main:

	bis.b	#BIT0,	&P1OUT

While:

	cmp.b	#0100b,	&P4IN ; Check if S1 is reading LOW or HIGH
	jnz	While ; Repeat while loop if Z flag is NOT set
	mov.w	#1111h, R4
	jz EndWhile ; Jump to EndWhile if Z flag is set




EndWhile:
	bic.b	#BIT0,	&P1OUT
	dec R4
	jnz EndWhile
	jmp If ; Go to the If statement



If:

	cmp.b	#00h,	&P2IN ; Check if S2 is reading LOW or HIGH
 	jz	IfPressed ; Jump to IfPressed if S2 is pressed
 	mov.w	#0FFFFh, R4
	jmp EndIf ; Jump to EndIf

IfPressed:
	xor.b	#BIT6,	&P6OUT
	mov.w	#0FFFFh, R4
	jmp EndIf


EndIf:
	dec R4
	jnz EndIf
	jmp main ; Return to main
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
            
