;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	William Wood	EELE 371	February 8, 2023
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
	mov.w	#0000h,	R12


main:

	rla	R11
	rla R11
	rla R11
	rla	R11

	rrc	R11	; Rotate Carry-bit into MSB

	rra	R11
	rra	R11
	rra	R11

	rla	R11

	; Rotate Carry-bit into LSB
	rlc	R11
	rlc	R11
	rlc	R11
	rlc	R11

	; Rotate Carry-bit into MSB
	rrc	R11
	rrc	R11
	rrc	R11
	rrc	R11
	rrc	R11



	add.w	#8d,	R12
	add.w	#50d,	R12
	add.w	#78d,	R12
	add.w	#40d,	R12

	rra	R12
	rra R12

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
            
