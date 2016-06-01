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
    #      8(%ebp)   4  [ %a        <ptr(4) to <array 3 of <int>>> %ebp+8 ]
    #    -24(%ebp)   9  [ $arr      <array 1 of <char>> %ebp-24 ]
    #     12(%ebp)   4  [ %b        <ptr(4) to <array 3 of <int>>> %ebp+12 ]
    #     16(%ebp)   1  [ %c        <char> %ebp+16 ]
    #     20(%ebp)   1  [ %d        <char> %ebp+20 ]
    #    -28(%ebp)   4  [ $t0       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t1       <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t2       <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $t3       <int> %ebp-40 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $28, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $7, %ecx               
    mov     %esp, %edi             
    rep     stosl                  
    movl    $1,-24(%ebp)            # local array 'arr': 1 dimensions
    movl    $1,-20(%ebp)            #   dimension 1: 1 elements

    # function body
    movl    $0, %eax                #   0:     mul    t0 <- 0, 4
    movl    $4, %ebx               
    imull   %ebx                   
    movl    %eax, -28(%ebp)        
    movl    8(%ebp), %eax           #   1:     param  0 <- a
    pushl   %eax                   
    call    DOFS                    #   2:     call   t1 <- DOFS
    addl    $4, %esp               
    movl    %eax, -32(%ebp)        
    movl    -28(%ebp), %eax         #   3:     add    t2 <- t0, t1
    movl    -32(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -36(%ebp)        
    movl    8(%ebp), %eax           #   4:     add    t3 <- a, t2
    movl    -36(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -40(%ebp)        
    movl    $2, %eax                #   5:     assign @t3 <- 2
    movl    -40(%ebp), %edi        
    movl    %eax, (%edi)           

l_hello_exit:
    # epilogue
    addl    $28, %esp               # remove locals
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
