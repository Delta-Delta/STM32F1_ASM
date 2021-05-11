ACK    							EQU			0x79
NACK							EQU			0x1F
COMMAND_GO                      EQU         0x21
	

	

				AREA Variable_Local,DATA,READWRITE
targetFlashAddress 		DCW			 1
targetPcAddress	   		DCW 		 1	


				AREA EVENT_GO, CODE, READONLY
					
				EXPORT Protocol_Go
				;EXPORT targetFlashAddress
					
				EXTERN USART1_Init	
				EXTERN USART1_SendByte
				EXTERN USART1_ReceiveByte	
				EXTERN Flash_IsRdpEnable
				
				IMPORT receiveByte1
				IMPORT eventFlag

;R3存入目标地址
Jump_To_Target

				
				
				LDR		R7,=targetFlashAddress
				LDR		R6,=targetPcAddress
				LDR	    R0,=0x00000000
				;LDR     R1,=0xFFFFFFFF
				
				AND 	R7,R7,R0
				AND		R6,R6,R0
				
				;LDR     R5,=targetFlashAddress
				LDR     R4,=targetPcAddress
				
				LDR     R3,=targetFlashAddress 
				LDR     R3,[R3]
				LDR		R7,[R3]
				MSR     MSP,R7
				
				ADD		R6,R3,#4
				LDR		R1,[R6]     
				
				BLX		R1
				
				B		Jump_To_Target
				
Protocol_Go
				
				PUSH      {R0-R7, LR}
					
				
				
				;收到0x21 COMMAND_GO
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R6,[R7]
				CMP     R6,#COMMAND_GO
				BNE     Protocol_Go_Fail
				
				
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R5,[R7]
				EOR     R5,R5,#0xFF
				CMP     R6,R5
				BNE     Protocol_Go_Fail
				
				
				BL      Flash_IsRdpEnable
				LDR     R0,=eventFlag
				LDR     R1,[R0]
				TST		R1,#0x01
				BNE		Protocol_Go_Fail
				
				
				;若相等,发送ACK
				MOV     R0, #ACK 
				BL      USART1_SendByte
				
				;接收地址字节(4个)
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R1,[R7]
				
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R2,[R7]
				
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R3,[R7]
				
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R4,[R7]
				
				;将收到的4个字节拼接为地址并存入targetFlashAddress R7
				LSL     R1,#24
				LSL     R2,#16
				ADD     R1,R1,R2
				LSL     R3,#8
				ADD		R3,R3,R4
				ADD     R7,R1,R3
				LDR     R5,=targetFlashAddress
				STR     R7,[R5]
				
				
				;接收4个校验码
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R1,[R7]
				
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R2,[R7]
				
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R3,[R7]
				
				BL 		USART1_ReceiveByte
				LDR     R7,=receiveByte1
				LDR     R4,[R7]
				
				;拼接校验码 R6
				LSL     R1,#24
				LSL     R2,#16
				ADD     R1,R1,R2
				LSL     R3,#8
				ADD		R3,R3,R4
				ADD     R6,R1,R3
				EOR     R6,R6,0xFFFFFFFF
				LDR     R5,=targetFlashAddress
				LDR     R7,[R5]
				CMP		R6,R7
				BNE     Protocol_Go_Fail
				
				;若相等,发送ACK
				MOV     R0, #ACK 
				BL      USART1_SendByte
				
				BL		Jump_To_Target
				
				
				
Protocol_Go_Fail		
				MOV     R0, #NACK 
				BL      USART1_SendByte
Protocol_Go_Finish				
				POP       {R0-R7,PC}
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
					
				END

