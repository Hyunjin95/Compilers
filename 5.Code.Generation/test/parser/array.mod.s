##################################################
# array
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

    # scope add
add:
    # stack offsets:
    #      8(%ebp)   4  [ %A        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+8 ]
    #     12(%ebp)   4  [ %B        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+12 ]
    #     16(%ebp)   4  [ %C        <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp+16 ]
    #    -16(%ebp)   4  [ $i        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $j        <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t0       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t1       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t10      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t11      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t12      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t13      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t14      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t15      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t16      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t17      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t18      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t19      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t2       <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t20      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t21      <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t3       <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t4       <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t5       <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t6       <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t7       <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t8       <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t9       <int> %ebp-108 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $96, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $24, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $0, %eax                #   0:     assign i <- 0
    movl    %eax, -16(%ebp)        
l_add_2_while_cond:
    movl    -16(%ebp), %eax         #   2:     if     i < 5 goto 3_while_body
    movl    $5, %ebx               
    cmpl    %ebx, %eax             
    jl      l_add_3_while_body     
    jmp     l_add_1                 #   3:     goto   1
l_add_3_while_body:
    movl    $0, %eax                #   5:     assign j <- 0
    movl    %eax, -20(%ebp)        
l_add_7_while_cond:
    movl    -20(%ebp), %eax         #   7:     if     j < 5 goto 8_while_body
    movl    $5, %ebx               
    cmpl    %ebx, %eax             
    jl      l_add_8_while_body     
    jmp     l_add_6                 #   8:     goto   6
l_add_8_while_body:
    movl    $2, %eax                #  10:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  11:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  12:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -24(%ebp)        
    movl    -16(%ebp), %eax         #  13:     mul    t1 <- i, t0
    movl    -24(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #  14:     add    t2 <- t1, j
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %eax         #  15:     mul    t3 <- t2, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -84(%ebp)        
    movl    8(%ebp), %eax           #  16:     param  0 <- A
    pushl   %eax                   
    call    DOFS                    #  17:     call   t4 <- DOFS
    addl    $4, %esp               
    movl    %eax, -88(%ebp)        
    movl    -84(%ebp), %eax         #  18:     add    t5 <- t3, t4
    movl    -88(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -92(%ebp)        
    movl    8(%ebp), %eax           #  19:     add    t6 <- A, t5
    movl    -92(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -96(%ebp)        
    movl    $2, %eax                #  20:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  21:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  22:     call   t7 <- DIM
    addl    $8, %esp               
    movl    %eax, -100(%ebp)       
    movl    -16(%ebp), %eax         #  23:     mul    t8 <- i, t7
    movl    -100(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -104(%ebp)       
    movl    -104(%ebp), %eax        #  24:     add    t9 <- t8, j
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  25:     mul    t10 <- t9, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -32(%ebp)        
    movl    12(%ebp), %eax          #  26:     param  0 <- B
    pushl   %eax                   
    call    DOFS                    #  27:     call   t11 <- DOFS
    addl    $4, %esp               
    movl    %eax, -36(%ebp)        
    movl    -32(%ebp), %eax         #  28:     add    t12 <- t10, t11
    movl    -36(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    12(%ebp), %eax          #  29:     add    t13 <- B, t12
    movl    -40(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -44(%ebp)        
    movl    -96(%ebp), %edi        
    movl    (%edi), %eax            #  30:     add    t14 <- @t6, @t13
    movl    -44(%ebp), %edi        
    movl    (%edi), %ebx           
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    $2, %eax                #  31:     param  1 <- 2
    pushl   %eax                   
    movl    16(%ebp), %eax          #  32:     param  0 <- C
    pushl   %eax                   
    call    DIM                     #  33:     call   t15 <- DIM
    addl    $8, %esp               
    movl    %eax, -52(%ebp)        
    movl    -16(%ebp), %eax         #  34:     mul    t16 <- i, t15
    movl    -52(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         #  35:     add    t17 <- t16, j
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -60(%ebp)        
    movl    -60(%ebp), %eax         #  36:     mul    t18 <- t17, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -64(%ebp)        
    movl    16(%ebp), %eax          #  37:     param  0 <- C
    pushl   %eax                   
    call    DOFS                    #  38:     call   t19 <- DOFS
    addl    $4, %esp               
    movl    %eax, -68(%ebp)        
    movl    -64(%ebp), %eax         #  39:     add    t20 <- t18, t19
    movl    -68(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -76(%ebp)        
    movl    16(%ebp), %eax          #  40:     add    t21 <- C, t20
    movl    -76(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -48(%ebp), %eax         #  41:     assign @t21 <- t14
    movl    -80(%ebp), %edi        
    movl    %eax, (%edi)           
    jmp     l_add_7_while_cond      #  42:     goto   7_while_cond
l_add_6:
    jmp     l_add_2_while_cond      #  44:     goto   2_while_cond
l_add_1:

l_add_exit:
    # epilogue
    addl    $96, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope addB
addB:
    # stack offsets:
    #      8(%ebp)   4  [ %A        <ptr(4) to <array of <array of <int>>>> %ebp+8 ]
    #     12(%ebp)   4  [ %B        <ptr(4) to <array of <array of <int>>>> %ebp+12 ]
    #     16(%ebp)   4  [ %C        <ptr(4) to <array of <array of <int>>>> %ebp+16 ]
    #    -16(%ebp)   4  [ $i        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $j        <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t0       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t1       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t10      <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t11      <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t12      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t13      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t14      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t15      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t16      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t17      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t18      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t19      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t2       <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t20      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t21      <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t3       <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t4       <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t5       <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t6       <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t7       <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t8       <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t9       <int> %ebp-108 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $96, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $24, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $0, %eax                #   0:     assign i <- 0
    movl    %eax, -16(%ebp)        
l_addB_2_while_cond:
    movl    -16(%ebp), %eax         #   2:     if     i < 5 goto 3_while_body
    movl    $5, %ebx               
    cmpl    %ebx, %eax             
    jl      l_addB_3_while_body    
    jmp     l_addB_1                #   3:     goto   1
l_addB_3_while_body:
    movl    $0, %eax                #   5:     assign j <- 0
    movl    %eax, -20(%ebp)        
l_addB_7_while_cond:
    movl    -20(%ebp), %eax         #   7:     if     j < 5 goto 8_while_body
    movl    $5, %ebx               
    cmpl    %ebx, %eax             
    jl      l_addB_8_while_body    
    jmp     l_addB_6                #   8:     goto   6
l_addB_8_while_body:
    movl    $2, %eax                #  10:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  11:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #  12:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -24(%ebp)        
    movl    -16(%ebp), %eax         #  13:     mul    t1 <- i, t0
    movl    -24(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #  14:     add    t2 <- t1, j
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %eax         #  15:     mul    t3 <- t2, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -84(%ebp)        
    movl    8(%ebp), %eax           #  16:     param  0 <- A
    pushl   %eax                   
    call    DOFS                    #  17:     call   t4 <- DOFS
    addl    $4, %esp               
    movl    %eax, -88(%ebp)        
    movl    -84(%ebp), %eax         #  18:     add    t5 <- t3, t4
    movl    -88(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -92(%ebp)        
    movl    8(%ebp), %eax           #  19:     add    t6 <- A, t5
    movl    -92(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -96(%ebp)        
    movl    $2, %eax                #  20:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  21:     param  0 <- B
    pushl   %eax                   
    call    DIM                     #  22:     call   t7 <- DIM
    addl    $8, %esp               
    movl    %eax, -100(%ebp)       
    movl    -16(%ebp), %eax         #  23:     mul    t8 <- i, t7
    movl    -100(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -104(%ebp)       
    movl    -104(%ebp), %eax        #  24:     add    t9 <- t8, j
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  25:     mul    t10 <- t9, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -32(%ebp)        
    movl    12(%ebp), %eax          #  26:     param  0 <- B
    pushl   %eax                   
    call    DOFS                    #  27:     call   t11 <- DOFS
    addl    $4, %esp               
    movl    %eax, -36(%ebp)        
    movl    -32(%ebp), %eax         #  28:     add    t12 <- t10, t11
    movl    -36(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    12(%ebp), %eax          #  29:     add    t13 <- B, t12
    movl    -40(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -44(%ebp)        
    movl    -96(%ebp), %edi        
    movl    (%edi), %eax            #  30:     add    t14 <- @t6, @t13
    movl    -44(%ebp), %edi        
    movl    (%edi), %ebx           
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    $2, %eax                #  31:     param  1 <- 2
    pushl   %eax                   
    movl    16(%ebp), %eax          #  32:     param  0 <- C
    pushl   %eax                   
    call    DIM                     #  33:     call   t15 <- DIM
    addl    $8, %esp               
    movl    %eax, -52(%ebp)        
    movl    -16(%ebp), %eax         #  34:     mul    t16 <- i, t15
    movl    -52(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         #  35:     add    t17 <- t16, j
    movl    -20(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -60(%ebp)        
    movl    -60(%ebp), %eax         #  36:     mul    t18 <- t17, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -64(%ebp)        
    movl    16(%ebp), %eax          #  37:     param  0 <- C
    pushl   %eax                   
    call    DOFS                    #  38:     call   t19 <- DOFS
    addl    $4, %esp               
    movl    %eax, -68(%ebp)        
    movl    -64(%ebp), %eax         #  39:     add    t20 <- t18, t19
    movl    -68(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -76(%ebp)        
    movl    16(%ebp), %eax          #  40:     add    t21 <- C, t20
    movl    -76(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -48(%ebp), %eax         #  41:     assign @t21 <- t14
    movl    -80(%ebp), %edi        
    movl    %eax, (%edi)           
    jmp     l_addB_7_while_cond     #  42:     goto   7_while_cond
l_addB_6:
    jmp     l_addB_2_while_cond     #  44:     goto   2_while_cond
l_addB_1:

l_addB_exit:
    # epilogue
    addl    $96, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope array
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-20 ]
    #    -24(%ebp)   4  [ $t2       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-24 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $12, %esp               # make room for locals

    xorl    %eax, %eax              # memset local stack area to 0
    movl    %eax, 8(%esp)          
    movl    %eax, 4(%esp)          
    movl    %eax, 0(%esp)          

    # function body
    leal    c, %eax                 #   0:     &()    t0 <- c
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   1:     param  2 <- t0
    pushl   %eax                   
    leal    b, %eax                 #   2:     &()    t1 <- b
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   3:     param  1 <- t1
    pushl   %eax                   
    leal    a, %eax                 #   4:     &()    t2 <- a
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #   5:     param  0 <- t2
    pushl   %eax                   
    call    add                     #   6:     call   add
    addl    $12, %esp              

l_array_exit:
    # epilogue
    addl    $12, %esp               # remove locals
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

    # scope: array
a:                                  # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100
b:                                  # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100
c:                                  # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100



    # end of global data section
    #-----------------------------------------

    .end
##################################################
