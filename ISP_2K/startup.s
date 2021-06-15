

Stack_Size      EQU     0x64


                AREA    STACK, NOINIT, READWRITE, ALIGN=3
					
				
				
Stack_Mem       SPACE   Stack_Size
__initial_sp



				EXPORT  Reset_Handler             [WEAK]
				IMPORT  main


                AREA    RESET, DATA, READONLY

__Vectors       DCD     __initial_sp               ; Top of Stack
                DCD     Reset_Handler              ; Reset Handler
                    
                    
                AREA    |.text|, CODE, READONLY
                    
                THUMB
                REQUIRE8
                PRESERVE8
                    
                ENTRY










Reset_Handler 

				LDR     R0, =main
                BX      R0
				
MainLoop        
               
                
                B MainLoop
				
				
				END
					
					