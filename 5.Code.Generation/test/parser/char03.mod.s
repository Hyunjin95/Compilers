##################################################
# char03
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

    # scope PrintInt
PrintInt:
    # stack offsets:
    #    -16(%ebp)   4  [ $r        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t0       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t1       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t2       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t3       <int> %ebp-32 ]
    #      8(%ebp)   4  [ %v        <int> %ebp+8 ]

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
    movl    8(%ebp), %eax           #   0:     div    t0 <- v, 10
    movl    $10, %ebx              
    cdq                            
    idivl   %ebx                   
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   1:     mul    t1 <- t0, 10
    movl    $10, %ebx              
    imull   %ebx                   
    movl    %eax, -24(%ebp)        
    movl    8(%ebp), %eax           #   2:     sub    t2 <- v, t1
    movl    -24(%ebp), %ebx        
    subl    %ebx, %eax             
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #   3:     assign r <- t2
    movl    %eax, -16(%ebp)        
    movl    8(%ebp), %eax           #   4:     div    t3 <- v, 10
    movl    $10, %ebx              
    cdq                            
    idivl   %ebx                   
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #   5:     assign v <- t3
    movl    %eax, 8(%ebp)          
    movl    8(%ebp), %eax           #   6:     if     v > 0 goto 3_if_true
    movl    $0, %ebx               
    cmpl    %ebx, %eax             
    jg      l_PrintInt_3_if_true   
    jmp     l_PrintInt_4_if_false   #   7:     goto   4_if_false
l_PrintInt_3_if_true:
    movl    8(%ebp), %eax           #   9:     param  0 <- v
    pushl   %eax                   
    call    PrintInt                #  10:     call   PrintInt
    addl    $4, %esp               
    jmp     l_PrintInt_2            #  11:     goto   2
l_PrintInt_4_if_false:
l_PrintInt_2:
    movl    -16(%ebp), %eax         #  14:     if     r = 0 goto 8_if_true
    movl    $0, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_8_if_true   
    jmp     l_PrintInt_9_if_false   #  15:     goto   9_if_false
l_PrintInt_8_if_true:
    movl    $48, %eax               #  17:     param  0 <- 48
    pushl   %eax                   
    call    WriteChar               #  18:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_7            #  19:     goto   7
l_PrintInt_9_if_false:
l_PrintInt_7:
    movl    -16(%ebp), %eax         #  22:     if     r = 1 goto 13_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_13_if_true  
    jmp     l_PrintInt_14_if_false  #  23:     goto   14_if_false
l_PrintInt_13_if_true:
    movl    $49, %eax               #  25:     param  0 <- 49
    pushl   %eax                   
    call    WriteChar               #  26:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_12           #  27:     goto   12
l_PrintInt_14_if_false:
l_PrintInt_12:
    movl    -16(%ebp), %eax         #  30:     if     r = 2 goto 18_if_true
    movl    $2, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_18_if_true  
    jmp     l_PrintInt_19_if_false  #  31:     goto   19_if_false
l_PrintInt_18_if_true:
    movl    $50, %eax               #  33:     param  0 <- 50
    pushl   %eax                   
    call    WriteChar               #  34:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_17           #  35:     goto   17
l_PrintInt_19_if_false:
l_PrintInt_17:
    movl    -16(%ebp), %eax         #  38:     if     r = 3 goto 23_if_true
    movl    $3, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_23_if_true  
    jmp     l_PrintInt_24_if_false  #  39:     goto   24_if_false
l_PrintInt_23_if_true:
    movl    $51, %eax               #  41:     param  0 <- 51
    pushl   %eax                   
    call    WriteChar               #  42:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_22           #  43:     goto   22
l_PrintInt_24_if_false:
l_PrintInt_22:
    movl    -16(%ebp), %eax         #  46:     if     r = 4 goto 28_if_true
    movl    $4, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_28_if_true  
    jmp     l_PrintInt_29_if_false  #  47:     goto   29_if_false
l_PrintInt_28_if_true:
    movl    $52, %eax               #  49:     param  0 <- 52
    pushl   %eax                   
    call    WriteChar               #  50:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_27           #  51:     goto   27
l_PrintInt_29_if_false:
l_PrintInt_27:
    movl    -16(%ebp), %eax         #  54:     if     r = 5 goto 33_if_true
    movl    $5, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_33_if_true  
    jmp     l_PrintInt_34_if_false  #  55:     goto   34_if_false
l_PrintInt_33_if_true:
    movl    $53, %eax               #  57:     param  0 <- 53
    pushl   %eax                   
    call    WriteChar               #  58:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_32           #  59:     goto   32
l_PrintInt_34_if_false:
l_PrintInt_32:
    movl    -16(%ebp), %eax         #  62:     if     r = 6 goto 38_if_true
    movl    $6, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_38_if_true  
    jmp     l_PrintInt_39_if_false  #  63:     goto   39_if_false
l_PrintInt_38_if_true:
    movl    $54, %eax               #  65:     param  0 <- 54
    pushl   %eax                   
    call    WriteChar               #  66:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_37           #  67:     goto   37
l_PrintInt_39_if_false:
l_PrintInt_37:
    movl    -16(%ebp), %eax         #  70:     if     r = 7 goto 43_if_true
    movl    $7, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_43_if_true  
    jmp     l_PrintInt_44_if_false  #  71:     goto   44_if_false
l_PrintInt_43_if_true:
    movl    $55, %eax               #  73:     param  0 <- 55
    pushl   %eax                   
    call    WriteChar               #  74:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_42           #  75:     goto   42
l_PrintInt_44_if_false:
l_PrintInt_42:
    movl    -16(%ebp), %eax         #  78:     if     r = 8 goto 48_if_true
    movl    $8, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_48_if_true  
    jmp     l_PrintInt_49_if_false  #  79:     goto   49_if_false
l_PrintInt_48_if_true:
    movl    $56, %eax               #  81:     param  0 <- 56
    pushl   %eax                   
    call    WriteChar               #  82:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_47           #  83:     goto   47
l_PrintInt_49_if_false:
l_PrintInt_47:
    movl    -16(%ebp), %eax         #  86:     if     r = 9 goto 53_if_true
    movl    $9, %ebx               
    cmpl    %ebx, %eax             
    je      l_PrintInt_53_if_true  
    jmp     l_PrintInt_54_if_false  #  87:     goto   54_if_false
l_PrintInt_53_if_true:
    movl    $57, %eax               #  89:     param  0 <- 57
    pushl   %eax                   
    call    WriteChar               #  90:     call   WriteChar
    addl    $4, %esp               
    jmp     l_PrintInt_52           #  91:     goto   52
l_PrintInt_54_if_false:
l_PrintInt_52:

l_PrintInt_exit:
    # epilogue
    addl    $20, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope char03
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]

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
    movl    $1, %eax                #   0:     assign i <- 1
    movl    %eax, i                
l_char03_2_while_cond:
    movl    i, %eax                 #   2:     if     i # 0 goto 3_while_body
    movl    $0, %ebx               
    cmpl    %ebx, %eax             
    jne     l_char03_3_while_body  
    jmp     l_char03_1              #   3:     goto   1
l_char03_3_while_body:
    call    ReadInt                 #   5:     call   t0 <- ReadInt
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   6:     assign i <- t0
    movl    %eax, i                
    movl    i, %eax                 #   7:     param  0 <- i
    pushl   %eax                   
    call    PrintInt                #   8:     call   PrintInt
    addl    $4, %esp               
    call    WriteLn                 #   9:     call   WriteLn
    jmp     l_char03_2_while_cond   #  10:     goto   2_while_cond
l_char03_1:

l_char03_exit:
    # epilogue
    addl    $4, %esp                # remove locals
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

    # scope: char03
i:                                  # <int>
    .skip    4


    # end of global data section
    #-----------------------------------------

    .end
##################################################
