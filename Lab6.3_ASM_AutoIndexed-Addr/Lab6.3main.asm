;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;William Wood	EELE 371	Feburary 1, 2023
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

	mov.w #0000h, R4
	mov.w #0000h, R5
	mov.w #0000h, R6
	mov.w #0000h, R7
	mov.w #0000h, R8
	mov.w #0000h, R9
	mov.w #0000h, R10
	mov.w #0000h, R11
	mov.w #0000h, R12
	mov.w #0000h, R13
	mov.w #0000h, R14
	mov.w #0000h, R15


main:

; ***DEMO 1***
	mov.w	#Const5, R7

	mov.w 	@R7+, R8
	mov.w 	@R7+, R9
	mov.w 	@R7+, R10
	mov.w	#Const0, R7
	mov.w 	@R7+, R11
	mov.w 	@R7+, R12
	mov.w 	@R7+, R13




; ***DEMO 2***
	mov.w	#Const0, R4
	mov.w	#Var0, R5

	mov.w	0(R4), 0(R5)
	mov.w	2(R4), 2(R5)
	mov.w	4(R4), 4(R5)
	mov.w	6(R4), 6(R5)


	mov.w	#0000h, 0(R5)
	mov.w	#0000h, 2(R5)
	mov.w	#0000h, 4(R5)
	mov.w	#0000h, 6(R5)


	mov.w	6(R4), 0(R5)
	mov.w	4(R4), 2(R5)
	mov.w	2(R4), 4(R5)
	mov.w	0(R4), 6(R5)


	mov.w	#0000h, 0(R5)
	mov.w	#0000h, 2(R5)
	mov.w	#0000h, 4(R5)
	mov.w	#0000h, 6(R5)






	jmp	main
	NOP


;--------------------
; Memory Allocation
;--------------------

		.data
		.retain

Const0:	.short	0DEADh
Const1:	.short	0BEEFh
Const2:	.short	0BABEh
Const3:	.short	0FACEh
Const4:	.short	0DEAFh
Const5:	.short	0FADEh
Const6:	.short	0DEEDh
Const7:	.short	0ACEDh


Var0:	.space 2
Var1:	.space 2
Var2:	.space 2
Var3:	.space 2
Var4:	.space 2
Var5:	.space 2
Var6:	.space 2
Var7:	.space 2

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
            
