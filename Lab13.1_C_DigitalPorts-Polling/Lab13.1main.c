/**-------------------------------------------------------------------------------
 * MSP430 C Code
 *
 *  Billy Wood
 *  EELE 371
 *  March 24, 2023
 *  Lab 13.1
 */

#include <msp430.h> 


/**
 * Lab13.1main.c
 */

// -- GLOBAL VARIABLES
int counter = 0;


void delay(void){
    int i;
    for(i = 0; i<15000; i++)
    {
    }
    return;
}

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	//-- Setup LED Outputs
	P1DIR |= BIT0;
	P1OUT &= ~BIT0;

	P6DIR |= BIT6;
	P6OUT &= ~BIT6;

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

	__enable_interrupt();


	//-- Turn off GPIO
	PM5CTL0 &= ~LOCKLPM5;


//-- END SETUP --



	//-- MAIN LOOP --
	while(1){

/*	    int sw1 = P4IN;
	    sw1 &= BIT1;
	    if(sw1==0){
	    	if(counter < 3){counter = counter + 1;}
	    }

	    int sw2 = P2IN;
	    sw2 &= BIT3;

	    if(sw2==0){
	    	if(counter > 1){counter = counter - 2;}
	   	}



	    //Delay
	    delay();
	    delay();
*/
	    switch(counter){
	    case 0:
	        P1OUT &= ~BIT0;
	        P6OUT &= ~BIT6;
	        break;
	    case 1:
	        P1OUT &= ~BIT0;
	        P6OUT |= BIT6;
	        break;
	    case 2:
	        P1OUT |= BIT0;
	        P6OUT &= ~BIT6;
	        break;
	    case 3:
	        P1OUT |= BIT0;
	        P6OUT |= BIT6;
	        break;
	    }
	}



	return 0;
}





/*------------------------------------
 * INTERRUPT SERVICE ROUTINES
 *------------------------------------*/

#pragma vector = PORT4_VECTOR
__interrupt void ISR_PORT4_SW1(void){
	if(counter < 3){counter = counter + 1;}
	P4IFG &= ~BIT1;
}

#pragma vector = PORT2_VECTOR
__interrupt void ISR_PORT2_SW2(void){
	if(counter > 1){counter = counter - 2;}
	P2IFG &= ~BIT3;
}

/*------------------------------------
 * END INTERRUPT SERVICE ROUTINES
 *------------------------------------*/
