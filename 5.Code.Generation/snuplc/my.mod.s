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
    #   -20204(%ebp)  20192  [ $i        <array 1 of <array 2 of <array 3 of <array 4 of <array 5 of <array 6 of <array 7 of <int>>>>>>>> %ebp-20204 ]
    #   -40396(%ebp)  20192  [ $j        <array 1 of <array 2 of <array 3 of <array 4 of <array 5 of <array 6 of <array 7 of <int>>>>>>>> %ebp-40396 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $40384, %esp            # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $10096, %ecx           
    mov     %esp, %edi             
    rep     stosl                  
    movl    $7,-20204(%ebp)         # local array 'i': 7 dimensions
    movl    $1,-20200(%ebp)         #   dimension 1: 1 elements
    movl    $2,-20196(%ebp)         #   dimension 2: 2 elements
    movl    $3,-20192(%ebp)         #   dimension 3: 3 elements
    movl    $4,-20188(%ebp)         #   dimension 4: 4 elements
    movl    $5,-20184(%ebp)         #   dimension 5: 5 elements
    movl    $6,-20180(%ebp)         #   dimension 6: 6 elements
    movl    $7,-20176(%ebp)         #   dimension 7: 7 elements
    movl    $7,-40396(%ebp)         # local array 'j': 7 dimensions
    movl    $1,-40392(%ebp)         #   dimension 1: 1 elements
    movl    $2,-40388(%ebp)         #   dimension 2: 2 elements
    movl    $3,-40384(%ebp)         #   dimension 3: 3 elements
    movl    $4,-40380(%ebp)         #   dimension 4: 4 elements
    movl    $5,-40376(%ebp)         #   dimension 5: 5 elements
    movl    $6,-40372(%ebp)         #   dimension 6: 6 elements
    movl    $7,-40368(%ebp)         #   dimension 7: 7 elements

    # function body

l_hello_exit:
    # epilogue
    addl    $40384, %esp            # remove locals
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
