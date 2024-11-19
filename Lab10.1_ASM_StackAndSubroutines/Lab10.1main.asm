;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	March 6, 2023
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

	mov.w	#0000h, R4
	mov.w	#2000h, R5
	mov.w	#0000h, R6
	mov.w	#0000h, R7
	mov.w	#0000h, R8


main:
	mov.w	#0000h, R4
PushLoop:
	cmp.w #0016d, R4
	jge EndPushLoop
	inc R4
	mov.w	@R5+, R6;Move into R6 the info stored at this location
	push R6
	jmp PushLoop

EndPushLoop:
	mov.w	#0000h, R4
	mov.w	#2000h, R5
	mov.w	#0000h, R6
	jmp PopLoop

PopLoop:
	cmp.w #0016d, R4
	jge EndPopLoop
	inc R4



	mov.w	R5, R6;move the location into R6
	inc R5;increment R5
	inc R5;increment R5
	pop R7;pop value into R7
	call	#Add3
	mov.w R7, 0(R6);move that value to this location





	jmp PopLoop

EndPopLoop:
	mov.w	#0000h, R4
	mov.w	#2000h, R5
	mov.w	#0000h, R6
	jmp main
	NOP

;-------------------------------------------------------------------------------
; Subroutines
;-------------------------------------------------------------------------------
Add3:
	add.w	#0003h, R7
	ret



;-------------------------------------------------------------------------------
; Memory Allocation
;-------------------------------------------------------------------------------
		.data
		.retain

DataBlock:		.short 0000h, 1111h, 2222h, 3333h, 4444h, 5555h, 6666h, 7777h, 8888h, 9999h, 0AAAAh, 0BBBBh, 0CCCCh, 0DDDDh, 0EEEEh, 0FFFFh
ReserveBlock: 	.space 32
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
            
