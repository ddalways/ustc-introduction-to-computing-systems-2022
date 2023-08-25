.ORIG x3000
    LDI R0, p
    LDI R1, q
    LDI R2, N ;从内存读取三个数p,q,n存入寄存器
    
    NOT R0, R0
    ADD R0, R0, #1 ;存-p
    
    NOT R1, R1
    ADD R1, R1, #1 ;存-q

    ADD R2, R2, #-1
    ADD R5, R5, #1 ;R5用于记录当前F（n-1）
    ADD R6, R6, #1
    ADD R7, R7, #1 ;F(0),F(1)初始值为1

N1      ADD R6, R0, R6 ;计算F(N-2)%p
        BRZP N1 ;如果寄存器的值不是负数， 则程序跳转到N1所指向处。
        LDI R4, p
        ADD R6, R6, R4 ;恢复正值
        
N2      ADD R7, R1, R7 ;计算F(N-1)%q
        BRZP N2 ;如果寄存器的值不是负数， 则程序跳转到N2所指向处。
        LDI R4, q
        ADD R7, R7, R4 ;恢复正值

        ADD R3, R6, R7 ;更新R3
        ADD R6, R5, #0 ;更新R6
        ADD R7, R3, #0 ;更新R7
        ADD R5, R7, #0 ;更新R5
      
        ADD R2, R2, #-1 ;经过一次循环后N-1      
      
        BRNP  N1 ;循环直至N减为0
      
        STI R3, F ;R3值写入F对应位置
        TRAP x25

p   .FILL x3100
q   .FILL x3101
N   .FILL x3102
F   .FILL x3103
    .end