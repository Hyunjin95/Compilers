##################################################
# fibo
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

    # scope fib
fib:
    # stack offsets:
    #      8(%ebp)   4  [ %n        <int> %ebp+8 ]
    #    -16(%ebp)   4  [ $t10      <int> %ebp-16 ]
    #    -20(%ebp)   4  [ $t11      <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t7       <int> %ebp-24 ]
    #    -28(%ebp)   4  [ $t8       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t9       <int> %ebp-32 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $20, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $5, %ecx               
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    movl    8(%ebp), %eax           #   0:     if     n <= 1 goto 1_if_true
    movl    $1, %ebx               
    cmpl    %ebx, %eax             
    jle     l_fib_1_if_true        
    jmp     l_fib_2_if_false        #   1:     goto   2_if_false
l_fib_1_if_true:
    movl    8(%ebp), %eax           #   3:     return n
    jmp     l_fib_exit             
    jmp     l_fib_0                 #   4:     goto   0
l_fib_2_if_false:
    movl    8(%ebp), %eax           #   6:     sub    t7 <- n, 1
    movl    $1, %ebx               
    subl    %ebx, %eax             
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #   7:     param  0 <- t7
    pushl   %eax                   
    call    fib                     #   8:     call   t8 <- fib
    addl    $4, %esp               
    movl    %eax, -28(%ebp)        
    movl    8(%ebp), %eax           #   9:     sub    t9 <- n, 2
    movl    $2, %ebx               
    subl    %ebx, %eax             
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #  10:     param  0 <- t9
    pushl   %eax                   
    call    fib                     #  11:     call   t10 <- fib
    addl    $4, %esp               
    movl    %eax, -16(%ebp)        
    movl    -28(%ebp), %eax         #  12:     add    t11 <- t8, t10
    movl    -16(%ebp), %ebx        
    addl    %ebx, %eax             
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #  13:     return t11
    jmp     l_fib_exit             
l_fib_0:

l_fib_exit:
    # epilogue
    addl    $20, %esp               # remove locals
    popl    %edi                   
    popl    %esi                   
    popl    %ebx                   
    popl    %ebp                   
    ret                            

    # scope fibo
main:
    # stack offsets:
    #    -16(%ebp)   4  [ $t0       <ptr(4) to <array 17 of <char>>> %ebp-16 ]
    #    -20(%ebp)   4  [ $t1       <int> %ebp-20 ]
    #    -24(%ebp)   4  [ $t2       <ptr(4) to <array 9 of <char>>> %ebp-24 ]
    #    -28(%ebp)   4  [ $t3       <int> %ebp-28 ]
    #    -32(%ebp)   4  [ $t4       <ptr(4) to <array 2 of <char>>> %ebp-32 ]
    #    -36(%ebp)   4  [ $t5       <ptr(4) to <array 17 of <char>>> %ebp-36 ]
    #    -40(%ebp)   4  [ $t6       <int> %ebp-40 ]

    # prologue
    pushl   %ebp                   
    movl    %esp, %ebp             
    pushl   %ebx                    # save callee saved registers
    pushl   %esi                   
    pushl   %edi                   
    subl    $28, %esp               # make room for locals

    cld                             # memset local stack area to 0
    xorl    %eax, %eax             
    movl    $7, %ecx               
    mov     %esp, %edi             
    rep     stosl                  

    # function body
    leal    _str_1, %eax            #   0:     &()    t0 <- _str_1
    movl    %eax, -16(%ebp)        
    movl    -16(%ebp), %eax         #   1:     param  0 <- t0
    pushl   %eax                   
    call    WriteStr                #   2:     call   WriteStr
    addl    $4, %esp               
    call    ReadInt                 #   3:     call   t1 <- ReadInt
    movl    %eax, -20(%ebp)        
    movl    -20(%ebp), %eax         #   4:     assign n <- t1
    movl    %eax, n                
l_fibo_3_while_cond:
    movl    n, %eax                 #   6:     if     n > 0 goto 4_while_body
    movl    $0, %ebx               
    cmpl    %ebx, %eax             
    jg      l_fibo_4_while_body    
    jmp     l_fibo_2                #   7:     goto   2
l_fibo_4_while_body:
    leal    _str_2, %eax            #   9:     &()    t2 <- _str_2
    movl    %eax, -24(%ebp)        
    movl    -24(%ebp), %eax         #  10:     param  0 <- t2
    pushl   %eax                   
    call    WriteStr                #  11:     call   WriteStr
    addl    $4, %esp               
    movl    n, %eax                 #  12:     param  0 <- n
    pushl   %eax                   
    call    fib                     #  13:     call   t3 <- fib
    addl    $4, %esp               
    movl    %eax, -28(%ebp)        
    movl    -28(%ebp), %eax         #  14:     param  0 <- t3
    pushl   %eax                   
    call    WriteInt                #  15:     call   WriteInt
    addl    $4, %esp               
    leal    _str_3, %eax            #  16:     &()    t4 <- _str_3
    movl    %eax, -32(%ebp)        
    movl    -32(%ebp), %eax         #  17:     param  0 <- t4
    pushl   %eax                   
    call    WriteStr                #  18:     call   WriteStr
    addl    $4, %esp               
    leal    _str_4, %eax            #  19:     &()    t5 <- _str_4
    movl    %eax, -36(%ebp)        
    movl    -36(%ebp), %eax         #  20:     param  0 <- t5
    pushl   %eax                   
    call    WriteStr                #  21:     call   WriteStr
    addl    $4, %esp               
    call    ReadInt                 #  22:     call   t6 <- ReadInt
    movl    %eax, -40(%ebp)        
    movl    -40(%ebp), %eax         #  23:     assign n <- t6
    movl    %eax, n                
    jmp     l_fibo_3_while_cond     #  24:     goto   3_while_cond
l_fibo_2:

l_fibo_exit:
    # epilogue
    addl    $28, %esp               # remove locals
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

    # scope: fibo
_str_1:                             # <array 17 of <char>>
    .long    1
    .long   17
    .asciz "Enter a number: "
    .align   4
_str_2:                             # <array 9 of <char>>
    .long    1
    .long    9
    .asciz "Result: "
    .align   4
_str_3:                             # <array 2 of <char>>
    .long    1
    .long    2
    .asciz "\n"
    .align   4
_str_4:                             # <array 17 of <char>>
    .long    1
    .long   17
    .asciz "Enter a number: "
    .align   4
n:                                  # <int>
    .skip    4


    # end of global data section
    #-----------------------------------------

    .end
##################################################
