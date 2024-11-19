/**
 * Billy Wood
 *
 * EELE 371
 *
 * April 5, 2023
 *
 * Lab 14.1
 */



#include <msp430.h> 



unsigned int position;
int i, j;

char name[] = "Billy Wood ";
char first_name[] = "Billy ";
char last_name[] = "Wood ";

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	// -- 1. Pur eUSCI_A1 into SW reset
	UCA1CTLW0 |= UCSWRST;

	// -- 2. Configure eUSCI_A1
	UCA1CTLW0 |= UCSSEL__SMCLK;

	UCA1BRW = 6;
	UCA1MCTLW |= 0x2081;
	//0x20	- UBCRSx
	//8		- UCBRFx
	//1		- UCOS16

	// -- 3. Configure Ports
	P4SEL1 &= ~BIT3;
	P4SEL0 |= BIT3;


	P4DIR &= ~BIT1;
	P4REN |= BIT1;
	P4OUT |= BIT1;
	P4IES |= BIT1;


	P2DIR &= ~BIT3;
	P2REN |= BIT3;
	P2OUT |= BIT3;
	P2IES |= BIT3;



	P1DIR |= BIT0;
	P1OUT &= ~BIT0;

	P6DIR |= BIT6;
	P6OUT |= BIT6;


	PM5CTL0 &= ~LOCKLPM5;


	// -- 4. Take eUSCI_A1 out of SW reset
	UCA1CTLW0 &= ~UCSWRST;

	P4IFG &= ~BIT1;
	P4IE |= BIT1;
	P2IFG &= ~BIT3;
	P2IE |= BIT3;

	__enable_interrupt();

	//char message = 'E';


	while(1){

		//UCA1TXBUF = message;

	}





	return 0;
}




/*------------------------------------
 * INTERRUPT SERVICE ROUTINES
 *------------------------------------*/

#pragma vector = PORT4_VECTOR
__interrupt void S1_FIRST_NAME(void){

	position = 1;

	P1OUT ^= BIT0;
	P6OUT &= ~BIT6;

	UCA1IE |= UCTXCPTIE;
	UCA1IFG &= ~UCTXCPTIFG;
	UCA1TXBUF = first_name[0];
	//for(i = 0; i<1000;i++){}

	P4IFG &= ~BIT1;

}



#pragma vector = PORT2_VECTOR
__interrupt void S2_LAST_NAME(void){

	position = 0;

	P6OUT ^= BIT6;
	P1OUT &= ~BIT0;


	UCA1IE |= UCTXCPTIE;
	UCA1IFG &= ~UCTXCPTIFG;
	UCA1TXBUF = last_name[0];


	P2IFG &= ~BIT3;

}




#pragma vector = EUSCI_A1_VECTOR
__interrupt void ISR_EUSCI_A1(void){


	if(position){
		for(j = 1; j<sizeof(first_name);j++){
			UCA1TXBUF = first_name[j];
			for(i = 0; i<1000;i++){}
		}
		UCA1IE &= ~UCTXCPTIE;
	}
	else{
		//last name
		for(j = 1; j<sizeof(last_name);j++){
			UCA1TXBUF = last_name[j];
			for(i = 0; i<1000;i++){}
		}
		//for(i = 0; i<1000;i++){}

	}
	UCA1IFG &= ~UCTXCPTIFG;
}

/*------------------------------------
 * END INTERRUPT SERVICE ROUTINES
 *------------------------------------*/
