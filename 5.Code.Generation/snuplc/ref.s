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
    #   -224(%ebp)  212  [ $a        <array 1 of <array 3 of <array 8 of <array 2 of <int>>>>> %ebp-224 ]
    #   -248(%ebp)  24  [ $ar       <array 3 of <array 1 of <int>>> %ebp-248 ]
    #   -284(%ebp)  33  [ $arr      <array 7 of <array 3 of <char>>> %ebp-284 ]
    #      8(%ebp)   4  [ %asdf     <ptr(4) to <array 3 of <int>>> %ebp+8 ]
    #   -285(%ebp)   1  [ $b        <bool> %ebp-285 ]
    #   -292(%ebp)   4  [ $i        <int> %ebp-292 ]
    #   -296(%ebp)   4  [ $j        <int> %ebp-296 ]
    #   -300(%ebp)   4  [ $k        <int> %ebp-300 ]
    #   -304(%ebp)   4  [ $l        <int> %ebp-304 ]
    #   -308(%ebp)   4  [ $m        <int> %ebp-308 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $296, %esp              # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $74, %ecx              
    mov     %esp, %edi             
    rep     stosl                  
    movl    $4,-224(%ebp)           # local array 'a': 4 dimensions
    movl    $1,-220(%ebp)           #   dimension 1: 1 elements
    movl    $3,-216(%ebp)           #   dimension 2: 3 elements
    movl    $8,-212(%ebp)           #   dimension 3: 8 elements
    movl    $2,-208(%ebp)           #   dimension 4: 2 elements
    movl    $2,-248(%ebp)           # local array 'ar': 2 dimensions
    movl    $3,-244(%ebp)           #   dimension 1: 3 elements
    movl    $1,-240(%ebp)           #   dimension 2: 1 elements
    movl    $2,-284(%ebp)           # local array 'arr': 2 dimensions
    movl    $7,-280(%ebp)           #   dimension 1: 7 elements
    movl    $3,-276(%ebp)           #   dimension 2: 3 elements

    # function body

l_hello_exit:
    # epilogue
    addl    $296, %esp              # remove locals
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
