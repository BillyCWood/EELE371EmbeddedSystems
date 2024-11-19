;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	February 13, 2023
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
	mov.w	#0000h,	R3
	mov.w	#0000h, R4
	mov.w	#0000h,	R5

main:

	add.w	#0FFFFh, R4 ; Add FFFFh to R4

	sub.w	#0FFFDh, R4 ; Subtract FFFdh from R4

	or.w	#1000000000000000b,	 R4 ; Toggle bit 15 of R4

	bis.w	#0000000000000100b,	 R4 ; Set bit 2 of R4

	bit.w	#0100000000000000b,	 R4 ; Test if bit is a 1

	tst.w	R4 ; Test if R4 is N or Z

	mov.w	#0000h, SR; Clear carry flag

	; divide by 4 and move into R5
	rra.w	R4
	rra.w	R4
	mov.w	R4, R5


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
            
