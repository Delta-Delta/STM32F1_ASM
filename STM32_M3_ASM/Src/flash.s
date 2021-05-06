FLASH_RDPRT    			EQU			0x000000A5
FLASH_KEY1				EQU			0x45670123
FLASH_KEY2				EQU			0xCDEF89AB
FLASH_BASE    	    	EQU			0x40022000
FLASH_ACR				EQU			(FLASH_BASE+0x00)
FLASH_KEYR				EQU			(FLASH_BASE+0x04)
FLASH_OPTKEYR			EQU			(FLASH_BASE+0x08)
FLASH_SR				EQU			(FLASH_BASE+0x0C)
FLASH_CR				EQU			(FLASH_BASE+0x10)
FLASH_AR				EQU			(FLASH_BASE+0x14)
FLASH_OBR				EQU    		(FLASH_BASE+0x1C)
FLASH_WRPR				EQU			(FLASH_BASE+0x20)

	
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

;R3�з���Ҫ����ҳ�ĵ�ַ
Flash_ErasePage

				PUSH {R0,R1,R2,R3, LR}
				
Flash_ErasePage_BSY
				LDR  R1,=FLASH_SR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
                TST  R0,#0x01		;SR�Ĵ�����BSYλ��Ϊ0,��ѭ����
                BNE	 Flash_ErasePage_BSY
				
				;SR�Ĵ���BSYλ��0,������������
				
				;����FLASH_CR�Ĵ�����PERλΪ'1'
				LDR  R1,=FLASH_CR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
				ORR  R2,R0,#0x02
				STR  R2,[R1]
				
				;��FLASH_AR�Ĵ���ѡ��Ҫ������ҳ
				;R3�з���Ҫ����ҳ�ĵ�ַ
				LDR  R1,=FLASH_AR	 ;ȡ�Ĵ�����ַ
				STR  R3,[R1]
				
				
				;����FLASH_CR�Ĵ�����STRTλΪ'1'
				LDR  R1,=FLASH_CR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
				ORR  R2,R0,#0x40
				STR  R2,[R1]
				
				;�ȴ�BSYλ��Ϊ��0��
				
Flash_ErasePage_BSY_Finish
				LDR  R1,=FLASH_SR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]		 ;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
                TST  R0,#0x01		 ;SR�Ĵ�����BSYλ��Ϊ0,��ѭ����
                BNE	 Flash_ErasePage_BSY_Finish
			 
				;����FLASH_CR�Ĵ�����PERλΪ'0'
				LDR  R1,=FLASH_CR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
				BIC  R2,R0,#0x02
				STR  R2,[R1]
			 
                POP {R0,R1,R2,R3,PC}


;R3�з���Ҫд��ĵ�ַ
;R4�з���Ҫд���ֵ(16 bit)
Flash_WriteByte
				PUSH   {R0,R1,R2,R3,R4,LR} 
				
				;���FLASH_SR�Ĵ�����BSYλ����ȷ��û���������ڽ��еı�̲���
Flash_WriteByte_BSY
				LDR  R1,=FLASH_SR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
                TST  R0,#0x01		;SR�Ĵ�����BSYλ��Ϊ0,��ѭ����
                BNE	 Flash_WriteByte_BSY
				
				;����FLASH_CR�Ĵ�����PGλΪ'1'
				LDR  R1,=FLASH_CR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
				ORR  R2,R0,#0x01
				STR  R2,[R1]
				
				;��ָ���ĵ�ַд��Ҫ��̵İ���
				MOV  R1,#0xFFFF
				AND  R4,R4,R1
				STRH  R4,[R3]
				
				
Flash_WriteByte_BSY_Finish
				LDR  R1,=FLASH_SR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
                TST  R0,#0x01		;SR�Ĵ�����BSYλ��Ϊ0,��ѭ����
                BNE	 Flash_WriteByte_BSY_Finish
 
				;��ȡ��֤
				;LDR  R0,[R3]
				;AND  R0,R0,#0xFFFF
				;CMP  
 
				;����FLASH_CR�Ĵ�����PGλΪ'0'
				LDR  R1,=FLASH_CR	 ;ȡ�Ĵ�����ַ
				LDR  R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
				BIC  R2,R0,#0x01
				STR  R2,[R1]
				
				
				POP    {R0,R1,R2,R3,R4,PC} 
				

;R3�з���Ҫ��ȡ�ĵ�ַ
;R4�з���Ҫ��ȡ��ֵ(WORD)
Flash_ReadByte
				PUSH   {R0,R1,R2,R3,R4,LR}
				
				;��ָ���ĵ�ַд��Ҫ��̵���
				LDR  R4,[R3]

				
				
				
				POP   {R0,R1,R2,R3,R4,PC}
				

				END