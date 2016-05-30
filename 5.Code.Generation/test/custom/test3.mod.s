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

    # scope proc
proc:
    # ???   not implemented         #   0:     assign _str_1 <- 3

    # scope test
main:
    # ???   not implemented         #   0:     &()    t0 <- _str_1
    # ???   not implemented         #   1:     param  0 <- t0
    # ???   not implemented         #   2:     call   WriteStr
    # ???   not implemented         #   3:     assign i <- 3
    # ???   not implemented         #   4:     call   proc

    # end of text section
    #-----------------------------------------

    #-----------------------------------------
    # global data section
    #
    .data
    .align 4

    # scope: test
_str_1:                             # <array 6 of <char>>
    .long    1
    .long    6
    .asciz "Hello"
    .align   4
i:                                  # <int>
    .skip    4


    # end of global data section
    #-----------------------------------------

    .end
##################################################
