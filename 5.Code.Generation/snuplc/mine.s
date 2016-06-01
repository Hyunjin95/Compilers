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
    #      8(%ebp)   4  [ %a        <int> %ebp+8 ]
    #     12(%ebp)   4  [ %b        <int> %ebp+12 ]
    #    -13(%ebp)   1  [ $b1       <bool> %ebp-13 ]
    #    -14(%ebp)   1  [ $b2       <bool> %ebp-14 ]
    #    -15(%ebp)   1  [ $b3       <bool> %ebp-15 ]
    #     16(%ebp)   1  [ %c        <char> %ebp+16 ]
    #    -16(%ebp)   1  [ $c1       <char> %ebp-16 ]
    #    -17(%ebp)   1  [ $c2       <char> %ebp-17 ]
    #     20(%ebp)   1  [ %d        <char> %ebp+20 ]
    #    -24(%ebp)   4  [ $i1       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $i2       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $i3       <int> %ebp-32 ]
    #    -33(%ebp)   1  [ $t0       <bool> %ebp-33 ]

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
    movl    -24(%ebp), %eax         #   0:     if     i1 > i2 goto 1
    movl    -28(%ebp), %ebx        
    cmpl    %ebx, %eax             
    jge     l_hello_1              
    jmp     l_hello_2               #   1:     goto   2
l_hello_1:
    movl    $1, %eax                #   3:     assign t0 <- 1
    movb    %al, -33(%ebp)         
    jmp     l_hello_3               #   4:     goto   3
l_hello_2:
    movl    $0, %eax                #   6:     assign t0 <- 0
    movb    %al, -33(%ebp)         
l_hello_3:
    movzbl  -33(%ebp), %eax         #   8:     assign b1 <- t0
    movb    %al, -13(%ebp)         

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
