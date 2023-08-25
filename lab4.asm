.ORIG x3000
        LDI R0, SCORE   ;a[j]
        LDI R1, SCORE0  ;a[i]
        
CIR     LDI R0, SCORE   ;开始冒泡排序:a[j]
        LDI R1, SCORE0  ;a[i]
        NOT R2, R1
        ADD R2, R2, #1
        ADD R3, R2, R0 ;利用a[j]-a[i]比较大小
        BRZP BIGGER  ;正数或0
        BRN  SMALLER ;负数
        
BIGGER  LD R7, SCORE
        ADD R7, R7, x1
        ST R7, SCORE ; j++
        BRNZP NEXT0
 
SMALLER ADD R4, R1, #0
        ADD R1, R0, #0
        ADD R0, R4, #0 ;如果小，则替换

        STI R0, SCORE  ;替换完毕修改内存：a[j]
        STI R1, SCORE0      ;a[i]
        BRNZP BIGGER
       
NEXT0   LD R2, SCORE
        LD R3, SCOREN
        NOT R2, R2
        ADD R2, R2, #1
        ADD R4, R2, R3
        BRNP NEXT1  ;内循环结束则进入外层循环
        LD R7, SCORE0
        ADD R7, R7, x1
        ST R7, SCORE0
        ST R7, SCORE ; i++   j = i
       
NEXT1   LD R2, SCORE0
        LD R3, SCOREN
        NOT R2, R2
        ADD R2, R2, #1
        ADD R4, R2, R3
        BRNP CIR       ;外层循环结束就是进入下一步，最终实现了升序排列
        
        LDI R0 SCORE00 ;排序结束（升序），开始存入指定位置
        AND R6, R6, #0  ;计数用的
       
CIR1    STI R0 STRING ;写入排序后的结果
        
        LD R7, SCORE00
        ADD R7, R7, x1
        ST R7, SCORE00
        
        LD R7, STRING
        ADD R7, R7, x1
        ST R7, STRING ;依次写入
        
        ADD R6, R6, x1  ;count ++

        LD R1, Q25 ;判断是否是A
        NOT R1, R1 ;-12
        ADD R1, R1, #1
        ADD R2, R6, R1 ;作比较  count-12
        BRP NEXT5 ;正数
        BRNZ CONTINUE1 ;0/负
        
NEXT5   LD R1, A
        NOT R1, R1 ;-85
        ADD R1, R1, #1
        ADD R2, R0, R1 ;作比较 score>85
        BRZP SUCCESSA ;0/正数
        BRN CONTINUE1 ;不是A
        
SUCCESSA LDI R5, SA
         ADD R5, R5, #1
         STI R5, SA  ;结果写入      
         BRNZP FINISH ;直接跳转
        
CONTINUE1  LD R1, Q50 ; 判断是否是B
           NOT R1, R1 ;-8
           ADD R1, R1, #1
           ADD R2, R6, R1 ;作比较 count-8
           BRP NEXT6
           BRNZ FINISH
        
NEXT6   LD R1, B
        NOT R1, R1 ;-75
        ADD R1, R1, #1
        ADD R2, R0, R1 ;作比较 score>75
        BRZP SUCCESSB
        BRN FINISH

SUCCESSB    LDI R5, SB
            ADD R5, R5, #1
            STI R5, SB  ;结果写入       
            BRNZP FINISH ;直接跳转
        
FINISH  LDI R0 SCORE00
        LD R2, SCORE00
        LD R3, SCOREN
        NOT R2, R2
        ADD R2, R2, #1
        ADD R4, R2, R3
        BRNP CIR1 ;读入下一个数字


SCOREN  .FILL x4010
SCORE00 .FILL x4000
SCORE0  .FILL x4000     ;不会变化的首地址        
SCORE   .FILL x4000     ;学生分数        
STRING  .FILL x5000     ;排序后的结果
SA       .FILL x5100     ;评价为A的人
SB       .FILL x5101     ;评价为Ｂ的人

A       .FILL #85
B       .FILL #75

Q50     .FILL #8
Q25     .FILL #12       
    TRAP x25
.end
