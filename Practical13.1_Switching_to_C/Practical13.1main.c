/**-------------------------------------------------------------------------------
 * MSP430 C Code
 *
 *  Billy Wood
 *  EELE 371
 *  March 31, 2023
 *  Practical 13.1
 */


#include <msp430.h> 


/**
 * main.c
 */
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	// LEDs
	P1DIR |= BIT0;
	P1OUT &= ~BIT0;

	P6DIR |= BIT6;
	P6OUT &= ~BIT6;

	//Switch 1
	P4DIR &= ~BIT1;
	P4REN |= BIT1;
	P4OUT |= BIT1;

	//-- INTERRUPTS
	P4IFG &= ~BIT1;
	P4IES |= BIT1;
	P4IE |= BIT1;
	__enable_interrupt();


	//-- Turn off GPIO
	PM5CTL0 &= ~LOCKLPM5;

	while(1){}

	return 0;
}



/*------------------------------------
 * INTERRUPT SERVICE ROUTINES
 *------------------------------------*/

#pragma vector = PORT4_VECTOR
__interrupt void ISR_PORT4_SW1(void){

	P1OUT ^= BIT0;
	P6OUT ^= BIT6;

	P4IFG &= ~BIT1;
}

//---- END ISR_PORT4_S1----
