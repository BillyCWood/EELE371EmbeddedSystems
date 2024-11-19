;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;William Wood	EELE 371	February 3, 2021
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
;	Expected values for step 4:
;		Add#1 - 1110, V = 0, N = 1, Z = 0, C = 1
;
;		Add#2 - FFFE, V = 0, N = 0, Z = 0, C = 1
;
;		Add#3 - AAAA, V = 0, N = 0, Z = 0, C = 0
;
;		Add#4 - 0000, V = 0, N = 0, Z = 1, C = 1
;
;
;
;	Expected values for step 6:
;		Sub#1 - 6666, V = 0, N = 0, Z = 0, C = 1
;
;		Sub#2 - 999A, V = 0, N = 1, Z = 0, C = 0
;
;		Sub#1 - 0000, V = 0, N = 0, Z = 1, C = 0
;
;		Sub#1 - DDDE, V = 1, N = 1, Z = 0, C = 0
;
;-------------------------------------------------------------------------------


init:

	mov.w	#0000h, R4
	mov.w	#0000h, R5
	mov.w	#0000h, R6
	mov.w	#0000h, R7
	mov.w	#0000h, R8
	mov.w	#0000h, R9
	mov.w	#0000h, R10
	mov.w	#0000h, R11




main:

;Adding
	add.w	AddendA, SumAB
	add.w	AddendB, SumAB

	add.w	AddendC, SumCD
	add.w	AddendD, SumCD

	add.w	AddendE, SumEF
	add.w	AddendF, SumEF

	add.w	AddendG, SumGH
	add.w	AddendH, SumGH


;Subtracting
	mov.w	MinuendA, DiffAB
	sub.w	MinuendB, DiffAB

	mov.w	MinuendC, DiffCD
	sub.w	MinuendD, DiffCD

	mov.w	MinuendE, DiffEF
	sub.w	MinuendF, DiffEF

	mov.w	MinuendG, DiffGH
	sub.w	MinuendH, DiffGH


;Adding with long
	mov.w	#Input1, R4
	mov.w	#Input2, R5
	mov.w	#Sum12, R6
	mov.w	#Diff12, R7

;move lower byte, add, then move into Sum12 lower
	mov.w	2(R4), R8
	mov.w	2(R5), R9

	add.w	R8, R9
	mov.w	R9, 0(R6)

;move higher byte, add with carry, then move into Sum12 higher
	mov.w	0(R4), R10
	mov.w	0(R5), R11

	addc.w	R10,R11
	mov.w	R11,2(R6)


;clear registers 3 through 4
	mov.w	#0000h, R3
	mov.w	#0000h, R4
	mov.w	#0000h, R5


;clear individual bits with AND, bitmask
	mov.b	#0FFh, R4
	and.b	#11111110b, R4
	and.b	#01111111b, R4
	and.b	#11100111b, R4;clear bits 3,4


;toggle individual bits with OR, bitmask
	or.b	#00000001b, R4
	or.b	#10000000b, R4
	or.b	#00011000b, R4;toggle on bits 3,4


;toggle individual bits with XOR, bitmask
	xor.b	#00001111b, R4;toggle off bits 0->3
	xor.b	#00111100b, R4;toggle off bits 4,5 toggle on bits 2,3
	xor.b	#11110000b, R4


	jmp	main
	NOP




;---------------------------------
; Memory Allocation
;---------------------------------

		.data
		.retain

AddendA:	.short	5555h
AddendB:	.short	0BBBBh
SumAB:		.space	2

AddendC:	.short	0FFFFh
AddendD:	.short	0FFFFh
SumCD:		.space	2

AddendE:	.short	5555h
AddendF:	.short	5555h
SumEF:		.space	2

AddendG:	.short	0002h
AddendH:	.short	0FFFEh
SumGH:		.space	2

Skip:		.space 8

MinuendA:	.short	0BBBBh
MinuendB:	.short	5555h
DiffAB:		.space	2

MinuendC:	.short	5555h
MinuendD:	.short	0BBBBh
DiffCD:		.space	2

MinuendE:	.short	5555h
MinuendF:	.short	5555h
DiffEF:		.space	2

MinuendG:	.short	2222h
MinuendH:	.short	4444h
DiffGH:		.space	2

Skip2:		.space 6


Input1:		.long	55555BBBh
Input2:		.long	0BBBBB555h
Sum12:		.space	4
Diff12:		.space	4

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
            
