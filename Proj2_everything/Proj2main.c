/**-------------------------------------------------------------------------------
 * MSP430 C Code
 *
 *  Billy Wood
 *  EELE 371
 *  May 3, 2023
 *  Proj 2
 *
 *
 *  -- 516 steps for motor
 *  	--Obtained from the motor description found on Adafruits website
 *
 *  	for(j=0;j<milseconds;j++){} where milseconds has a value of 5000
 *  	is the amount of time necessary for 1 step.
 *
 *
 *RESOLUTION ERROR = (3.3-0)/2^8 = 3.3/256 = 12.9mV
 *	151*129 = 1.95V +/- 6.45mV
 */



#include <msp430.h> 

unsigned int Packet_Index = 0;
char Packet[] = {0x00, 0x00, 0x15, 0x12, 0x03, 0x03, 0x05, 0x23};

char Data_In = 0;

unsigned int system_start_up = 1;
unsigned int time_to_read = 0;


char open_message[] = "\n\rGate is OPEN at second:  ";
char closed_message[] = "\n\rGate is CLOSED at second: ";

int display = 0;


unsigned int Steps = 512;


unsigned int ADC_Value;

unsigned int GateState = 1;
//0=Gate is OPEN
//1=Gate is CLOSED



unsigned int milseconds = 5000;


int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer

	P1DIR |= BIT0;
	P1OUT &= ~BIT0;



	//PORTS----------------------------------------
	P1SEL1	|=	BIT7;	//Configure P1.7 Pin for A2
	P1SEL0	|=	BIT7;

	P6DIR |= BIT1;
	P6DIR |= BIT2;
	P6DIR |= BIT3;
	P6DIR |= BIT4;

	P6OUT &= ~BIT1;
	P6OUT &= ~BIT2;
	P6OUT &= ~BIT3;
	P6OUT &= ~BIT4;
	//----------------------------------------------


//-- I2C
	//Put into Software reset
	UCB0CTLW0 |= UCSWRST;
	UCB0CTLW0 |= UCSSEL_3;
	UCB0BRW = 10;

	//Put into I2C mode
	UCB0CTLW0 |= UCMODE_3;

	//set MCU as MASTER
	UCB0CTLW0 |= UCMST;


	//SLAVE address
	UCB0I2CSA = 0x0068;


	//Auto STOP when UCB0TBCNT reached
	UCB0CTLW1 |= UCASTP_2;
	//Send packet
	UCB0TBCNT = sizeof(Packet);


	//PORTS
	P1SEL1 &= ~BIT3;
	P1SEL0 |= BIT3;

	P1SEL1 &= ~BIT2;
	P1SEL0 |= BIT2;

	PM5CTL0 &= ~LOCKLPM5;

	//Take out of Software Reset
	UCB0CTLW0 &= ~UCSWRST;




//-- UART
	//SW RESET
	UCA1CTLW0 |= UCSWRST;

	UCA1CTLW0 |= UCSSEL__SMCLK;

	UCA1BRW = 17;
	UCA1MCTLW |= 0x4A00;

	P4SEL1 &= ~BIT3;
	P4SEL0 |= BIT3;


	PM5CTL0	&=	~LOCKLPM5;


	UCA1CTLW0 &= ~UCSWRST;


	// -- Configure ADC

	ADCCTL0	&= ~ADCSHT;
	ADCCTL0	|= ADCSHT_2;
	ADCCTL0 |= ADCON;

	ADCCTL1	|=	ADCSSEL_2;	//ADC Source Clock = SMCLK
	ADCCTL1	|=	ADCSHP;

	ADCCTL2	&=	~ADCRES;
	ADCCTL2	|=	ADCRES_0;	//Resolution = 8-bit

	ADCMCTL0 |=	ADCINCH_7;	//ADC Input Channel = A7

	ADCIE |= ADCIE0;


	UCB0IE |= UCTXIE0;
	UCB0IE |= UCRXIE0;

	__enable_interrupt();



	unsigned int position;
	unsigned int i;
	while(system_start_up){

		UCB0CTLW0 |= UCTR;
		//Generate START condition
		UCB0CTLW0 |= UCTXSTT;
		for(i=0; i<100; i=i+1){}

	}


	//Be idle until the ADC threshold is reached
	while(1){

		ADCCTL0 |= ADCENC | ADCSC; //Enable and start conversion

		//while((ADCIFG & ADCIFG0)==0); //Wait for conv. complete
		__bis_SR_register(GIE|LPM0_bits);




		//display message
		if(display){
			if(GateState){

				for(position = 0; position<sizeof(closed_message); position++){
					UCA1TXBUF = closed_message[position];
					for(i = 0; i<100;i= i + 1){}
				}

				UCB0TBCNT = 0x01;

				//set MCU as TRANSMITTING
				UCB0CTLW0 |= UCTR;
				//Generate START condition
				UCB0CTLW0 |= UCTXSTT;

				while((UCB0IFG & UCSTPIFG) == 0);
				UCB0IFG &= ~UCSTPIFG;

				UCB0CTLW0 &= ~UCTR;
				UCB0CTLW0 |= UCTXSTT;


				while((UCB0IFG & UCSTPIFG) == 0);
				UCB0IFG &= ~UCSTPIFG;


				UCA1TXBUF = ((Data_In & 0xF0)>>4) + '0'; // Prints the 10s digit
				for (i = 0; i < 500; i++){}
				UCA1TXBUF = (Data_In & 0x0F) + '0'; // Prints the 1s digit
				for (i = 0; i < 500; i++){}
				UCA1TXBUF = '\n'; // Newline character
				for (i=0; i<100; i++){}
				UCA1TXBUF = '\r';

			}
			else{
				for(position = 0; position<sizeof(open_message); position++){
					UCA1TXBUF = open_message[position];
					for(i = 0; i<100;i= i + 1){}
				}

				UCB0TBCNT = 0x01;

				//set MCU as TRANSMITTING
				UCB0CTLW0 |= UCTR;
				//Generate START condition
				UCB0CTLW0 |= UCTXSTT;

				while((UCB0IFG & UCSTPIFG) == 0);
				UCB0IFG &= ~UCSTPIFG;

				UCB0CTLW0 &= ~UCTR;
				UCB0CTLW0 |= UCTXSTT;


				while((UCB0IFG & UCSTPIFG) == 0);
				UCB0IFG &= ~UCSTPIFG;


				UCA1TXBUF = ((Data_In & 0xF0)>>4) + '0'; // Prints the 10s digit
				for (i = 0; i < 500; i++){}
				UCA1TXBUF = (Data_In & 0x0F) + '0'; // Prints the 1s digit
				for (i = 0; i < 500; i++){}
				UCA1TXBUF = '\n'; // Newline character
				for (i=0; i<100; i++){}
				UCA1TXBUF = '\r';
			}


			display = 0;
		}
		else{}



	}

	return 0;
}



// --------INTERRUPT VECTOR--------
#pragma vector=EUSCI_B0_VECTOR
__interrupt void EUSCI_B0_I2C_ISR(void){


	switch(UCB0IV){
		case 0x16:
			Data_In = UCB0RXBUF;
			break;
		case 0x18:
			if(time_to_read==1){
				UCB0TXBUF = Packet[0];
			}
			else if(Packet_Index == sizeof(Packet)-1){
				UCB0TXBUF = Packet[Packet_Index];
				Packet_Index++;
				system_start_up = 0;
			}else if(Packet_Index < sizeof(Packet)-1){
				UCB0TXBUF = Packet[Packet_Index];
				Packet_Index++;
			}
			break;
		default:
			break;


	}


}



//-----------------------------------------------------


#pragma vector = ADC_VECTOR
__interrupt void ADC_ISR(void){
	ADC_Value = ADCMEM0; //Read ADC result






	if(ADC_Value >= 160){
		//2.3v and higher
		P1OUT |= BIT0;
		//Open gate
		if(GateState == 1){

			display = 1;
			GateState = 0;
			time_to_read = 1;

			int k;
			int j;
			int bob;

			for(k = 0; k<(Steps/4);k++){//divide by 3 because 12 steps among 4 LEDs is 3 cycles


				P6OUT |= BIT1;

				//for(bob = 0; bob < 7; bob++){
				for(j=0;j<milseconds;j++){}//delay
				//}

				P6OUT &= ~BIT1;


				P6OUT |= BIT2;
				//for(bob = 0; bob < 7; bob++){
				for(j=0;j<milseconds;j++){}//delay
				//}
				P6OUT &= ~BIT2;


				P6OUT |= BIT3;
				//for(bob = 0; bob < 7; bob++){
				for(j=0;j<milseconds;j++){}//delay
				//}
				P6OUT &= ~BIT3;


				P6OUT |= BIT4;
				//for(bob = 0; bob < 7; bob++){
				for(j=0;j<milseconds;j++){}//delay
				//}
				P6OUT &= ~BIT4;

			}

		}




	}

	else{

		//Low - less than 2.3v
		//Close gate
		if(GateState==0){

			display = 1;
			GateState = 1;
			time_to_read = 1;

			int k;
			int j;
			int bob;

			for(k = 0; k<(Steps/4);k++){//divide by 3 because 12 steps among 4 LEDs is 3 cycles

				P6OUT |= BIT4;
				//for(bob = 0; bob < 7; bob++){
				for(j=0;j<milseconds;j++){}//delay
								//}
				P6OUT &= ~BIT4;


				P6OUT |= BIT3;
				//for(bob = 0; bob < 7; bob++){
				for(j=0;j<milseconds;j++){}//delay
								//}
				P6OUT &= ~BIT3;


				P6OUT |= BIT2;
				//for(bob = 0; bob < 7; bob++){
				for(j=0;j<milseconds;j++){}//delay
								//}
				P6OUT &= ~BIT2;


				P6OUT |= BIT1;
				//for(bob = 0; bob < 7; bob++){
				for(j=0;j<milseconds;j++){}//delay
								//}
				P6OUT &= ~BIT1;
			}


		}


		P1OUT &= ~BIT0;
	}


	//ADCIFG &= ~BIT1;
	__bic_SR_register_on_exit(LPM0_bits);

}
//----END ADC_ISR-----
