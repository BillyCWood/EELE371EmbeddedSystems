;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	February 17, 2023
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

	; Configuring LED1
	bis.b	#BIT0,	&P1DIR 	; Set P1.0 as an output. P1.0 = LED1
	bic.b	#BIT0,	&P1OUT

	; Configuring LED2
	bis.b	#BIT6,	&P6DIR 	; Set P6.6 as an output. P6.6 = LED2
	bic.b	#BIT6,	&P6OUT


	; Configuring Port 5
	mov.b	#000h, &P5SEL0
	mov.b	#000h, &P5SEL1
	mov.b	#000h, &P5DIR

	bis.b	#00001111b,	&P5REN ; enable resistors
	bic.b	#00001111b,	&P5OUT ; set resistors as pull down


	bic.w	#LOCKLPM5,	&PM5CTL0	; Disable Digital I/O low-power default


main:
	bis.b	#BIT0, &P1OUT
	mov.w	#0FFFFh, R4
	mov.b	#05h, R5

; DEMO 1
;MainDelayOn:
;	dec	R4
;	jnz	MainDelayOn ;Jump back to MainDelayOn if the Z flag is not set
;	bic.b	#BIT0,	&P1OUT
;	mov.w	#0FFFFh,	R4
;
;MainDelayOff:
;	dec R4
;	jnz	MainDelayOff
;
;
;While:
;
;	cmp.b	#0001b,	&P5IN ;Compare P5IN == 0001
;	jnz	EndWhile
;
;	bis.b	#BIT6, &P6OUT
;
;
;
;WhileDelayOn:
;	dec	R4
;	jnz	WhileDelayOn
;	bic.b	#BIT6,	&P6OUT
;	mov.w	#0FFFFh,	R4
;
;WhileDelayOff:
;	dec R4
;	jnz	WhileDelayOff
;	jz	While
;
;
;
;EndWhile:
;	mov.b #10000000, &P5OUT
;	jmp	main
;	NOP
                                            

; DEMO 2
;
;For:
;	bis.b	#BIT6, &P6OUT
;ForDelayOn:
;	dec	R4
;	jnz	ForDelayOn
;	bic.b	#BIT6,	&P6OUT
;	mov.w	#0FFFFh,	R4

;ForDelayOff:
;	dec R4
;	jnz	ForDelayOff ;Jump back to ForDelayOff if Z flag is NOT set
;	dec	R5
;	mov.w	#0FFFFh,	R4
;	cmp.b	#00h,	R5 ;Check if R5 == 0. Set Z flag if equal
;	jz EndFor ; End the For loop when R5 == 0
;	jnz	For ; if R5 != 0 Return to beginning of For loop
;
;EndFor:
;	jmp main ; Return to main unconditionally
;	NOP


;DEMO 3




If:;Flash Red
	cmp.b	#00000001b, &P5IN
	jnz	ElseIf1
	bis.b	#BIT0, &P1OUT
	bic.b	#BIT6, &P6OUT
	mov.w	#0FFFFh,	R4

IfDelayOn:
	dec	R4
	jnz	IfDelayOn
	bic.b	#BIT0,	&P1OUT
	mov.w	#0FFFFh,	R4

IfDelayOff:
	dec R4
	jnz	IfDelayOff ;Jump back to ForDelayOff if Z flag is NOT set
	mov.w	#0FFFFh,	R4
	jz EndIf ; End the For loop when R5 == 0



	jmp EndIf

ElseIf1:;Flash Green
	cmp.b	#00000010b, &P5IN
	jnz	ElseIf2
	bic.b	#BIT0, &P1OUT
	bis.b	#BIT6, &P6OUT
	mov.w	#0FFFFh,	R4

IfE1DelayOn:
	dec	R4
	jnz	IfE1DelayOn
	bic.b	#BIT6,	&P6OUT
	mov.w	#0FFFFh,	R4

IfE1DelayOff:
	dec R4
	jnz	IfE1DelayOff ;Jump back to ForDelayOff if Z flag is NOT set
	mov.w	#0FFFFh,	R4
	jz EndIf ; End the For loop when R5 == 0


	jmp EndIf

ElseIf2:; Flash Both
	cmp.b	#00000100b, &P5IN
	jnz	Else
	bis.b	#BIT0, &P1OUT
	bis.b	#BIT6, &P6OUT
	mov.w	#0FFFFh,	R4

IfE2DelayOn:
	dec	R4
	jnz	IfE2DelayOn
	bic.b	#BIT0,	&P1OUT
	bic.b	#BIT6, &P6OUT
	mov.w	#0FFFFh,	R4

IfE2DelayOff:
	dec R4
	jnz	IfE2DelayOff ;Jump back to ForDelayOff if Z flag is NOT set
	mov.w	#0FFFFh,	R4
	jz EndIf ; End the For loop when R5 == 0


	jmp EndIf

Else:
	bis.b	#BIT6, &P6OUT
	bis.b	#BIT0, &P1OUT
	jmp EndIf


EndIf:
	jmp main
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
            
