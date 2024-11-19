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

int Packet_Index = 0;
char Packet[] = {0x00, 0x015, 0x06, 0x10, 0x09, 0x01, 0x04, 0x23};
//ORDER OF PACKET CONTENTS:
//[0]Starting Register, [1]Seconds, [2]Minutes, [3]Hour, [4]Day, [5]Weekday, [6]Month, [7]2-digit Year




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

	//set MCU as TRANSMITTING
	UCB0CTLW0 |= UCTR;

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
	__enable_interrupt();

	int i;

	while(1){
		//Generate START condition
		UCB0CTLW0 |= UCTXSTT;
		for(i=0; i<100; i=i+1){}

	}



	return 0;
}


//-----INTERRUPT SERVICE ROUTINE-----
#pragma vector=EUSCI_B0_VECTOR
__interrupt void EUSCI_B0_I2C_ISR(void){

	if(Packet_Index == sizeof(Packet)-1){
		UCB0TXBUF = Packet[Packet_Index];
		Packet_Index=0;
	}else{
		UCB0TXBUF = Packet[Packet_Index];
		Packet_Index++;
	}


}
