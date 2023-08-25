; Unfortunately we have not YET installed Windows or Linux on the LC-3,
; so we are going to have to write some operating system code to enable
; keyboard interrupts. The OS code does three things:
;
;    (1) Initializes the interrupt vector table with the starting
;        address of the interrupt service routine. The keyboard
;        interrupt vector is x80 and the interrupt vector table begins
;        at memory location x0100. The keyboard interrupt service routine
;        begins at x1000. Therefore, we must initialize memory location
;        x0180 with the value x1000.
;    (2) Sets bit 14 of the KBSR to enable interrupts.
;    (3) Pushes a PSR and PC to the system stack so that it can jump
;        to the user program at x3000 using an RTI instruction.

        .ORIG x800
        ; (1) Initialize interrupt vector table.
        LD R0, VEC
        LD R1, ISR
        STR R1, R0, #0

        ; (2) Set bit 14 of KBSR.
        LDI R0, KBSR
        LD R1, MASK
        NOT R1, R1
        AND R0, R0, R1
        NOT R1, R1
        ADD R0, R0, R1
        STI R0, KBSR

        ; (3) Set up system stack to enter user space.
        LD R0, PSR
        ADD R6, R6, #-1
        STR R0, R6, #0
        LD R0, PC
        ADD R6, R6, #-1
        STR R0, R6, #0
        ; Enter user space.
        RTI
        
VEC     .FILL x0180
ISR     .FILL x1000
KBSR    .FILL xFE00
MASK    .FILL x4000
PSR     .FILL x8002
PC      .FILL x3000
        .END

        .ORIG x3000
        ; *** Begin user program code here ***
        ; 打印学号
        LDR R0, R6, #0
PUT     LEA R0, XH
        TRAP x22
        LEA R0, BLANK
        TRAP x22
        JSR DELAY
        BRnzp  PUT
        HALT
        
        
XH      .STRINGZ "PBXXXXXXXX"
BLANK   .STRINGZ "          "  


DELAY   ST R1, SAVER
        LD R1, COUNT
REP     ADD R1, R1, #-1
        BRp REP
        LD  R1, SAVER
        RET

COUNT   .FILL   #2500
SAVER   .BLKW   1


        ; *** End user program code here ***
        
        .END
        
        .ORIG x10EF
        ; *** Begin honoi data here ***
        		
HANOI   
        AND  R1, R1, #0
        ADD  R1, R1, #0
        STI  R1, RESULT
        STI  R1, RESULT_
        ; N为0的判断
        ADD R0, R0, #0
        BRz END0
        ; -N
        NOT R2, R0
        ADD R2, R2, #1
        STI R2, HANO_N
 HANOI_          
        LD  R2, N
        LDI  R3, RESULT
        LDI  R4, RESULT_
        LDI  R1, HANO_N
        ;H(n) =  2H(n-1) + 1
        ADD R3, R4, R4
        ADD R3, R3, #1
        ADD R4, R3, #0
        
        STI  R3, RESULT
        STI  R4, RESULT_
        
        ADD R2, R2, #1
        ST  R2, N

        ADD R5, R2, R1
        BRnp HANOI_
END0        
        ADD R1, R3, #0
        
        RET
        
        

N       .FILL #0 
HANOI_N .FILL xFFFF
HANO_N .FILL x0000
RESULT  .FILL x2000
RESULT_ .FILL x2001
        ; *** End honoi data here ***
        .END
      

        .ORIG x1000

LOOP1	LD		R0, MIDDLE	
    	LDR		R1, R0, #-1		;检查键盘状态
		BRZP	LOOP1
    	LDR		R1, R0, #1		;检查键盘输入
        LD R2, NUM0
        LD R3, NUM9
        NOT R2,R2           ;将kbdr中只与0，9比较以判断是否是数字
        ADD R2,R2,#1
        ADD R2,R2,R1
        BRn NOTNUM
        NOT R3,R3
        ADD R3,R3,#1
        ADD R3,R3,R1
        BRp NOTNUM
        BRnzp ISNUM

ISNUM   
    
        
        LEA R0, OUT5
        TRAP X22
        
        ADD R0, R1, #0
        TRAP x21
        
        LEA R0, OUT2
        TRAP X22
        
        LEA R0, OUT3
        TRAP x22
        
        ADD R0, R2, #0
        JSR HANOI
        LDI R0, RESULT

        ADD R1, R0, #0
        JSR DEAL
        
        
        LD R2, NUM0
        NOT R2,R2           
        ADD R2,R2,#1    
        
        LDI R0, RESULT1
        ADD R5, R0, R2
        BRz T1
        ADD R0, R0, #0
        TRAP x21

T1    LDI R0, RESULT2
        ADD R5, R0, R2
        BRz T2
        ADD R0, R0, #0
        TRAP x21
       
T2    LDI R0, RESULT3
        TRAP x21
        
        LEA R0, OUT4
        TRAP x22
        BRnzp DONE
        
NOTNUM  
        LEA R0, OUT5
        TRAP X22
        
        ADD R0, R1, #0
        TRAP x21
        
        LEA R0, OUT1
        TRAP x22
        BRnzp DONE
        
DONE    STI R1, SAVER1
        LDR	R4,R6,#0				;从栈中取回数据
		ADD	R6,R6,#1
		LDR	R3,R6,#0
		ADD	R6,R6,#1
		LDR	R2,R6,#0
		ADD	R6,R6,#1
		LDR	R1,R6,#0
		ADD	R6,R6,#1
		LDR	R0,R6,#0
		ADD	R6,R6,#1
        TRAP x25
		RTI	
		;回到用户程序
		
; 		将三位数的结果拆分成3个数字
DEAL           
        LD R2, NUM0
        LD R3, NUM2
        AND R5, R5, #0
        
RE1     ADD R5, R5, #1
        ADD R1, R1, R3
        BRzp RE1
        ADD R5, R5, #-1
        
        NOT R3,R3
        ADD R3,R3,#1
        ADD R1, R1, R3
        
        ADD R5, R5, R2
        STI R5, RESULT1
        
        LD R3, NUM1
        AND R5, R5, #0

RE2     ADD R5, R5, #1
        ADD R1, R1, R3
        BRzp RE2
        ADD R5, R5, #-1
        ADD R1, R1, #10

        ADD R5, R5, R2
        STI R5, RESULT2
        
        ADD R1, R1, R2
        STI R1, RESULT3
        RET
        
        

RESULT1 .FILL x0FF2
RESULT2 .FILL x0FF3
RESULT3 .FILL x1FF4
NUM1    .FILL #-10
NUM2    .FILL #-100
		
		
OUT1    .STRINGZ    "  is not a decimal digit.\n"
OUT2    .STRINGZ    "  is a decimal digit.\n"
OUT3    .STRINGZ    "Tower of hanoi needs "
OUT4    .STRINGZ    " moves.\n"
OUT5    .STRINGZ    "\n"
NUM0    .FILL #48
NUM9    .FILL #57
MIDDLE  .FILL   xFE01
KBDR	.FILL	xFE02
DSR		.FILL	xFE04
DDR		.FILL	xFE06
HON 	.FILL	x3FF0			
SAVER1   .BLKW 1

; *** End interrupt service routine code here ***
        .END
        
        