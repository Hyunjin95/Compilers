##################################################
# array07
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

    # scope Print
Print:
    # stack offsets:
    #    -16(%ebp)   4  [ $M        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $N        <int> %ebp-20 ]
    #      8(%ebp)   4  [ %a        <ptr(4) to <array of <array of <int>>>> %ebp+8 ]
    #    -24(%ebp)   4  [ $i        <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $j        <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t0       <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t1       <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t10      <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t2       <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t3       <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t4       <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t5       <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t6       <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t7       <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t8       <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t9       <int> %ebp-72 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $60, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $15, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $1, %eax                #   0:     param  1 <- 1
    pushl   %eax                   
    movl    8(%ebp), %eax           #   1:     param  0 <- a
    pushl   %eax                   
    call    DIM                     #   2:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #   3:     assign N <- t0
    movl    %eax, -20(%ebp)        
    movl    $2, %eax                #   4:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #   5:     param  0 <- a
    pushl   %eax                   
    call    DIM                     #   6:     call   t1 <- DIM
    addl    $8, %esp               
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #   7:     assign M <- t1
    movl    %eax, -16(%ebp)        
    movl    $0, %eax                #   8:     assign i <- 0
    movl    %eax, -24(%ebp)        
l_Print_4_while_cond:
    movl    -24(%ebp), %eax         #  10:     if     i < N goto 5_while_body
    movl    -20(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_Print_5_while_body   
    jmp     l_Print_3               #  11:     goto   3
l_Print_5_while_body:
    movl    $0, %eax                #  13:     assign j <- 0
    movl    %eax, -28(%ebp)        
l_Print_9_while_cond:
    movl    -28(%ebp), %eax         #  15:     if     j < M goto 10_while_body
    movl    -16(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_Print_10_while_body  
    jmp     l_Print_8               #  16:     goto   8
l_Print_10_while_body:
    movl    $2, %eax                #  18:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  19:     param  0 <- a
    pushl   %eax                   
    call    DIM                     #  20:     call   t2 <- DIM
    addl    $8, %esp               
    movl    %eax, -44(%ebp)        
    movl    -24(%ebp), %eax         #  21:     mul    t3 <- i, t2
    movl    -44(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  22:     add    t4 <- t3, j
    movl    -28(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    -52(%ebp), %eax         #  23:     mul    t5 <- t4, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -56(%ebp)        
    movl    8(%ebp), %eax           #  24:     param  0 <- a
    pushl   %eax                   
    call    DOFS                    #  25:     call   t6 <- DOFS
    addl    $4, %esp               
    movl    %eax, -60(%ebp)        
    movl    -56(%ebp), %eax         #  26:     add    t7 <- t5, t6
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    8(%ebp), %eax           #  27:     add    t8 <- a, t7
    movl    -64(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %edi        
    movl    (%edi), %eax            #  28:     param  0 <- @t8
    pushl   %eax                   
    call    WriteInt                #  29:     call   WriteInt
    addl    $4, %esp               
    movl    -28(%ebp), %eax         #  30:     add    t9 <- j, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %eax         #  31:     assign j <- t9
    movl    %eax, -28(%ebp)        
    jmp     l_Print_9_while_cond    #  32:     goto   9_while_cond
l_Print_8:
    movl    -24(%ebp), %eax         #  34:     add    t10 <- i, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #  35:     assign i <- t10
    movl    %eax, -24(%ebp)        
    jmp     l_Print_4_while_cond    #  36:     goto   4_while_cond
l_Print_3:

l_Print_exit:
    # epilogue
    addl    $60, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope Init
Init:
    # stack offsets:
    #    -16(%ebp)   4  [ $M        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $N        <int> %ebp-20 ]
    #      8(%ebp)   4  [ %a        <ptr(4) to <array of <array of <int>>>> %ebp+8 ]
    #    -24(%ebp)   4  [ $c        <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $i        <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $j        <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t0       <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t1       <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t10      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t11      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t2       <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t3       <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t4       <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t5       <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t6       <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t7       <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t8       <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t9       <int> %ebp-80 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $68, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $17, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $1, %eax                #   0:     param  1 <- 1
    pushl   %eax                   
    movl    8(%ebp), %eax           #   1:     param  0 <- a
    pushl   %eax                   
    call    DIM                     #   2:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #   3:     assign N <- t0
    movl    %eax, -20(%ebp)        
    movl    $2, %eax                #   4:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #   5:     param  0 <- a
    pushl   %eax                   
    call    DIM                     #   6:     call   t1 <- DIM
    addl    $8, %esp               
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #   7:     assign M <- t1
    movl    %eax, -16(%ebp)        
    movl    $0, %eax                #   8:     assign c <- 0
    movl    %eax, -24(%ebp)        
    movl    $0, %eax                #   9:     assign i <- 0
    movl    %eax, -28(%ebp)        
l_Init_5_while_cond:
    movl    -28(%ebp), %eax         #  11:     if     i < N goto 6_while_body
    movl    -20(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_Init_6_while_body    
    jmp     l_Init_4                #  12:     goto   4
l_Init_6_while_body:
    movl    $0, %eax                #  14:     assign j <- 0
    movl    %eax, -32(%ebp)        
l_Init_10_while_cond:
    movl    -32(%ebp), %eax         #  16:     if     j < M goto 11_while_body
    movl    -16(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_Init_11_while_body   
    jmp     l_Init_9                #  17:     goto   9
l_Init_11_while_body:
    movl    $2, %eax                #  19:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  20:     param  0 <- a
    pushl   %eax                   
    call    DIM                     #  21:     call   t2 <- DIM
    addl    $8, %esp               
    movl    %eax, -52(%ebp)        
    movl    -28(%ebp), %eax         #  22:     mul    t3 <- i, t2
    movl    -52(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -56(%ebp)        
    movl    -56(%ebp), %eax         #  23:     add    t4 <- t3, j
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -60(%ebp)        
    movl    -60(%ebp), %eax         #  24:     mul    t5 <- t4, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -64(%ebp)        
    movl    8(%ebp), %eax           #  25:     param  0 <- a
    pushl   %eax                   
    call    DOFS                    #  26:     call   t6 <- DOFS
    addl    $4, %esp               
    movl    %eax, -68(%ebp)        
    movl    -64(%ebp), %eax         #  27:     add    t7 <- t5, t6
    movl    -68(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -72(%ebp)        
    movl    8(%ebp), %eax           #  28:     add    t8 <- a, t7
    movl    -72(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -76(%ebp)        
    movl    -24(%ebp), %eax         #  29:     assign @t8 <- c
    movl    -76(%ebp), %edi        
    movl    %eax, (%edi)           
    movl    -24(%ebp), %eax         #  30:     add    t9 <- c, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -80(%ebp), %eax         #  31:     assign c <- t9
    movl    %eax, -24(%ebp)        
    movl    -32(%ebp), %eax         #  32:     add    t10 <- j, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #  33:     assign j <- t10
    movl    %eax, -32(%ebp)        
    jmp     l_Init_10_while_cond    #  34:     goto   10_while_cond
l_Init_9:
    movl    -28(%ebp), %eax         #  36:     add    t11 <- i, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  37:     assign i <- t11
    movl    %eax, -28(%ebp)        
    jmp     l_Init_5_while_cond     #  38:     goto   5_while_cond
l_Init_4:

l_Init_exit:
    # epilogue
    addl    $68, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope Add
Add:
    # stack offsets:
    #    -16(%ebp)   4  [ $M        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $N        <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $c        <int> %ebp-24 ]
    #     16(%ebp)   4  [ %d        <ptr(4) to <array of <array of <int>>>> %ebp+16 ]
    #    -28(%ebp)   4  [ $i        <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $j        <int> %ebp-32 ]
    #      8(%ebp)   4  [ %s1       <ptr(4) to <array of <array of <int>>>> %ebp+8 ]
    #     12(%ebp)   4  [ %s2       <ptr(4) to <array of <array of <int>>>> %ebp+12 ]
    #    -36(%ebp)   4  [ $t0       <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t1       <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t10      <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t11      <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t12      <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t13      <int> %ebp-56 ]
    #    -60(%ebp)   4  [ $t14      <int> %ebp-60 ]
    #    -64(%ebp)   4  [ $t15      <int> %ebp-64 ]
    #    -68(%ebp)   4  [ $t16      <int> %ebp-68 ]
    #    -72(%ebp)   4  [ $t17      <int> %ebp-72 ]
    #    -76(%ebp)   4  [ $t18      <int> %ebp-76 ]
    #    -80(%ebp)   4  [ $t19      <int> %ebp-80 ]
    #    -84(%ebp)   4  [ $t2       <int> %ebp-84 ]
    #    -88(%ebp)   4  [ $t20      <int> %ebp-88 ]
    #    -92(%ebp)   4  [ $t21      <int> %ebp-92 ]
    #    -96(%ebp)   4  [ $t22      <int> %ebp-96 ]
    #   -100(%ebp)   4  [ $t23      <int> %ebp-100 ]
    #   -104(%ebp)   4  [ $t24      <int> %ebp-104 ]
    #   -108(%ebp)   4  [ $t25      <int> %ebp-108 ]
    #   -112(%ebp)   4  [ $t26      <int> %ebp-112 ]
    #   -116(%ebp)   4  [ $t3       <int> %ebp-116 ]
    #   -120(%ebp)   4  [ $t4       <int> %ebp-120 ]
    #   -124(%ebp)   4  [ $t5       <int> %ebp-124 ]
    #   -128(%ebp)   4  [ $t6       <int> %ebp-128 ]
    #   -132(%ebp)   4  [ $t7       <int> %ebp-132 ]
    #   -136(%ebp)   4  [ $t8       <int> %ebp-136 ]
    #   -140(%ebp)   4  [ $t9       <int> %ebp-140 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $128, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $32, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    $1, %eax                #   0:     param  1 <- 1
    pushl   %eax                   
    movl    16(%ebp), %eax          #   1:     param  0 <- d
    pushl   %eax                   
    call    DIM                     #   2:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #   3:     assign N <- t0
    movl    %eax, -20(%ebp)        
    movl    $2, %eax                #   4:     param  1 <- 2
    pushl   %eax                   
    movl    16(%ebp), %eax          #   5:     param  0 <- d
    pushl   %eax                   
    call    DIM                     #   6:     call   t1 <- DIM
    addl    $8, %esp               
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #   7:     assign M <- t1
    movl    %eax, -16(%ebp)        
    movl    $0, %eax                #   8:     assign c <- 0
    movl    %eax, -24(%ebp)        
    movl    $0, %eax                #   9:     assign i <- 0
    movl    %eax, -28(%ebp)        
l_Add_5_while_cond:
    movl    -28(%ebp), %eax         #  11:     if     i < N goto 6_while_body
    movl    -20(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_Add_6_while_body     
    jmp     l_Add_4                 #  12:     goto   4
l_Add_6_while_body:
    movl    $0, %eax                #  14:     assign j <- 0
    movl    %eax, -32(%ebp)        
l_Add_10_while_cond:
    movl    -32(%ebp), %eax         #  16:     if     j < M goto 11_while_body
    movl    -16(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jl      l_Add_11_while_body    
    jmp     l_Add_9                 #  17:     goto   9
l_Add_11_while_body:
    movl    $2, %eax                #  19:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #  20:     param  0 <- s1
    pushl   %eax                   
    call    DIM                     #  21:     call   t2 <- DIM
    addl    $8, %esp               
    movl    %eax, -84(%ebp)        
    movl    -28(%ebp), %eax         #  22:     mul    t3 <- i, t2
    movl    -84(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -116(%ebp)       
    movl    -116(%ebp), %eax        #  23:     add    t4 <- t3, j
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -120(%ebp)       
    movl    -120(%ebp), %eax        #  24:     mul    t5 <- t4, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -124(%ebp)       
    movl    8(%ebp), %eax           #  25:     param  0 <- s1
    pushl   %eax                   
    call    DOFS                    #  26:     call   t6 <- DOFS
    addl    $4, %esp               
    movl    %eax, -128(%ebp)       
    movl    -124(%ebp), %eax        #  27:     add    t7 <- t5, t6
    movl    -128(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -132(%ebp)       
    movl    8(%ebp), %eax           #  28:     add    t8 <- s1, t7
    movl    -132(%ebp), %ebx       
    addl    %ebx, %eax             
    movl    %eax, -136(%ebp)       
    movl    $2, %eax                #  29:     param  1 <- 2
    pushl   %eax                   
    movl    12(%ebp), %eax          #  30:     param  0 <- s2
    pushl   %eax                   
    call    DIM                     #  31:     call   t9 <- DIM
    addl    $8, %esp               
    movl    %eax, -140(%ebp)       
    movl    -28(%ebp), %eax         #  32:     mul    t10 <- i, t9
    movl    -140(%ebp), %ebx       
    imull   %ebx                   
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #  33:     add    t11 <- t10, j
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -48(%ebp), %eax         #  34:     mul    t12 <- t11, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -52(%ebp)        
    movl    12(%ebp), %eax          #  35:     param  0 <- s2
    pushl   %eax                   
    call    DOFS                    #  36:     call   t13 <- DOFS
    addl    $4, %esp               
    movl    %eax, -56(%ebp)        
    movl    -52(%ebp), %eax         #  37:     add    t14 <- t12, t13
    movl    -56(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -60(%ebp)        
    movl    12(%ebp), %eax          #  38:     add    t15 <- s2, t14
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    -136(%ebp), %edi       
    movl    (%edi), %eax            #  39:     add    t16 <- @t8, @t15
    movl    -64(%ebp), %edi        
    movl    (%edi), %ebx           
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    $2, %eax                #  40:     param  1 <- 2
    pushl   %eax                   
    movl    16(%ebp), %eax          #  41:     param  0 <- d
    pushl   %eax                   
    call    DIM                     #  42:     call   t17 <- DIM
    addl    $8, %esp               
    movl    %eax, -72(%ebp)        
    movl    -28(%ebp), %eax         #  43:     mul    t18 <- i, t17
    movl    -72(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -76(%ebp)        
    movl    -76(%ebp), %eax         #  44:     add    t19 <- t18, j
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -80(%ebp)        
    movl    -80(%ebp), %eax         #  45:     mul    t20 <- t19, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -88(%ebp)        
    movl    16(%ebp), %eax          #  46:     param  0 <- d
    pushl   %eax                   
    call    DOFS                    #  47:     call   t21 <- DOFS
    addl    $4, %esp               
    movl    %eax, -92(%ebp)        
    movl    -88(%ebp), %eax         #  48:     add    t22 <- t20, t21
    movl    -92(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -96(%ebp)        
    movl    16(%ebp), %eax          #  49:     add    t23 <- d, t22
    movl    -96(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -100(%ebp)       
    movl    -68(%ebp), %eax         #  50:     assign @t23 <- t16
    movl    -100(%ebp), %edi       
    movl    %eax, (%edi)           
    movl    -24(%ebp), %eax         #  51:     add    t24 <- c, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -104(%ebp)       
    movl    -104(%ebp), %eax        #  52:     assign c <- t24
    movl    %eax, -24(%ebp)        
    movl    -32(%ebp), %eax         #  53:     add    t25 <- j, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -108(%ebp)       
    movl    -108(%ebp), %eax        #  54:     assign j <- t25
    movl    %eax, -32(%ebp)        
    jmp     l_Add_10_while_cond     #  55:     goto   10_while_cond
l_Add_9:
    movl    -28(%ebp), %eax         #  57:     add    t26 <- i, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -112(%ebp)       
    movl    -112(%ebp), %eax        #  58:     assign i <- t26
    movl    %eax, -28(%ebp)        
    jmp     l_Add_5_while_cond      #  59:     goto   5_while_cond
l_Add_4:

l_Add_exit:
    # epilogue
    addl    $128, %esp              # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope Test
Test:
    # stack offsets:
    #   -124(%ebp)  112  [ $a        <array 5 of <array 5 of <int>>> %ebp-124 ]
    #   -236(%ebp)  112  [ $b        <array 5 of <array 5 of <int>>> %ebp-236 ]
    #   -264(%ebp)  28  [ $c        <array 5 of <int>> %ebp-264 ]
    #   -268(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-268 ]
    #   -272(%ebp)   4  [ $t1       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-272 ]
    #   -276(%ebp)   4  [ $t2       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-276 ]
    #   -280(%ebp)   4  [ $t3       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-280 ]
    #   -284(%ebp)   4  [ $t4       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-284 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $272, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $68, %ecx              
    mov     %esp, %edi             
    rep     stosl                  
    movl    $2,-124(%ebp)           # local array 'a': 2 dimensions
    movl    $5,-120(%ebp)           #   dimension 1: 5 elements
    movl    $5,-116(%ebp)           #   dimension 2: 5 elements
    movl    $2,-236(%ebp)           # local array 'b': 2 dimensions
    movl    $5,-232(%ebp)           #   dimension 1: 5 elements
    movl    $5,-228(%ebp)           #   dimension 2: 5 elements
    movl    $1,-264(%ebp)           # local array 'c': 1 dimensions
    movl    $5,-260(%ebp)           #   dimension 1: 5 elements

    # function body
    leal    -124(%ebp), %eax        #   0:     &()    t0 <- a
    movl    %eax, -268(%ebp)       
    movl    -268(%ebp), %eax        #   1:     param  0 <- t0
    pushl   %eax                   
    call    Init                    #   2:     call   Init
    addl    $4, %esp               
    leal    -236(%ebp), %eax        #   3:     &()    t1 <- b
    movl    %eax, -272(%ebp)       
    movl    -272(%ebp), %eax        #   4:     param  0 <- t1
    pushl   %eax                   
    call    Init                    #   5:     call   Init
    addl    $4, %esp               
    leal    sum, %eax               #   6:     &()    t2 <- sum
    movl    %eax, -276(%ebp)       
    movl    -276(%ebp), %eax        #   7:     param  2 <- t2
    pushl   %eax                   
    leal    -236(%ebp), %eax        #   8:     &()    t3 <- b
    movl    %eax, -280(%ebp)       
    movl    -280(%ebp), %eax        #   9:     param  1 <- t3
    pushl   %eax                   
    leal    -124(%ebp), %eax        #  10:     &()    t4 <- a
    movl    %eax, -284(%ebp)       
    movl    -284(%ebp), %eax        #  11:     param  0 <- t4
    pushl   %eax                   
    call    Add                     #  12:     call   Add
    addl    $12, %esp              

l_Test_exit:
    # epilogue
    addl    $272, %esp              # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope array07
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <array 5 of <int>>>> %ebp-16 ]

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
    call    Test                    #   0:     call   Test
    leal    sum, %eax               #   1:     &()    t0 <- sum
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   2:     param  0 <- t0
    pushl   %eax                   
    call    Print                   #   3:     call   Print
    addl    $4, %esp               

l_array07_exit:
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

    # scope: array07
sum:                                # <array 5 of <array 5 of <int>>>
    .long    2
    .long    5
    .long    5
    .skip  100





    # end of global data section
    #-----------------------------------------

    .end
##################################################
