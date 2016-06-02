##################################################
# test
#

    #-----------------------------------------
    # text section
    #
    .text
    .align 4

    # entry point and pre-defined functions
    .global main
    .extern DIM
    .extern DOFS
    .extern ReadInt
    .extern WriteInt
    .extern WriteStr
    .extern WriteChar
    .extern WriteLn

    # scope dummyINTfunc
dummyINTfunc:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_dummyINTfunc_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope dummyCHARfunc
dummyCHARfunc:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_dummyCHARfunc_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope dummyBOOLfunc
dummyBOOLfunc:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_dummyBOOLfunc_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope dummyProcedure
dummyProcedure:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_dummyProcedure_exit:
    # epilogue
    addl    $0, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope f0
f0:
    # stack offsets:
    #    -13(%ebp)   1  [ $t3       <bool> %ebp-13 ]
    #      8(%ebp)   1  [ %v1       <char> %ebp+8 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $4, %esp                # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 0(%esp)          

    # function body
l_f0_1_while_cond:
    movl    $97, %eax               #   1:     if     97 = 99 goto 4_if_true
    movl    $99, %ebx              
    cmpl    %ebx, %eax             
    je      l_f0_4_if_true         
    jmp     l_f0_5_if_false         #   2:     goto   5_if_false
l_f0_4_if_true:
    jmp     l_f0_3                  #   4:     goto   3
l_f0_5_if_false:
l_f0_3:
    movl    $98, %eax               #   7:     assign v1 <- 98
    movb    %al, 8(%ebp)           
    jmp     l_f0_1_while_cond       #   8:     goto   1_while_cond
l_f0_9_while_cond:
    movl    $87428, %eax            #  10:     if     87428 < 28071 goto 10_while_body
    movl    $28071, %ebx           
    cmpl    %ebx, %eax             
    jl      l_f0_10_while_body     
    jmp     l_f0_8                  #  11:     goto   8
l_f0_10_while_body:
l_f0_13_while_cond:
    jmp     l_f0_12                 #  14:     goto   12
    jmp     l_f0_13_while_cond      #  15:     goto   13_while_cond
l_f0_12:
    movl    $1, %eax                #  17:     return 1
    jmp     l_f0_exit              
    jmp     l_f0_9_while_cond       #  18:     goto   9_while_cond
l_f0_8:
    jmp     l_f0_18                 #  20:     goto   18
    movl    $1, %eax                #  21:     assign t3 <- 1
    movb    %al, -13(%ebp)         
    jmp     l_f0_19                 #  22:     goto   19
l_f0_18:
    movl    $0, %eax                #  24:     assign t3 <- 0
    movb    %al, -13(%ebp)         
l_f0_19:
    movzbl  -13(%ebp), %eax         #  26:     return t3
    jmp     l_f0_exit              

l_f0_exit:
    # epilogue
    addl    $4, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope f1
f1:
    # stack offsets:
    #    -16(%ebp)   4  [ $t3       <int> %ebp-16 ]
    #    -17(%ebp)   1  [ $t4       <bool> %ebp-17 ]
    #    -24(%ebp)   4  [ $t5       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t6       <int> %ebp-28 ]
    #      8(%ebp)   4  [ %v1       <ptr(4) to <array 31 of <array 2 of <array 43 of <array 85 of <array 83 of <int>>>>>>> %ebp+8 ]
    #    -29(%ebp)   1  [ $v2       <bool> %ebp-29 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $20, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $5, %ecx               
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    call    ReadInt                 #   0:     call   t3 <- ReadInt
    movl    %eax, -16(%ebp)        
    movl    $5956, %eax             #   1:     if     5956 >= 10031 goto 2
    movl    $10031, %ebx           
    cmpl    %ebx, %eax             
    jge     l_f1_2                 
    jmp     l_f1_3                  #   2:     goto   3
l_f1_2:
    movl    $1, %eax                #   4:     assign t4 <- 1
    movb    %al, -17(%ebp)         
    jmp     l_f1_4                  #   5:     goto   4
l_f1_3:
    movl    $0, %eax                #   7:     assign t4 <- 0
    movb    %al, -17(%ebp)         
l_f1_4:
    movzbl  -17(%ebp), %eax         #   9:     assign v2 <- t4
    movb    %al, -29(%ebp)         
    movl    $68613, %eax            #  10:     add    t5 <- 68613, 76361
    movl    $76361, %ebx           
    addl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #  11:     sub    t6 <- t5, 67616
    movl    $67616, %ebx           
    subl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #  12:     return t6
    jmp     l_f1_exit              

l_f1_exit:
    # epilogue
    addl    $20, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope f2
f2:
    # stack offsets:
    #    -16(%ebp)   4  [ $t3       <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t4       <int> %ebp-20 ]
    #    -21(%ebp)   1  [ $t5       <bool> %ebp-21 ]
    #    -22(%ebp)   1  [ $t6       <char> %ebp-22 ]
    #      8(%ebp)   1  [ %v1       <char> %ebp+8 ]
    #     12(%ebp)   1  [ %v2       <bool> %ebp+12 ]
    #     16(%ebp)   4  [ %v3       <ptr(4) to <array 64 of <array 68 of <array 98 of <array 82 of <array 32 of <int>>>>>>> %ebp+16 ]
    #    -28(%ebp)   4  [ $v4       <int> %ebp-28 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $16, %esp               # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 12(%esp)         
    movl    %eax, 8(%esp)          
    movl    %eax, 4(%esp)          
    movl    %eax, 0(%esp)          

    # function body
    movl    $0, %eax                #   0:     assign v2 <- 0
    movb    %al, 12(%ebp)          
l_f2_2_while_cond:
    movl    $86544, %eax            #   2:     mul    t3 <- 86544, 42241
    movl    $42241, %ebx           
    imull   %ebx                   
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   3:     mul    t4 <- t3, 8241
    movl    $8241, %ebx            
    imull   %ebx                   
    movl    %eax, -20(%ebp)        
    movl    $65002, %eax            #   4:     if     65002 = t4 goto 3_while_body
    movl    -20(%ebp), %ebx        
    cmpl    %ebx, %eax             
    je      l_f2_3_while_body      
    jmp     l_f2_1                  #   5:     goto   1
l_f2_3_while_body:
    call    dummyBOOLfunc           #   7:     call   t5 <- dummyBOOLfunc
    movb    %al, -21(%ebp)         
l_f2_7_while_cond:
    jmp     l_f2_6                  #   9:     goto   6
    jmp     l_f2_7_while_cond       #  10:     goto   7_while_cond
l_f2_6:
    movl    $57155, %eax            #  12:     assign v4 <- 57155
    movl    %eax, -28(%ebp)        
    jmp     l_f2_2_while_cond       #  13:     goto   2_while_cond
l_f2_1:
    call    dummyCHARfunc           #  15:     call   t6 <- dummyCHARfunc
    movb    %al, -22(%ebp)         

l_f2_exit:
    # epilogue
    addl    $16, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test
main:
    # stack offsets:
    #    -13(%ebp)   1  [ $t0       <char> %ebp-13 ]
    #    -14(%ebp)   1  [ $t1       <char> %ebp-14 ]
    #    -20(%ebp)   4  [ $t2       <int> %ebp-20 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $8, %esp                # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 4(%esp)          
    movl    %eax, 0(%esp)          

    # function body
    movl    $100, %eax              #   0:     if     100 >= 100 goto 1_if_true
    movl    $100, %ebx             
    cmpl    %ebx, %eax             
    jge     l_test_1_if_true       
    jmp     l_test_2_if_false       #   1:     goto   2_if_false
l_test_1_if_true:
    jmp     l_test_exit            
l_test_6_while_cond:
    movl    $39979, %eax            #   5:     if     39979 > 61680 goto 7_while_body
    movl    $61680, %ebx           
    cmpl    %ebx, %eax             
    jg      l_test_7_while_body    
    jmp     l_test_5                #   6:     goto   5
l_test_7_while_body:
    jmp     l_test_6_while_cond     #   8:     goto   6_while_cond
l_test_5:
    jmp     l_test_0                #  10:     goto   0
l_test_2_if_false:
l_test_0:
    call    dummyCHARfunc           #  13:     call   t0 <- dummyCHARfunc
    movb    %al, -13(%ebp)         
    movzbl  -13(%ebp), %eax         #  14:     assign v0 <- t0
    movb    %al, v0                
    jmp     l_test_exit            
l_test_12_while_cond:
    call    dummyCHARfunc           #  17:     call   t1 <- dummyCHARfunc
    movb    %al, -14(%ebp)         
    movl    $99, %eax               #  18:     if     99 < t1 goto 13_while_body
    movzbl  -14(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_test_13_while_body   
    jmp     l_test_11               #  19:     goto   11
l_test_13_while_body:
    jmp     l_test_12_while_cond    #  21:     goto   12_while_cond
l_test_11:
    call    dummyINTfunc            #  23:     call   t2 <- dummyINTfunc
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #  24:     assign v1 <- t2
    movl    %eax, v1               

l_test_exit:
    # epilogue
    addl    $8, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # end of text section
    #-----------------------------------------

    #-----------------------------------------
    # global data section
    #
    .data
    .align 4

    # scope: test
v0:                                 # <char>
    .skip    1
    .align   4
v1:                                 # <int>
    .skip    4








    # end of global data section
    #-----------------------------------------

    .end
##################################################
