;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;	Billy Wood	EELE 371	March 3, 2023
;
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


;-----
;INIT|
;-----
init:


    mov.w	#00ABh,	R4;L/R indicator
	mov.w	#0000h, R5
	mov.w	#2000h,	R6;Material Type Address
	mov.w	#0000h,	R7;Delay Counter
	mov.w	#0000h,	R8;Delay Counter
	mov.w	#0AAAAh, R9;Material Type Display
	mov.w	#0000h,	R10;Belt Counter
	mov.w	#0000h,	R11;Total Scoop Count
	mov.w	#0000h, R12

	mov.w	#0000h,	&2020h

;--------
;INPUTS |
;--------


;----------
;SWITCHES |
;----------


;SW1
	mov.b	#000h,	&P4SEL0
	mov.b	#000h,	&P4SEL1

	bic.b	#BIT1,	&P4DIR;set as input
	bis.b	#BIT1,	&P4REN;enable resistor
	bis.b	#BIT1,	&P4OUT;make pull-down


;SW2
	mov.b	#000h,	&P2SEL0
	mov.b	#000h,	&P2SEL1

	bic.b	#BIT3,	&P2DIR;set as input
	bis.b	#BIT3,	&P2REN;enable resistor
	bis.b	#BIT3,	&P2OUT;make pull-down


;-------------
;INPUT NIBBLE|
;-------------

;Cofigure Port 6.0-3 as input
	mov.b	#000h,	&P6SEL0
	mov.b	#000h,	&P6SEL1

	bic.b	#BIT0,	&P6DIR
	bic.b	#BIT1,	&P6DIR
	bic.b	#BIT2,	&P6DIR
	bic.b	#BIT3,	&P6DIR


;----------------------------------


;Configuring P3.5 as INPUT
	mov.b	#000h, &P3SEL0
	mov.b	#000h, &P3SEL1
	mov.b	#000h, &P3DIR

	bis.b	#00100000b,	&P3REN ; enable resistors
	bic.b	#00100000b,	&P3OUT ; set resistors as pull down


;Configuring P3.6 as INPUT
	mov.b	#000h, &P3SEL0
	mov.b	#000h, &P3SEL1
	mov.b	#000h, &P3DIR

	bis.b	#01000000b,	&P3REN ; enable resistors
	bic.b	#01000000b,	&P3OUT ; set resistors as pull down


;Configuring P3.7 as INPUT
	mov.b	#000h, &P3SEL0
	mov.b	#000h, &P3SEL1
	mov.b	#000h, &P3DIR

	bis.b	#10000000b,	&P3REN ; enable resistors
	bic.b	#10000000b,	&P3OUT ; set resistors as pull down


;Configuring P6.4 as INPUT
	mov.b	#000h, &P6SEL0
	mov.b	#000h, &P6SEL1
	mov.b	#000h, &P6DIR

	bis.b	#00010000b,	&P6REN ; enable resistors
	bic.b	#00010000b,	&P6OUT ; set resistors as pull down


;---------
;OUTPUTS |
;---------

	;Configuring P5.3 as OUTPUT
	bis.b	#BIT3,	&P5DIR 	; Set P5.3 as an output.
	bic.b	#BIT3,	&P5OUT
	mov.b	#00000000b, &P5OUT	;Clear any 1s in P5OUT


;--------------
;OUTPUT NIBBLE|
;--------------

;Configure Port 1.4-7 as output
	mov.b	#000h,	&P2SEL0
	mov.b	#000h,	&P2SEL1

	bis.b	#BIT4,	&P1DIR
	bic.b	#BIT4,	&P1OUT

	bis.b	#BIT5,	&P1DIR
	bic.b	#BIT5,	&P1OUT

	bis.b	#BIT6,	&P1DIR
	bic.b	#BIT6,	&P1OUT

	bis.b	#BIT7,	&P1DIR
	bic.b	#BIT7,	&P1OUT


;-----
;LEDs|
;-----

;Configure LED1 as output
	bis.b	#BIT0,	&P1DIR
	bic.b	#BIT0,	&P1OUT

;Configure LED2 as output
	bis.b	#BIT6,	&P6DIR
	bic.b	#BIT6,	&P6OUT
;----------------------------------

	bic.w	#LOCKLPM5,	&PM5CTL0	; Disable Digital I/O low-power default

;----------------------------------



;-----
;MAIN|
;-----
main:
	cmp.b	#00000000b, &P6IN
	jz While

	cmp.b	#00000001b, &P6IN
	jz moveBeltPrep

	cmp.b	#00000011b, &P6IN
	jz resetBeltPrep

	cmp.b	#00000111b, &P6IN
	jz saveTotalScoopCount

	cmp.b	#00001111b, &P6IN
	jz displayData

	jmp main



;-----------------------------
;GET INSTRUCTIONS LOOP - 0000|
;-----------------------------
While:
;#00000100b,	&P4IN
;#00000000b,	&P2IN

	cmp.b	#00000000b, &P6IN
	jnz EndWhile
	cmp.b	#00000100b,	&P4IN
	jz checkIfNine
	cmp.b	#00001100b,	&P4IN
	jz checkIfNine
	cmp.b	#00000000b,	&P2IN
	jz flashLEDs
	jnz While

EndWhile:
	jmp main



;--------------------------
;MOVE CONVEYOR BELT - 0001|
;--------------------------
moveBeltPrep:
	mov.b	#04h, R10
	mov.w	#0FFFFFFFh, R12
	bis.b	#00001110b, &P1OUT
	jmp moveBeltDelay1

;DELAY------------------------------------
moveBeltDelay1:
	dec	R12
	jnz moveBeltDelay1
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay2

moveBeltDelay2:
	dec	R12
	jnz moveBeltDelay2
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay3

moveBeltDelay3:
	dec	R12
	jnz moveBeltDelay3
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay4

moveBeltDelay4:
	dec	R12
	jnz moveBeltDelay4
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay5

moveBeltDelay5:
	dec	R12
	jnz moveBeltDelay5
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay6

moveBeltDelay6:
	dec	R12
	jnz moveBeltDelay6
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay7

moveBeltDelay7:
	dec	R12
	jnz moveBeltDelay7
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay8

moveBeltDelay8:
	dec	R12
	jnz moveBeltDelay8
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay9

moveBeltDelay9:
	dec	R12
	jnz moveBeltDelay9
	mov.w	#0FFFFFFFh, R12
	jz moveBeltDelay10

moveBeltDelay10:
	dec	R12
	jnz moveBeltDelay10
	mov.w	#0FFFFFFFh, R12
	jz moveBelt
;--------------------------------------------

moveBelt:
	cmp.b	#0000b, R10
	jz moveBeltEnd
	dec R10
	rla.b	&P1OUT
	bis.b	#BIT4, &P1OUT
	mov.w	#0FFFFFFFh, R12
	jmp moveBeltDelay1




moveBeltEnd:
	bic.b	#BIT4, &P1OUT
	bic.b	#BIT5, &P1OUT
	bic.b	#BIT6, &P1OUT
	bic.b	#BIT7, &P1OUT
	jmp main

;---------------------------
;RESET CONVEYOR BELT - 0011|
;---------------------------
resetBeltPrep:
	mov.b	#03h, R10
	bis.b	#BIT7, &P1OUT
	mov.w	#0FFFFFFFh, R12
	jmp resetBeltDelay1

;DELAY------------------------------------
resetBeltDelay1:
	dec	R12
	jnz resetBeltDelay1
	mov.w	#0FFFFFFFh, R12
	jz resetBeltDelay2

resetBeltDelay2:
	dec	R12
	jnz resetBeltDelay2
	mov.w	#0FFFFFFFh, R12
	jz resetBeltDelay3

resetBeltDelay3:
	dec	R12
	jnz resetBeltDelay3
	mov.w	#0FFFFFFFh, R12
	jz resetBeltDelay4

resetBeltDelay4:
	dec	R12
	jnz resetBeltDelay4
	mov.w	#0FFFFFFFh, R12
	jz resetBeltDelay5

resetBeltDelay5:
	dec	R12
	jnz resetBeltDelay5
	mov.w	#0FFFFFFFh, R12
	jz resetBelt
;--------------------------------------------


resetBelt:
	cmp.b	#0000b, R10
	jz resetBeltEnd
	dec R10
	rra.b	&P1OUT
	mov.w	#0FFFFFFFh, R12
	jmp resetBeltDelay1

resetBeltEnd:
	bic.b	#BIT0, &P1OUT
	bic.b	#BIT4, &P1OUT
	bic.b	#BIT5, &P1OUT
	bic.b	#BIT6, &P1OUT
	bic.b	#BIT7, &P1OUT

	xor.w #1010101110101011b, R4 ;0ABABh is the hex equivalent of the mask provided

	jmp main



;------------------------------
;SAVE TOTAL SCOOP COUNT - 0111|
;------------------------------
saveTotalScoopCount:
	add.w	&2020h, R11
	mov.w	R11, &2020h
	mov.w	#0000h, R11
	jmp main


;------------------------
;DISPLAY THE DATA - 1111|
;------------------------
displayData:
	cmp.b	#00001111b, &P6IN
	jz If
	jnz main
If:
	cmp.b	#00000000b, &P3IN
	jnz ElseIf1
	mov.w	0(R6), R9
	jmp EndIf
ElseIf1:
	cmp.b	#00100000b, &P3IN
	jnz ElseIf2
	mov.w	2(R6), R9
	jmp EndIf
ElseIf2:
	cmp.b	#01000000b, &P3IN
	jnz ElseIf3
	mov.w	4(R6), R9
	jmp EndIf
ElseIf3:
	cmp.b	#01100000b, &P3IN
	jnz ElseIf4
	mov.w	6(R6), R9
	jmp EndIf
ElseIf4:
	cmp.b	#10000000b, &P3IN
	jnz ElseIf5
	mov.w	8(R6), R9
	jmp EndIf
ElseIf5:
	cmp.b	#10100000b, &P3IN
	jnz ElseIf6
	mov.w	10(R6), R9
	jmp EndIf
ElseIf6:
	cmp.b	#11000000b, &P3IN
	jnz ElseIf7
	mov.w	12(R6), R9
	jmp EndIf
ElseIf7:
	cmp.b	#11100000b, &P3IN
	jnz EndIf
	mov.w	14(R6), R9
	jmp EndIf

EndIf:
	jmp displayData




;--------------------
;TOTAL SCOOP COUNTER|
;--------------------
checkIfNine:
	cmp.w	#09h,	R5
	jge flashRed
	jl incTotalScoopCounter

incTotalScoopCounter:
	inc R5
	mov.w	#0FFFFh, R12
	jmp incrementDelayOn

incrementDelayOn:
	dec	R12
	jnz incrementDelayOn
	mov.w	#0FFFFh, R12
	jmp incrementDelayOff

incrementDelayOff:
	dec R12
	jnz incrementDelayOff
	jz While


;---------------------
flashLEDs:
	cmp.w #01h,	R5
	mov.w	#0000h,	R10

	jge	countScoopsBlink
	jl	flashRed

;--------------
;FLASH RED LED|
;--------------
flashRed:
	mov.w	#0FFFFh, R7
	mov.w	#00h, R12
	jmp ForRedFlash

ForRedFlash:
	cmp.w #03h, R12
	jl RedDelayOn
	jge	EndForRedFlash

RedDelayOn:
	bis.b	#BIT0,	&P1OUT
	dec	R7
	jnz RedDelayOn
	inc R12
	bic.b	#BIT0,	&P1OUT
	mov.w	#0FFFFh, R7

RedDelayOff:
	dec R7
	jnz RedDelayOff
	jz ForRedFlash

EndForRedFlash:
	jmp While

;----------------
;FLASH GREEN LED|
;----------------

countScoopsBlink:
	mov.w	R5, R11
	mov.w	#00h, R10
	mov.w	#0FFFFh, R8
	jmp ForGreenFlash

ForGreenFlash:
	cmp.w R11, R10
	jl GreenDelayOn
	jge	EndForGreenFlash

GreenDelayOn:
	bis.b	#BIT6 ,	&P6OUT
	dec	R7
	jnz GreenDelayOn
	inc R10
	bic.b	#BIT6,	&P6OUT
	mov.w	#0FFFFh, R8

GreenDelayOff:
	dec R7
	jnz GreenDelayOff
	jz ForGreenFlash

EndForGreenFlash:
	mov.w	#0000h, R5
	jmp main
	NOP



;-------------------------------------------------------------------------------
; Memory Allocation
;-------------------------------------------------------------------------------

		.data
		.retain
Const0:	.short 0ACEDh
Const1:	.short 0BACEh
Const2:	.short 0BEEFh
Const3:	.short 0CAFEh
Const4:	.short 0DEAFh
Const5:	.short 0DEEDh
Const6:	.short 0FACEh
Const7:	.short 0FADEh

Const8:		.short 0808h
Const9:		.short 9090h
Const10:	.short 0A00Ah
Const11:	.short 0BB0h
Const12:	.short 0CC00h
Const13:	.short 00DDh
Const14:	.short 0EEEEh
Const15:	.short 0FFFFh


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
            
