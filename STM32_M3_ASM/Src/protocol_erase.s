ACK    			EQU			0x79
NACK			EQU			0x1F







;EOR逻辑异或





				AREA Variable_Local,DATA,READWRITE
erasePageNumber DCB 1


				AREA FLASH_ERASE, CODE, READONLY
				EXPORT Erase_0x43   ;标号前面添加 EXPORT 使外部文件可以调用标号内容
				;EXPORT USART1_SendByte
				;EXPORT USART1_ReceiveByte
				
				EXTERN USART1_SendByte
				EXTERN USART1_ReceiveByte
				EXTERN Flash_IsRdpEnable
				
				EXTERN receiveByte1
				EXTERN eventFlag










Erase_Nack
				PUSH      {R0-R7, LR}
				
				B		  Erase_Finish
				
				POP       {R0-R7,PC}


Erase_Ack
				PUSH      {R0-R7, LR}
				
				
				
				
				
				POP       {R0-R7,PC}




Erase_0x43
				PUSH      {R0-R7, LR}
				
				BL        USART1_ReceiveByte
				
				;读取接收到的字节,并将接收到的字节异或
				LDR       R0,=receiveByte1
				LDR		  R1,[R0]
				EOR       R2,R1,#0xFF
				
				BL        USART1_ReceiveByte
				LDR       R0,=receiveByte1
				LDR		  R1,[R0]
				CMP		  R1,R2              
				BNE       Erase_Nack
				
				
				BL		  Flash_IsRdpEnable
				LDR		  R0,=eventFlag
				LDR       R1,[R0]
				AND		  R1,R1,#0x01
				CMP		  R1,#0x01
				BEQ		  Erase_Nack
				
				BL		  Erase_Ack


				
				
Erase_Finish
				POP       {R0-R7,PC}










				END