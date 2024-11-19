;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;William Wood	EELE 371	February 6, 2023
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

	mov.w	#0000h,	R4
	mov.w	#0FFFFh,R5
	mov.w	#0F0F0h,R6
	mov.w	#0BEEFh,R7
	mov.w	#0DEEDh,R8
	mov.w	#0ECEh,	R9
	mov.w	#0000h,	R10
	mov.w	#1000h,	R11

main:

	;Set
	bis.w	#0000100000001000b,	R4 ; bits 3 and 11
	bis.w	#0000000000000011b,	R4 ; bits 0 and 1

	;Clear
	bic.w	#0000010000100000b,	R5 ; bits 5 and 10
	bic.w	#1000000000000001b,	R5 ; bits 0 and 15



	;TESTS
	bit.w	#0000000000000001b,	R6 ; Check R6.0
	bit.w	#1000000000000000b,	R6 ; Check R6.15
	bit.w	#0000000000001111b,	R6 ; Check R6.0:3
	bit.w	#1111000000000000b,	R6 ; Check R6.12:15


	;Z==0 if equal
	cmp.w	#0DEEDh, R7
	cmp.w	#0DEEDh, R8
	cmp.w	#0DEEDh, R9


	tst.w	R7
	tst.w	R10
	tst.w	R8
	tst.w	R9



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
            
