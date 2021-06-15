#include "address.h"

volatile uint8_t delay=0xFF;

void usart_init()
{
	
	RCC_APB2ENR|=0x4005;
	RCC_CFGR|=0x400;
	RCC_APB1ENR|=0x10000000;
	
	
	GPIOA_CRH|=0x4B0;
	USART1_CR1|=0x340C;
	USART1_BRR|=0x341;
	

}

#if defined __CC_ARM
  // Arm Compiler 5
#pragma Ospace


#elif defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
  // Arm Compiler 6



#elif defined __GNUC__
  // Normal GCC

#pragma GCC optimize ("O0")

#elif defined __ICCARM__            
 // IAR for ARM

#pragma optimize=disable

#endif

void usart_send(uint8_t data)
{

	USART1_SR =USART1_SR & 0xBF;

	USART1_DR=data ;

	while((USART1_SR&0x40)==0);



}

void usart_receive(uint8_t *data)
{
	while((USART1_SR&0x20)==0);
	*data=USART1_DR;
	

}

#if defined __CC_ARM
  // Arm Compiler 5
#pragma Ospace


#elif defined(__ARMCC_VERSION) && (__ARMCC_VERSION >= 6010050)
  // Arm Compiler 6



#elif defined __GNUC__
  // Normal GCC

#pragma GCC optimize ("O0")

#elif defined __ICCARM__            
 // IAR for ARM

#pragma optimize=disable

#endif

void usart_send_multiple(uint8_t data[],uint8_t number)
{
	uint8_t i=0;
	for(i=0;i<number;i++)
	{
		usart_send(data[i]);
	}
	
}