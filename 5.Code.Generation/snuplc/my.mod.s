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
    #      8(%ebp)   4  [ %asdf     <ptr(4) to <array 3 of <int>>> %ebp+8 ]
    #    -16(%ebp)   4  [ $i        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $j        <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t0       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t1       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t2       <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $t3       <int> %ebp-36 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $24, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $6, %ecx               
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    # ???   not implemented         #   0:     assign i <- 3
    # ???   not implemented         #   1:     assign i <- j
    # opAnd not implemented         #   2:     mul    t0 <- 1, 4
    # ???   not implemented         #   3:     param  0 <- asdf
    # ???   not implemented         #   4:     call   t1 <- DOFS
    # opAnd not implemented         #   5:     add    t2 <- t0, t1
    # opAnd not implemented         #   6:     add    t3 <- asdf, t2
    # ???   not implemented         #   7:     assign i <- @t3

l_hello_exit:
    # epilogue
    addl    $24, %esp               # remove locals
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
