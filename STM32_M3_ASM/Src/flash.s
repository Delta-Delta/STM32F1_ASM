FLASH_RDPRT    		EQU			0x000000A5
FLASH_KEY1			EQU			0x45670123
FLASH_KEY2			EQU			0xCDEF89AB
FLASH_BASE    	    EQU			0x40022000
FLASH_ACR			EQU			(FLASH_BASE+0x00)
FLASH_KEYR			EQU			(FLASH_BASE+0x04)
FLASH_OPTKEYR		EQU			(FLASH_BASE+0x08)
FLASH_SR				EQU			(FLASH_BASE+0x0C)
FLASH_CR				EQU			(FLASH_BASE+0x10)
FLASH_AR				EQU			(FLASH_BASE+0x14)
FLASH_OBR			EQU    		(FLASH_BASE+0x1C)
FLASH_WRPR			EQU			(FLASH_BASE+0x20)

	
				AREA Variable_Local,DATA,READWRITE
flagErase DCB 1
	

				AREA |Flash_If_ASM|, CODE, READONLY
				;EXPORT Flash_Init   ;���ǰ����� EXPORT ʹ�ⲿ�ļ����Ե��ñ������
				EXPORT Flash_Unlock
				EXPORT Flash_WriteByte
				EXPORT Flash_ReadByte
				EXPORT Flash_ErasePage
					
					
				
			
Flash_Unlock					

				PUSH {R0,R1,R2,R3,R4, LR}
                
				LDR  R1,=FLASH_KEYR	 ;ȡ�Ĵ�����ַ
				MOV  R2,#0x0123	
				MOV  R3,#0x4567
				LSL  R3,#4			 ;ÿ��ֻ������һλ,��֪���Ƿ���bug
				LSL  R3,#4
				LSL  R3,#4
				LSL  R3,#4
				ADD  R0,R2,R3
				STR  R0,[R1]			;��r0�Ĵ�����ֵ�����͵���ֵַΪr1�ģ��洢�����ڴ���	
				
				NOP
				NOP
				MOV R2,#0x89AB	
				MOV R3,#0xCDEF
				LSL  R3,#4			 ;��֪���Ƿ���bug��ÿ��ֻ������һλ
				LSL  R3,#4
				LSL  R3,#4
				LSL  R3,#4
				ADD R0,R2,R3
				STR R0,[R1]			;��r0�Ĵ�����ֵ�����͵���ֵַΪr1�ģ��洢�����ڴ���
				
			 
                POP {R0,R1,R2,R3,R4,PC}

Flash_ErasePage

				PUSH {R0,R1,R2, LR}
				
				
               
                
			 
                POP {R0,R1,R2,PC}



Flash_WriteByte
				PUSH   {R0,R1,R2,R3,LR} 
 
				POP    {R0,R1,R2,R3,PC} 
				


Flash_ReadByte
				PUSH   {R0,R1,R2,R3,LR}
				


				
				
				
				POP   {R0,R1,R2,R3,PC}
				

				END