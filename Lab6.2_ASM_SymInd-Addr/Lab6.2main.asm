;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
; William Wood 	EELE 371	January 30, 2023
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
	mov.w	#2000h, R5
	mov.w	#2002h, R6
	mov.w	#2004h, R7
	mov.w	#2006h, R8


                                            
main:


	mov.w	Const0,	Var0
	mov.w	Const2, Var1
	mov.w	Const4, Var2

	mov.w	Const4,	Var5
	mov.w	Const2, Var6
	mov.w	Const0, Var7


	mov.w	Const1, R4
	mov.w	PC, Var3


	mov.w	#0000h, Const0
	mov.w	#0000h, Const2
	mov.w	#0000h,	Const4


	mov.w	@R5,	R9
	mov.w	@R6,	R10
	mov.w	@R7,	R11
	mov.w	@R8,	R12


	mov.w	#Const4, R5
	mov.w	#Const5, R6
	mov.w	#Const6, R7
	mov.w	#Const7, R8



	mov.w	@R5,	R9
	mov.w	@R6,	R10
	mov.w	@R7,	R11
	mov.w	@R8,	R12




	jmp	main
	NOP





;-------------------------------------------------------------------------------
; Memory Allocation
;-------------------------------------------------------------------------------

		.data
		.retain
Const0:	.short 0DEADh
Const1:	.short 0BEEFh
Const2:	.short 0BABEh
Const3:	.short 0FACEh
Const4:	.short 0DEAFh
Const5:	.short 0FADEh
Const6:	.short 0DEEDh
Const7:	.short 0ACEDh


Var0:	.space	2
Var1:	.space	2
Var2:	.space	2
Var3:	.space	2
Var4:	.space	2
Var5:	.space	2
Var6:	.space	2
Var7:	.space	2






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
            
