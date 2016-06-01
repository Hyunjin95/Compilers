##################################################
# array06
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
    #      8(%ebp)   4  [ %A        <ptr(4) to <array of <array of <int>>>> %ebp+8 ]
    #    -16(%ebp)   4  [ $M        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $N        <int> %ebp-20 ]
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
    movl    8(%ebp), %eax           #   1:     param  0 <- A
    pushl   %eax                   
    call    DIM                     #   2:     call   t0 <- DIM
    addl    $8, %esp               
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #   3:     assign N <- t0
    movl    %eax, -20(%ebp)        
    movl    $2, %eax                #   4:     param  1 <- 2
    pushl   %eax                   
    movl    8(%ebp), %eax           #   5:     param  0 <- A
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
    movl    8(%ebp), %eax           #  19:     param  0 <- A
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
    movl    8(%ebp), %eax           #  24:     param  0 <- A
    pushl   %eax                   
    call    DOFS                    #  25:     call   t6 <- DOFS
    addl    $4, %esp               
    movl    %eax, -60(%ebp)        
    movl    -56(%ebp), %eax         #  26:     add    t7 <- t5, t6
    movl    -60(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -64(%ebp)        
    movl    8(%ebp), %eax           #  27:     add    t8 <- A, t7
    movl    -64(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -68(%ebp)        
    movl    -68(%ebp), %edi        
    movl    (%edi), %eax            #  28:     param  0 <- @t8
    pushl   %eax                   
    call    WriteInt                #  29:     call   WriteInt
    addl    $4, %esp               
    call    WriteLn                 #  30:     call   WriteLn
    movl    -28(%ebp), %eax         #  31:     add    t9 <- j, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -72(%ebp)        
    movl    -72(%ebp), %eax         #  32:     assign j <- t9
    movl    %eax, -28(%ebp)        
    jmp     l_Print_9_while_cond    #  33:     goto   9_while_cond
l_Print_8:
    movl    -24(%ebp), %eax         #  35:     add    t10 <- i, 1
    movl    $1, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #  36:     assign i <- t10
    movl    %eax, -24(%ebp)        
    jmp     l_Print_4_while_cond    #  37:     goto   4_while_cond
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
    movl    8(%ebp), %eax           #  40:     param  0 <- a
    pushl   %eax                   
    call    Print                   #  41:     call   Print
    addl    $4, %esp               

l_Init_exit:
    # epilogue
    addl    $68, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope Test
Test:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 3 of <array 3 of <int>>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 3 of <array 3 of <int>>>> %ebp-20 ]
    #    -68(%ebp)  48  [ $x        <array 3 of <array 3 of <int>>> %ebp-68 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $56, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $14, %ecx              
    mov     %esp, %edi             
    rep     stosl                  
    movl    $2,-68(%ebp)            # local array 'x': 2 dimensions
    movl    $3,-64(%ebp)            #   dimension 1: 3 elements
    movl    $3,-60(%ebp)            #   dimension 2: 3 elements

    # function body
    movl    $11111111, %eax         #   0:     param  0 <- 11111111
    pushl   %eax                   
    call    WriteInt                #   1:     call   WriteInt
    addl    $4, %esp               
    call    WriteLn                 #   2:     call   WriteLn
    leal    -68(%ebp), %eax         #   3:     &()    t0 <- x
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   4:     param  0 <- t0
    pushl   %eax                   
    call    Print                   #   5:     call   Print
    addl    $4, %esp               
    movl    $22222222, %eax         #   6:     param  0 <- 22222222
    pushl   %eax                   
    call    WriteInt                #   7:     call   WriteInt
    addl    $4, %esp               
    call    WriteLn                 #   8:     call   WriteLn
    leal    -68(%ebp), %eax         #   9:     &()    t1 <- x
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #  10:     param  0 <- t1
    pushl   %eax                   
    call    Init                    #  11:     call   Init
    addl    $4, %esp               

l_Test_exit:
    # epilogue
    addl    $56, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope array06
main:
    # stack offsets:

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body
    call    Test                    #   0:     call   Test

l_array06_exit:
    # epilogue
    addl    $0, %esp                # remove locals
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





    # end of global data section
    #-----------------------------------------

    .end
##################################################
