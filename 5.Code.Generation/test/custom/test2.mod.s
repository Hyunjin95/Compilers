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

    # scope foo
foo:
    # stack offsets:
    #    -16(%ebp)   4  [ $t11      <ptr(4) to <array 100 of <array 100 of <int>>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t12      <ptr(4) to <array 100 of <array 100 of <int>>>> %ebp-20 ]
    #    -24(%ebp)   4  [ $t13      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t14      <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t15      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t16      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t17      <ptr(4) to <array 100 of <array 100 of <int>>>> %ebp-40 ]
    #    -44(%ebp)   4  [ $t18      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t19      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t20      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $v        <int> %ebp-56 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $44, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $11, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    -56(%ebp), %eax         #   0:     if     v < v goto 3
    movl    -56(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_foo_3                
    jmp     l_foo_2_if_false        #   1:     goto   2_if_false
l_foo_3:
    leal    a, %eax                 #   3:     &()    t11 <- a
    movl    %eax, -16(%ebp)        
    movl    $2, %eax                #   4:     param  1 <- 2
    pushl   %eax                   
    leal    a, %eax                 #   5:     &()    t12 <- a
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   6:     param  0 <- t12
    pushl   %eax                   
    call    DIM                     #   7:     call   t13 <- DIM
    addl    $8, %esp               
    movl    %eax, -24(%ebp)        
    movl    -56(%ebp), %eax         #   8:     mul    t14 <- v, t13
    movl    -24(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #   9:     add    t15 <- t14, v
    movl    -56(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #  10:     mul    t16 <- t15, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -36(%ebp)        
    leal    a, %eax                 #  11:     &()    t17 <- a
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #  12:     param  0 <- t17
    pushl   %eax                   
    call    DOFS                    #  13:     call   t18 <- DOFS
    addl    $4, %esp               
    movl    %eax, -44(%ebp)        
    movl    -36(%ebp), %eax         #  14:     add    t19 <- t16, t18
    movl    -44(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -16(%ebp), %eax         #  15:     add    t20 <- t11, t19
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    -56(%ebp), %eax         #  16:     if     v > @t20 goto 1_if_true
    movl    -52(%ebp), %edi        
    movl    (%edi), %ebx           
    cmpl    %ebx, %eax             
    jg      l_foo_1_if_true        
    jmp     l_foo_2_if_false        #  17:     goto   2_if_false
l_foo_1_if_true:
    jmp     l_foo_0                 #  19:     goto   0
l_foo_2_if_false:
l_foo_0:
    movl    t, %eax                 #  22:     return t
    jmp     l_foo_exit             

l_foo_exit:
    # epilogue
    addl    $44, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope test
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 100 of <array 100 of <int>>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 100 of <array 100 of <int>>>> %ebp-20 ]
    #    -24(%ebp)   4  [ $t10      <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t2       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t3       <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t4       <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t5       <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t6       <ptr(4) to <array 100 of <array 100 of <int>>>> %ebp-44 ]
    #    -48(%ebp)   4  [ $t7       <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t8       <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t9       <int> %ebp-56 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $44, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $11, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $999, %eax              #   0:     assign t <- 999
    movl    %eax, t                
    movl    t, %eax                 #   1:     if     t < t goto 4
    movl    t, %ebx                
    cmpl    %ebx, %eax             
    jl      l_test_4               
    jmp     l_test_3_if_false       #   2:     goto   3_if_false
l_test_4:
    leal    a, %eax                 #   4:     &()    t0 <- a
    movl    %eax, -16(%ebp)        
    movl    $2, %eax                #   5:     param  1 <- 2
    pushl   %eax                   
    leal    a, %eax                 #   6:     &()    t1 <- a
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   7:     param  0 <- t1
    pushl   %eax                   
    call    DIM                     #   8:     call   t2 <- DIM
    addl    $8, %esp               
    movl    %eax, -28(%ebp)        
    movl    t, %eax                 #   9:     mul    t3 <- t, t2
    movl    -28(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #  10:     add    t4 <- t3, t
    movl    t, %ebx                
    addl    %ebx, %eax             
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #  11:     mul    t5 <- t4, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -40(%ebp)        
    leal    a, %eax                 #  12:     &()    t6 <- a
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #  13:     param  0 <- t6
    pushl   %eax                   
    call    DOFS                    #  14:     call   t7 <- DOFS
    addl    $4, %esp               
    movl    %eax, -48(%ebp)        
    movl    -40(%ebp), %eax         #  15:     add    t8 <- t5, t7
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    -16(%ebp), %eax         #  16:     add    t9 <- t0, t8
    movl    -52(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -56(%ebp)        
    movl    t, %eax                 #  17:     if     t > @t9 goto 2_if_true
    movl    -56(%ebp), %edi        
    movl    (%edi), %ebx           
    cmpl    %ebx, %eax             
    jg      l_test_2_if_true       
    jmp     l_test_3_if_false       #  18:     goto   3_if_false
l_test_2_if_true:
    jmp     l_test_1                #  20:     goto   1
l_test_3_if_false:
l_test_1:
    movl    t, %eax                 #  23:     param  0 <- t
    pushl   %eax                   
    call    WriteInt                #  24:     call   WriteInt
    addl    $4, %esp               
    call    foo                     #  25:     call   t10 <- foo
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #  26:     param  0 <- t10
    pushl   %eax                   
    call    WriteInt                #  27:     call   WriteInt
    addl    $4, %esp               

l_test_exit:
    # epilogue
    addl    $44, %esp               # remove locals
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
a:                                  # <array 100 of <array 100 of <int>>>
    .long    2
    .long  100
    .long  100
    .skip 40000
t:                                  # <int>
    .skip    4


    # end of global data section
    #-----------------------------------------

    .end
##################################################
