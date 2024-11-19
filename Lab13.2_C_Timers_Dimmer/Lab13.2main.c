/**
 * Billy Wood
 *
 * EELE 371
 *
 * March 27, 2023
 *
 * Lab 13.2
 */


#include <msp430.h> 


/**
 * main.c
 */

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	// -- LED 1
	P1DIR |= BIT0;
	P1OUT |= BIT0;


	//-- Setup Ports
	//Switch 1
	P4DIR &= ~BIT1;
	P4REN |= BIT1;
	P4OUT |= BIT1;

	//Switch 2
	P2DIR &= ~BIT3;
	P2REN |= BIT3;
	P2OUT |= BIT3;


	//-- INTERRUPTS
	P4IFG &= ~BIT1;
	P4IES |= BIT1;
	P4IE |= BIT1;

	P2IFG &= ~BIT3;
	P2IES |= BIT3;
	P2IE |= BIT3;


	PM5CTL0 &= ~LOCKLPM5;

	// -- SETUP TIMER
	TB0CTL |= TBCLR;			//CLEAR TIMER AND DIVIDERS
	TB0CTL |= TBSSEL__SMCLK;	//SOURCE = SMCLK
	TB0CTL |= MC__UP;			//MODE = UP
	TB0CCR0 = 1000;
	TB0CCR1 = 250;

	// -- SETUP TIMER COMPARE IRQ FOR CCR0 AND CCR1
	TB0CCTL0 |= CCIE;
	TB0CCTL0 &= ~CCIFG;
	TB0CCTL1 |= CCIE;
	TB0CCTL1 &= ~CCIFG;
	__enable_interrupt();


	while(1){}

	return 0;
}


//----------INTERRUPTS-----------


#pragma vector = TIMER0_B0_VECTOR
__interrupt void ISR_TB0_CCR0(void){
	P1OUT |= BIT0;
	TB0CCTL0 &= ~CCIFG;
}


#pragma vector = TIMER0_B1_VECTOR
__interrupt void ISR_TB0_CCR1(void){
	P1OUT &= ~BIT0;
	TB0CCTL1 &= ~CCIFG;
}

//---Switch Interrupts

#pragma vector = PORT4_VECTOR
__interrupt void S1_DUTY_CYCLE_UP(void){
	if(TB0CCR1 <= 450){
		TB0CCR1 += 50;
	}
	P4IFG &= ~BIT1;
}


#pragma vector = PORT2_VECTOR
__interrupt void S2_DUTY_CYCLE_DOWN(void){
	if(TB0CCR1 >=150){
		TB0CCR1 -= 50;
	}
	P2IFG &= ~BIT3;
}
