;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	William Wood	EELE 371	February 6, 2023
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

	mov.w	#2000h,	R4	; init R4 with 2000h
	mov.w	R4,		R5	; init R5 with contents of R4
	mov.w	#Var1,	R6  ; init R6 with Var1's address


main:

	mov.w	&2000h, R7	; contents of 2000h into R7
	mov.w	Con2, R8	; Con2 into R8
	mov.w	@R4, R9		; value of Con1 into R9

	mov.w	@R5+, R10	; Con1 into R10
	mov.w	@R5+, R11	; Con2 into R11

	mov.w	2(R4), 4(R6)	; Con2 into 3rd word of R6



	jmp	main
	NOP





;-------------------------------------------------------------------------------
; Memory Allocation
;-------------------------------------------------------------------------------

      	.data
      	.retain

Con1:	.short	0ACEDh
Con2:	.short	0BEEFh

Var1:	.space	28


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
            
