LED0 			EQU			0x422101a0 
RCC 			EQU			0x40021000
RCC_APB2ENR 	EQU         (RCC+0x18)          ;0x40021018
GPIOC			EQU 		0x40011000
GPIOC_CRH		EQU		    (GPIOC+0x04)
GPIOC_BRR		EQU			(GPIOC+0x14)		;复位0
GPIOC_BSRR		EQU			(GPIOC+0x10)		;置位1






Stack_Size      EQU     0x64


                AREA    STACK, NOINIT, READWRITE, ALIGN=3
					
				
				
Stack_Mem       SPACE   Stack_Size
__initial_sp






                AREA    RESET, DATA, READONLY

__Vectors       DCD     __initial_sp               ; Top of Stack
                DCD     Reset_Handler              ; Reset Handler
                    
                    
                AREA    |.text|, CODE, READONLY
                    
                THUMB
                REQUIRE8
                PRESERVE8
                    
                ENTRY
				
				
Reset_Handler 
                BL LEDC13_Init
MainLoop        BL LED_ON
                BL Delay
                BL LED_OFF
                BL Delay
                
                B MainLoop
             

		
LEDC13_Init
				PUSH {R0,R1, LR}
				
				EXTERN USART1_Init	
				EXTERN USART1_SendByte
                
                LDR R1,=RCC_APB2ENR	 ;取寄存器地址
				LDR R0,[R1]			;读取要操作的寄存器（内存）数据到寄存器R0
				ORR R0,R0,#0x10		
				STR R0,[R1]			;将r0寄存器的值，传送到地址值为r1的（存储器）内存中
             
				
				
				LDR R1,=GPIOC_CRH
				LDR R0,[R1]
				ORR R0,R0,#0x300000
				STR R0,[R1]
             
				BL USART1_Init
				
				mov    r0, #'H' 
				bl     USART1_SendByte
			 
                POP {R0,R1,PC}
				
				
				
             
LED_ON
                PUSH {R0,R1, LR}    
                
				LDR R1,=GPIOC_BSRR
				LDR R0,[R1]    ;读取要操作的寄存器（内存）数据到寄存器R0
                ORR R0,R0,#0x20000000
				AND R0,R0,#0xFFFFDFFF
				
                
                STR R0,[R1]    ;将r0寄存器的值，传送到地址值为r1的（存储器）内存中
             
                POP {R0,R1,PC}
             
LED_OFF
                PUSH {R0,R1, LR}    
                
                LDR R1,=GPIOC_BSRR
				LDR R0,[R1]    ;读取要操作的寄存器（内存）数据到寄存器R0
                ORR R0,R0,#0x2000
				AND R0,R0,#0xDFFFFFFF
				
                
                STR R0,[R1]    ;将r0寄存器的值，传送到地址值为r1的（存储器）内存中
             
                POP {R0,R1,PC}             
             
Delay
                PUSH {R0,R1, LR}
                
                MOVS R0,#0
                MOVS R1,#0
                MOVS R2,#0
                
DelayLoop0        
                ADDS R0,R0,#1

                CMP R0,#330
                BCC DelayLoop0
                
                MOVS R0,#0
                ADDS R1,R1,#1
                CMP R1,#330
                BCC DelayLoop0

                MOVS R0,#0
                MOVS R1,#0
                ADDS R2,R2,#1
                CMP R2,#15
                BCC DelayLoop0
                
                
                POP {R0,R1,PC}    
             
    ;         NOP
	
	
	
             END