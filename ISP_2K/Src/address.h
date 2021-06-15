#include "stdint.h"

#define RCC_APB2ENR   *((volatile unsigned int*)(0x40021000+0x18))
#define RCC_CFGR       *((volatile unsigned int*)(0x40021000+0x04))
#define RCC_APB1ENR       *((volatile unsigned int*)(0x40021000+0x1C))
	




#define GPIOA_CRH     *((volatile unsigned int*)(0x40010800+0x04))
	



	


#define USART1_CR1    *((volatile unsigned int*)(0x40013800+0x0C))	
#define USART1_DR     *((volatile unsigned int*)(0x40013800+0x04))
#define USART1_SR     *((volatile unsigned int*)(0x40013800+0x00))
#define USART1_BRR    *((volatile unsigned int*)(0x40013800+0x08))
	











