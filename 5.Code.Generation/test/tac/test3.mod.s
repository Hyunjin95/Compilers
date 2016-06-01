##################################################
# test3
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

    # scope test3
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
    movl    i, %eax                 #   0:     if     i > 3 goto 1_if_true
    movl    $3, %ebx               
    cmpl    %ebx, %eax             
    jg      l_test3_1_if_true      
    jmp     l_test3_2_if_false      #   1:     goto   2_if_false
l_test3_1_if_true:
    movl    $0, %eax                #   3:     assign i <- 0
    movl    %eax, i                
    jmp     l_test3_0               #   4:     goto   0
l_test3_2_if_false:
    movl    $1, %eax                #   6:     assign i <- 1
    movl    %eax, i                
l_test3_0:

l_test3_exit:
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

    # scope: test3
i:                                  # <int>
    .skip    4

    # end of global data section
    #-----------------------------------------

    .end
##################################################
