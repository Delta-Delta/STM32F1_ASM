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
				;EXPORT Flash_Init   ;标号前面添加 EXPORT 使外部文件可以调用标号内容
				EXPORT Flash_Unlock
				EXPORT Flash_WriteByte
				EXPORT Flash_ReadByte
				EXPORT Flash_ErasePage
					
					
				
			
Flash_Unlock					

				PUSH {R0,R1,R2,R3,R4, LR}
                
				LDR  R1,=FLASH_KEYR	 ;取寄存器地址
				MOV  R2,#0x0123	
				MOV  R3,#0x4567
				LSL  R3,#4			 ;每次只能左移一位,不知道是否有bug
				LSL  R3,#4
				LSL  R3,#4
				LSL  R3,#4
				ADD  R0,R2,R3
				STR  R0,[R1]			;将r0寄存器的值，传送到地址值为r1的（存储器）内存中	
				
				NOP
				NOP
				MOV R2,#0x89AB	
				MOV R3,#0xCDEF
				LSL  R3,#4			 ;不知道是否有bug，每次只能左移一位
				LSL  R3,#4
				LSL  R3,#4
				LSL  R3,#4
				ADD R0,R2,R3
				STR R0,[R1]			;将r0寄存器的值，传送到地址值为r1的（存储器）内存中
				
			 
                POP {R0,R1,R2,R3,R4,PC}

;R3中放入要擦除页的地址
Flash_ErasePage

				PUSH {R0,R1,R2,R3, LR}
				
Flash_ErasePage_BSY
				LDR  R1,=FLASH_SR	 ;取寄存器地址
				LDR  R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
                TST  R0,#0x01		;SR寄存器中BSY位不为0,则循环等
                BNE	 Flash_ErasePage_BSY
				
				;SR寄存器BSY位是0,继续擦除操作
				
				;设置FLASH_CR寄存器的PER位为'1'
				LDR  R1,=FLASH_CR	 ;取寄存器地址
				LDR  R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
				ORR  R2,R0,#0x02
				STR  R2,[R1]
				
				;用FLASH_AR寄存器选择要擦除的页
				;R3中放入要擦除页的地址
				LDR  R1,=FLASH_AR	 ;取寄存器地址
				STR  R3,[R1]
				
				
				;设置FLASH_CR寄存器的STRT位为'1'
				LDR  R1,=FLASH_CR	 ;取寄存器地址
				LDR  R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
				ORR  R2,R0,#0x40
				STR  R2,[R1]
				
				;等待BSY位变为’0’
				
Flash_ErasePage_BSY_Finish
				LDR  R1,=FLASH_SR	 ;取寄存器地址
				LDR  R0,[R1]		 ;读取要操作的寄存器（内存）数据到寄存器R0
                TST  R0,#0x01		 ;SR寄存器中BSY位不为0,则循环等
                BNE	 Flash_ErasePage_BSY_Finish
			 
				;设置FLASH_CR寄存器的PER位为'0'
				LDR  R1,=FLASH_CR	 ;取寄存器地址
				LDR  R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
				BIC  R2,R0,#0x02
				STR  R2,[R1]
			 
                POP {R0,R1,R2,R3,PC}


;R3中放入要写入的地址
;R4中放入要写入的值(16 bit)
Flash_WriteByte
				PUSH   {R0,R1,R2,R3,R4,LR} 
				
				;检查FLASH_SR寄存器的BSY位，以确认没有其他正在进行的编程操作
Flash_WriteByte_BSY
				LDR  R1,=FLASH_SR	 ;取寄存器地址
				LDR  R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
                TST  R0,#0x01		;SR寄存器中BSY位不为0,则循环等
                BNE	 Flash_WriteByte_BSY
				
				;设置FLASH_CR寄存器的PG位为'1'
				LDR  R1,=FLASH_CR	 ;取寄存器地址
				LDR  R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
				ORR  R2,R0,#0x01
				STR  R2,[R1]
				
				;在指定的地址写入要编程的半字
				MOV  R1,#0xFFFF
				AND  R4,R4,R1
				STRH  R4,[R3]
				
				
Flash_WriteByte_BSY_Finish
				LDR  R1,=FLASH_SR	 ;取寄存器地址
				LDR  R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
                TST  R0,#0x01		;SR寄存器中BSY位不为0,则循环等
                BNE	 Flash_WriteByte_BSY_Finish
 
				;读取验证
				;LDR  R0,[R3]
				;AND  R0,R0,#0xFFFF
				;CMP  
 
				;设置FLASH_CR寄存器的PG位为'0'
				LDR  R1,=FLASH_CR	 ;取寄存器地址
				LDR  R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
				BIC  R2,R0,#0x01
				STR  R2,[R1]
				
				
				POP    {R0,R1,R2,R3,R4,PC} 
				

;R3中放入要读取的地址
;R4中放入要读取的值(WORD)
Flash_ReadByte
				PUSH   {R0,R1,R2,R3,R4,LR}
				
				;在指定的地址写入要编程的字
				LDR  R4,[R3]

				
				
				
				POP   {R0,R1,R2,R3,R4,PC}
				

				END