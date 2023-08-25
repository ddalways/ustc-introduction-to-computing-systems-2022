.ORIG x3000
        LDI R0, S
        
        AND R1, R1, #0      ;记录当前序列长度
        AND R3, R0, #0      ;初始化R3（是上一个字符）
        
CIR     NOT R4, R0
        ADD R4, R4, #1
        ADD R5, R4, R3 ;取反
        BRNP DIFF   
        BRZ  SAME ;值为0，即相同
    
SAME    ADD R1, R1, #1
        BRNZP   NEXT
      
DIFF    AND R4, R4, #0
        AND R5, R5, #0
        ADD R4, R4, R1
        ADD R5, R5, R2 ; 比较当前序列与所存序列数
        
        NOT R5, R5
        ADD R5, R5, #1
        ADD R4, R4, R5 ; R1-R2
        BRNZ CON ;为0跳转
        
        ADD R2, R1, #0 ; R2记录最大序列长度，如果R1>R2则令R2=R1
CON     AND R1, R1, #0
        BRNZP   SAME
        
NEXT    ADD R3, R0, #0
        LD R7, S
        ADD R7, R7, #1 ;读下一个字符
        ST R7, S
        LDI R0, S
        BRNP CIR ;不是0跳转（没读完）

        AND R4, R4, #0 ;读完也要进行一次比较
        AND R5, R5, #0
        ADD R4, R4, R1
        ADD R5, R5, R2

        NOT R5, R5
        ADD R5, R5, #1
        ADD R4, R4, R5; R1-R2
        BRNZ CON0

        ADD R2, R1, #0 ;如果R1>R2则另R2=R1
CON0    STI R2, NUM0 ;写入


NUM0 .FILL x3050
NUM .FILL x3100
S   .FILL x3101
    TRAP x25
    .end