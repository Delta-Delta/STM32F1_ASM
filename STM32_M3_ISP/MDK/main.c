#include "stm32f10x.h"

#include "stm32f10x_conf.h"

uint8_t  sendData=0;
uint8_t  receiveData=0;

/*********************************************************
//< 串口部分

*********************************************************/
void usart_init()
{
	RCC_DeInit();
	
	RCC_APB2ENR=0x4004;
	GPIOA_CRH=0x4B0;
	USART1_CR1=0x340C;
	USART1_BRR=0x341;
	

}


void usart_send(uint8_t data)
{
	USART1_DR=data;
	while(USART1_SR==0x40);
}

void usart_receive(uint8_t *data)
{
	while((USART1_SR&0x20)==0);
	*data=USART1_DR;
	

}

/*********************************************************
//< 串口部分 END

*********************************************************/

int main(void)
{
	usart_init();

	usart_send(0x55);

	usart_receive(&receiveData);
	while(1)
	{
	
	}
}













