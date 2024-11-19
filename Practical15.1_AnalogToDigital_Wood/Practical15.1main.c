/**
 * Billy Wood
 *
 * EELE 371
 *
 * April 3, 2023
 *
 * Practical 15.1
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
	P1OUT &= ~BIT0;


	P1SEL1	|=	BIT2;	//Configure P1.2 Pin for A2
	P1SEL0	|=	BIT2;


	PM5CTL0	&=	~LOCKLPM5;

	// -- Configure ADC

	ADCCTL0	&= ~ADCSHT;
	ADCCTL0	|= ADCSHT_2;
	ADCCTL0 |= ADCON;

	ADCCTL1	|=	ADCSSEL_2;	//ADC Source Clock = SMCLK
	ADCCTL1	|=	ADCSHP;

	ADCCTL2	&=	~ADCRES;
	ADCCTL2	|=	ADCRES_1;	//Resolution = 10-bit

	ADCMCTL0 |=	ADCINCH_2;	//ADC Input Channel = A2


	while(1){

		ADCCTL0 |= ADCENC | ADCSC;

		while((ADCIFG & ADCIFG0) == 0);


		ADC_Value = ADCMEM0; //Read ADC result


		if(ADC_Value>435){
			//1.4V and greater
			P1OUT |= BIT0;
		}
		else{
			//less than 1.4v
			P1OUT &= ~BIT0;
		}

	}



	return 0;
}
