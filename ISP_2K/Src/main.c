#include "address.h"
#include "uart.h"
#include "flash.h"

#define 			ACK 	 0x79
#define			  NACK   0x1F

#define 			COMMAND_NUMBER      11
#define 			COMMAND_VERSION     0x22

#define 			COMMAND_GET	    		    	0x00
#define 			COMMAND_GV	    		    	0x01
#define 			COMMAND_GID	    		    	0x02
#define 			COMMAND_RM	    		    	0x11
#define 			COMMAND_GO	     			   	0x21
#define 			COMMAND_WM	     			   	0x31
#define 			COMMAND_WR	     			 	  0x43
#define 			COMMAND_WP	    			    0x63
#define 			COMMAND_WPUN	   		      0x73
#define 			COMMAND_RDP_RPM	        	0x82
#define 			COMMAND_RDU_RPM	        	0x92

uint8_t receive_data[8]={0};



void system_init()
{
	usart_init();
	
	while(1)
	{
		if(usart_receive(&receive_data[0])==0x7F)
		{
			
			
			__disable_irq();
			
			
		
			usart_init();
			
			usart_send(ACK);
			
			break;
		}
		
	}
	
	
	
}

void command_get()
{
//	usart_receive(&receive_data[0]);
//	usart_receive(&receive_data[1]);
//	if(receive_data[0]==0x00  &&  receive_data[1] ==0xFF )
	{
		usart_send(ACK);
		usart_send(COMMAND_NUMBER);
		usart_send(COMMAND_VERSION);

		usart_send(COMMAND_GET);
		usart_send(COMMAND_GV);
		usart_send(COMMAND_GID);
		usart_send(COMMAND_RM);
		usart_send(COMMAND_GO);
		usart_send(COMMAND_WM);
		usart_send(COMMAND_WR);
		usart_send(COMMAND_WP);
		usart_send(COMMAND_WPUN);
		usart_send(COMMAND_RDP_RPM);
		usart_send(COMMAND_RDU_RPM);
		usart_send(ACK);
		return;
	}
//	else
	{
//		usart_send(NACK);
//		return;
	}
}

void command_gid()
{

	{
		usart_send(ACK);

		usart_send(0x01);
		usart_send(0x04);
		usart_send(0x10);

		usart_send(ACK);
		
		return;
	}

	{
//		usart_send(NACK);
//		return;
	}
	
}

void command_gv()
{
	{
		usart_send(ACK);

		usart_send(COMMAND_VERSION);
		usart_send(0x00);
		usart_send(0x00);

		usart_send(ACK);
	}
	
	{
		//		usart_send(NACK);
		//		return;
	}
}

void command_rm()
{
		{
			usart_send(ACK);

//			usart_send();
//			usart_send();
//			usart_send();

			usart_send(ACK);
		}
		
		{
			//		usart_send(NACK);
			//		return;
		}
	
}


int main()
{
	
	volatile uint8_t receive=0x0;
	system_init();
	
	
	
	
	//BL_USART_Loop
	while(1)
	{
		usart_receive(&receive_data[0]);
		usart_receive(&receive_data[1]);
		
		if(receive_data[0]==0x00  &&  receive_data[1] ==0xFF )
		{
			command_get();
			continue;
		}
		
		
		if(receive_data[0]==0x01  &&  receive_data[1] ==0xFE )
		{
			command_gv();
			continue;
		
		}
		
		if(receive_data[0]==0x02  &&  receive_data[1] ==0xFD )
		{
			command_gid();
			continue;
		
		}
		
		if(receive_data[0]==0x11  &&  receive_data[1] ==0xEE )
		{
			command_rm();
			continue;
		
		}
		
		
		
		usart_send(NACK);
		continue;
		
		
		
		
		
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
}

