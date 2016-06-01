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

    # scope hello
hello:
    # stack offsets:
    #      8(%ebp)   4  [ %a        <int> %ebp+8 ]
    #    -32(%ebp)  20  [ $arr      <array 3 of <int>> %ebp-32 ]
    #     12(%ebp)   4  [ %b        <int> %ebp+12 ]
    #     16(%ebp)   1  [ %c        <char> %ebp+16 ]
    #     20(%ebp)   1  [ %d        <char> %ebp+20 ]
    #    -36(%ebp)   4  [ $t0       <ptr(4) to <array 3 of <int>>> %ebp-36 ]
    #    -40(%ebp)   4  [ $t1       <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $t2       <ptr(4) to <array 3 of <int>>> %ebp-44 ]
    #    -48(%ebp)   4  [ $t3       <int> %ebp-48 ]
    #    -52(%ebp)   4  [ $t4       <int> %ebp-52 ]
    #    -56(%ebp)   4  [ $t5       <int> %ebp-56 ]

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
    movl    $1,-32(%ebp)            # local array 'arr': 1 dimensions
    movl    $3,-28(%ebp)            #   dimension 1: 3 elements

    # function body
    leal    -32(%ebp), %eax         #   0:     &()    t0 <- arr
    movl    %eax, -36(%ebp)        
    movl    $2, %eax                #   1:     mul    t1 <- 2, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -40(%ebp)        
    leal    -32(%ebp), %eax         #   2:     &()    t2 <- arr
    movl    %eax, -44(%ebp)        
    movl    -44(%ebp), %eax         #   3:     param  0 <- t2
    pushl   %eax                   
    call    DOFS                   
    addl    $4, %esp               
    movl    %eax, -48(%ebp)        
    movl    -40(%ebp), %eax         #   5:     add    t4 <- t1, t3
    movl    -48(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -52(%ebp)        
    movl    -36(%ebp), %eax         #   6:     add    t5 <- t0, t4
    movl    -52(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -56(%ebp)        
    movl    $77, %eax               #   7:     assign @t5 <- 77
    movl    %eax, arr              

l_hello_exit:
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

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $0, %esp                # make room for locals

    # function body

l_test_exit:
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
