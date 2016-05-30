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
    #    -16(%ebp)   4  [ $a        <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $b        <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $c        <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $d        <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $e        <int> %ebp-32 ]
    #    -36(%ebp)   4  [ $f        <int> %ebp-36 ]
    #    -40(%ebp)   4  [ $g        <int> %ebp-40 ]
    #    -44(%ebp)   4  [ $h        <int> %ebp-44 ]
    #    -80(%ebp)  20  [ $i        <array 3 of <int>> %ebp-80 ]

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
    movl    $1,-80(%ebp)            # local array 'i': 1 dimensions
    movl    $3,-76(%ebp)            #   dimension 1: 3 elements

    # function body

l_hello_exit:
    # epilogue
    addl    $68, %esp               # remove locals
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
