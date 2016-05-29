##################################################
# a
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

    # scope hello
hello:
    # stack offsets:
    #      8(%ebp)   4  [ %b        <int> %ebp+8 ]
    #    -13(%ebp)   1  [ $i        <char> %ebp-13 ]
    #     12(%ebp)   4  [ %t        <ptr(4) to <array 3 of <bool>>> %ebp+12 ]

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

l_hello_exit:
    # epilogue
    addl    $4, %esp                # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope a
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 5 of <array 3 of <int>>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <ptr(4) to <array 5 of <array 3 of <int>>>> %ebp-20 ]
    #    -24(%ebp)   4  [ $t2       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t3       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t4       <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t5       <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t6       <ptr(4) to <array 5 of <array 3 of <int>>>> %ebp-40 ]
    #    -44(%ebp)   4  [ $t7       <int> %ebp-44 ]
    #    -48(%ebp)   4  [ $t8       <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t9       <int> %ebp-52 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $40, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $10, %ecx              
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    leal    a, %eax                 #   0:     &()    t0 <- a
    movl    %eax, -16(%ebp)        
    movl    $2, %eax                #   1:     param  1 <- 2
    pushl   %eax                   
    leal    a, %eax                 #   2:     &()    t1 <- a
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   3:     param  0 <- t1
    pushl   %eax                   
    call    DIM                     #   4:     call   t2 <- DIM
    addl    $8, %esp               
    movl    %eax, -24(%ebp)        
    movl    $3, %eax                #   5:     mul    t3 <- 3, t2
    movl    -24(%ebp), %ebx        
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #   6:     add    t4 <- t3, 2
    movl    $2, %ebx               
    addl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #   7:     mul    t5 <- t4, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -36(%ebp)        
    leal    a, %eax                 #   8:     &()    t6 <- a
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #   9:     param  0 <- t6
    pushl   %eax                   
    call    DOFS                    #  10:     call   t7 <- DOFS
    addl    $4, %esp               
    movl    %eax, -44(%ebp)        
    movl    -36(%ebp), %eax         #  11:     add    t8 <- t5, t7
    movl    -44(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -48(%ebp)        
    movl    -16(%ebp), %eax         #  12:     add    t9 <- t0, t8
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    $-3, %eax               #  13:     assign @t9 <- -3
    movl    -52(%ebp), %edi        
    movl    %eax, (%edi)           

l_a_exit:
    # epilogue
    addl    $40, %esp               # remove locals
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

    # scope: a
a:                                  # <array 5 of <array 3 of <int>>>
    .long    2
    .long    5
    .long    3
    .skip   60


    # end of global data section
    #-----------------------------------------

    .end
##################################################
