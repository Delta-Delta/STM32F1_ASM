GPIOA    		EQU			0x40010800
GPIOA_CRH		EQU		    (GPIOA+0x04)
GPIOA_ODR		EQU			(GPIOA+0x0C)
RCC 			EQU			0x40021000
RCC_APB2ENR 	EQU         (RCC+0x18)          ;0x40021018
USART1          EQU 		0x40013800
USART1_CR1		EQU			(USART1+0x0C)
USART1_BRR		EQU			(USART1+0x08)
USART1_DR       EQU			(USART1+0x04)		
USART1_SR       EQU			(USART1+0x00)	

				AREA Receive_Data,DATA,READWRITE
receiveByte1    DCB   1
receiveByte2	DCB	  1

				AREA USART, CODE, READONLY
				EXPORT USART1_Init   ;���ǰ����� EXPORT ʹ�ⲿ�ļ����Ե��ñ������
				EXPORT USART1_SendByte
				EXPORT USART1_ReceiveByte
					
				EXPORT receiveByte1
					
				;GBLA   receiveData
					
USART1_Init
				PUSH {R0,R1,R2, LR}
                
                LDR R1,=RCC_APB2ENR	 ;ȡ�Ĵ�����ַ
				LDR R0,[R1]			;��ȡҪ�����ļĴ������ڴ棩���ݵ��Ĵ���R0
				MOV R2,#0x4004
				ORR R0,R0,R2		
				STR R0,[R1]			;��r0�Ĵ�����ֵ�����͵���ֵַΪr1�ģ��洢�����ڴ���
             
				
				
				LDR R1,=GPIOA_CRH
				LDR R0,[R1]
				ORR R0,R0,#0x4B0  ;����PA9   50MHz���� ���  PA10 ����ģʽ  
				STR R0,[R1]
             
				
				
				LDR R1,=USART1_CR1
				LDR R0,[R1]
				MOV R0,#0x340C
				STR R0,[R1]
				
				;���岨����Ϊ9600
				LDR R1,=USART1_BRR
				LDR R0,[R1]
				MOV R0,#0x341
				STR R0,[R1]
				
				CPSID i				; // Disable all interrupts except NMI(includes a non-maskable interrupt).set PRIMASK
			 
                POP {R0,R1,R2,PC}


USART1_SendByte
				PUSH   {R0,R1,R2,R3,LR} 
				LDR    R2, =USART1_DR   
				STR    R0, [R2] 
b1 
				LDR    R2, =USART1_SR  
				LDR    R2, [R2] 
				TST    r2, #0x40 
				BEQ    b1 
				;�������(Transmission complete)�ȴ� 
				POP    {R0,R1,R2,R3,PC} 
				


USART1_ReceiveByte
				PUSH   {R0,R1,R2,R3,LR}
				

b2				
				;�ж�RXNEλ�Ƿ�Ϊ1
				LDR    R0, =USART1_SR  
				LDR    R0, [R0] 
				
				TST    R0, #0x20
				BEQ	   b2
				
				LDR    R2, =USART1_DR  
				LDR    R0, [R2]
				AND    R0,R0,#0xFF
				
				LDR    R3,=receiveByte1
				STR	   R0,[R3]
				;BL     USART1_SendByte
				
				
				
				POP   {R0,R1,R2,R3,PC}
				

				END