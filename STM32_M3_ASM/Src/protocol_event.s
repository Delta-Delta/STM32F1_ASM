ACK    			EQU			0x79
NACK			EQU			0x1F





				AREA EVENT, CODE, READONLY

				EXPORT ISP_START


				EXTERN USART1_Init	
				EXTERN USART1_SendByte
				EXTERN USART1_ReceiveByte	
				
				IMPORT receiveByte1
					
					
					
					
ISP_START				
				PUSH      {R0-R7, LR}
					
				BL 		USART1_Init	  ;��ʼ��USART (9600)
				
				;�յ�0x7F
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R6,[R7]
				CMP     R6,#0x7F
				BNE     ISP_START_Finish
				
				;�����,����ACK
				MOV     R0, #ACK 
				BL      USART1_SendByte
				
				
ISP_START_Finish				
				POP       {R0-R7,PC}
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				END
					