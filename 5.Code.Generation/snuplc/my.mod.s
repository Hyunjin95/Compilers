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
    #   -424(%ebp)  412  [ $i        <array 10 of <array 10 of <int>>> %ebp-424 ]
    #   -836(%ebp)  412  [ $j        <array 10 of <array 10 of <int>>> %ebp-836 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $824, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $206, %ecx             
    mov     %esp, %edi             
    rep     stosl                  
    movl    $2,-424(%ebp)           # local array 'i': 2 dimensions
    movl    $10,-420(%ebp)          #   dimension 1: 10 elements
    movl    $10,-416(%ebp)          #   dimension 2: 10 elements
    movl    $2,-836(%ebp)           # local array 'j': 2 dimensions
    movl    $10,-832(%ebp)          #   dimension 1: 10 elements
    movl    $10,-828(%ebp)          #   dimension 2: 10 elements

    # function body

l_hello_exit:
    # epilogue
    addl    $824, %esp              # remove locals
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
