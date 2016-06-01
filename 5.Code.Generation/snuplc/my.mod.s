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
    #   -40364(%ebp)  40352  [ $a        <array 1 of <array 3 of <array 8 of <array 2 of <array 5 of <array 6 of <array 7 of <int>>>>>>>> %ebp-40364 ]
    #   -40388(%ebp)  24  [ $ar       <array 3 of <array 1 of <int>>> %ebp-40388 ]
    #   -40424(%ebp)  33  [ $arr      <array 7 of <array 3 of <char>>> %ebp-40424 ]
    #      8(%ebp)   4  [ %asdf     <ptr(4) to <array 3 of <int>>> %ebp+8 ]
    #   -40425(%ebp)   1  [ $b        <bool> %ebp-40425 ]
    #   -40432(%ebp)   4  [ $i        <int> %ebp-40432 ]
    #   -40436(%ebp)   4  [ $j        <int> %ebp-40436 ]
    #   -40440(%ebp)   4  [ $k        <int> %ebp-40440 ]
    #   -40444(%ebp)   4  [ $l        <int> %ebp-40444 ]
    #   -40448(%ebp)   4  [ $m        <int> %ebp-40448 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $40436, %esp            # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $10109, %ecx           
    mov     %esp, %edi             
    rep     stosl                  
    movl    $7,-40364(%ebp)         # local array 'a': 7 dimensions
    movl    $1,-40360(%ebp)         #   dimension 1: 1 elements
    movl    $3,-40356(%ebp)         #   dimension 2: 3 elements
    movl    $8,-40352(%ebp)         #   dimension 3: 8 elements
    movl    $2,-40348(%ebp)         #   dimension 4: 2 elements
    movl    $5,-40344(%ebp)         #   dimension 5: 5 elements
    movl    $6,-40340(%ebp)         #   dimension 6: 6 elements
    movl    $7,-40336(%ebp)         #   dimension 7: 7 elements
    movl    $2,-40388(%ebp)         # local array 'ar': 2 dimensions
    movl    $3,-40384(%ebp)         #   dimension 1: 3 elements
    movl    $1,-40380(%ebp)         #   dimension 2: 1 elements
    movl    $2,-40424(%ebp)         # local array 'arr': 2 dimensions
    movl    $7,-40420(%ebp)         #   dimension 1: 7 elements
    movl    $3,-40416(%ebp)         #   dimension 2: 3 elements

    # function body

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
