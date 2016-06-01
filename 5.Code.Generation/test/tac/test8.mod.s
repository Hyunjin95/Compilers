##################################################
# test8
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

    # scope test8
main:
    # stack offsets:
    #    -13(%ebp)   1  [ $t0       <bool> %ebp-13 ]

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
    movl    i, %eax                 #   0:     if     i < 3 goto 4
    movl    $3, %ebx               
    cmpl    %ebx, %eax             
    jl      l_test8_4              
    jmp     l_test8_2               #   1:     goto   2
l_test8_4:
    movl    i, %eax                 #   3:     if     i > 0 goto 1
    movl    $0, %ebx               
    cmpl    %ebx, %eax             
    jg      l_test8_1              
    jmp     l_test8_2               #   4:     goto   2
l_test8_1:
    movl    $1, %eax                #   6:     assign t0 <- 1
    movb    %al, -13(%ebp)         
    jmp     l_test8_3               #   7:     goto   3
l_test8_2:
    movl    $0, %eax                #   9:     assign t0 <- 0
    movb    %al, -13(%ebp)         
l_test8_3:
    movzbl  -13(%ebp), %eax         #  11:     assign b <- t0
    movb    %al, b                 
    movzbl  b, %eax                 #  12:     if     b = 1 goto 8_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    je      l_test8_8_if_true      
    jmp     l_test8_9_if_false      #  13:     goto   9_if_false
l_test8_8_if_true:
    movl    $0, %eax                #  15:     assign i <- 0
    movl    %eax, i                
    jmp     l_test8_7               #  16:     goto   7
l_test8_9_if_false:
l_test8_7:

l_test8_exit:
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

    # scope: test8
b:                                  # <bool>
    .skip    1
    .align   4
i:                                  # <int>
    .skip    4

    # end of global data section
    #-----------------------------------------

    .end
##################################################
