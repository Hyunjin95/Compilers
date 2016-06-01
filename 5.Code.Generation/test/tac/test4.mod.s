##################################################
# test4
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

    # scope test4
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <int> %ebp-16 ]

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
l_test4_1_while_cond:
    movl    i, %eax                 #   1:     if     i > 3 goto 2_while_body
    movl    $3, %ebx               
    cmpl    %ebx, %eax             
    jg      l_test4_2_while_body   
    jmp     l_test4_0               #   2:     goto   0
l_test4_2_while_body:
    movl    i, %eax                 #   4:     sub    t0 <- i, 1
    movl    $1, %ebx               
    subl    %ebx, %eax             
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   5:     assign i <- t0
    movl    %eax, i                
    jmp     l_test4_1_while_cond    #   6:     goto   1_while_cond
l_test4_0:

l_test4_exit:
    # epilogue
    addl    $4, %esp                # remove locals
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

    # scope: test4
i:                                  # <int>
    .skip    4

    # end of global data section
    #-----------------------------------------

    .end
##################################################
