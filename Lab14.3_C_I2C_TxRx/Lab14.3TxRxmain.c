/**
 * Billy Wood
 *
 * EELE 371
 *
 * April 10, 2023
 *
 * Lab 14.3
 */




#include <msp430.h> 


char Data_In = 0;
int Packet_Index = 0;
char Packet[] = {0x03, 0x15, 0x26, 0x10, 0x20, 0x04, 0x04, 0x23};
char reg_addr = 0x03;
/**
 * main.c
 */
int main(void)
{
	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	
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


	//Enable Interrupts
	UCB0IE |= UCTXIE0;
	UCB0IE |= UCRXIE0;
	__enable_interrupt();


	int i;

	while(1){

		//set MCU as TRANSMITTING
		UCB0CTLW0 |= UCTR;

		if(Packet_Index == sizeof(Packet)){
			UCB0TBCNT = 0x01;
		}

		//Generate START condition
		UCB0CTLW0 |= UCTXSTT;

		while((UCB0IFG & UCSTPIFG) == 0) {}
		UCB0IFG &= ~UCSTPIFG;

		//set MCU as RECEIVING
		UCB0CTLW0 &= ~UCTR;

		if(Packet_Index == sizeof(Packet)){
			UCB0TBCNT = 0x07;
		}

		UCB0CTLW0 |= UCTXSTT;


		while((UCB0IFG & UCSTPIFG) == 0) {}
		UCB0IFG &= ~UCSTPIFG;

	}



	return 0;
}


//-----INTERRUPT SERVICE ROUTINE-----
#pragma vector=EUSCI_B0_VECTOR
__interrupt void EUSCI_B0_I2C_ISR(void){

	//Send first Packet
	if(Packet_Index < sizeof(Packet)-1){

		UCB0TXBUF = Packet[Packet_Index];
		Packet_Index++;

	}

	else if(Packet_Index == sizeof(Packet)-1){

		UCB0TXBUF = Packet[Packet_Index];
		Packet_Index++;
		//UCB0TBCNT = sizeof(Data_In);

	}else{

		switch(UCB0IV){
			case 0x16:
				Data_In = UCB0RXBUF;
				break;
			case 0x18:
				UCB0TXBUF = reg_addr;
				break;
			default:
				break;
		}
	}



}

