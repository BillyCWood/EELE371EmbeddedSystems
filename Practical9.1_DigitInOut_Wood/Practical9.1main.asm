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

	;Configuring P5.3 as OUTPUT
	bis.b	#BIT3,	&P5DIR 	; Set P5.3 as an output.
	bic.b	#BIT3,	&P5OUT

	;Configuring P3.7 as INPUT
	mov.b	#000h, &P3SEL0
	mov.b	#000h, &P3SEL1
	mov.b	#000h, &P3DIR

	bis.b	#10000000b,	&P3REN ; enable resistors
	bic.b	#10000000b,	&P3OUT ; set resistors as pull down

	mov.b	#00h,	R5
	mov.b	#00h,	R6

	bic.w	#LOCKLPM5,	&PM5CTL0	; Disable Digital I/O low-power default

main:

	bis.b	#BIT3, &P5OUT
	mov.b	&P3IN,	R5
	bic.b	#BIT3, &P5OUT
	mov.b	&P3IN,	R6

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
            
