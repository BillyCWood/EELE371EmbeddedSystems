/**
 * Billy Wood
 *
 * EELE 371
 *
 * March 29, 2023
 *
 * Lab 15.1
 */



#include <msp430.h> 


/**
 * main.c
 */
unsigned int ADC_Value;

int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
	P1DIR |= BIT0;
	P6DIR |= BIT6;


	P1SEL1	|=	BIT7;	//Configure P1.2 Pin for A2
	P1SEL0	|=	BIT7;


	PM5CTL0	&=	~LOCKLPM5;

	// -- Configure ADC

	ADCCTL0	&= ~ADCSHT;
	ADCCTL0	|= ADCSHT_2;
	ADCCTL0 |= ADCON;

	ADCCTL1	|=	ADCSSEL_2;	//ADC Source Clock = SMCLK
	ADCCTL1	|=	ADCSHP;

	ADCCTL2	&=	~ADCRES;
	ADCCTL2	|=	ADCRES_2;	//Resolution = 12-bit

	ADCMCTL0 |=	ADCINCH_2;	//ADC Input Channel = A2

	ADCIE |= ADCIE0;
	__enable_interrupt();



	while(1){
		ADCCTL0 |= ADCENC | ADCSC; //Enable and start conversion

		while((ADCIFG & ADCIFG0)==0); //Wait for conv. complete

		//ADC_Value = ADCMEM0; //Read ADC result


	}


	return 0;
}


// --------INTERRUPT VECTOR--------
#pragma vector = ADC_VECTOR
__interrupt void ADC_ISR(void){
	ADC_Value = ADCMEM0; //Read ADC result


	if(ADC_Value > 2500){
		//Extreme - 2v and higher
		P1OUT |= BIT0;
		P6OUT |= BIT6;

	}
	else if(ADC_Value>2100){
		//High - Between 1.75v and 2v(Not inclusive)
		P1OUT |= BIT0;
		P6OUT &= ~BIT6;
	}
	else if(ADC_Value>1250){
		//Mid - Between 1v and 1.75v(Not inclusive)
		P1OUT &= ~BIT0;
		P6OUT |= BIT6;
	}
	else{
		//Low - less than 1v
		P1OUT &= ~BIT0;
		P6OUT &= ~BIT6;
	}





/*
	if(ADC_Value > 3613){
		P1OUT |= BIT0;
		P6OUT &= ~BIT6;
	}else{
		P1OUT &= ~BIT0;
		P6OUT |= BIT6;
	}
*/

}
//----END ADC_ISR-----
