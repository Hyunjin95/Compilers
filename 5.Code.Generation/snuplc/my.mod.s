##################################################
# a
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

    # scope a
main:
    # ???   not implemented         #   0:     &()    t0 <- arr
    # ???   not implemented         #   1:     param  1 <- 2
    # ???   not implemented         #   2:     &()    t1 <- arr
    # ???   not implemented         #   3:     param  0 <- t1
    # ???   not implemented         #   4:     call   t2 <- DIM
    # ???   not implemented         #   5:     mul    t3 <- 3, t2
    # ???   not implemented         #   6:     add    t4 <- t3, 2
    # ???   not implemented         #   7:     mul    t5 <- t4, 4
    # ???   not implemented         #   8:     &()    t6 <- arr
    # ???   not implemented         #   9:     param  0 <- t6
    # ???   not implemented         #  10:     call   t7 <- DOFS
    # ???   not implemented         #  11:     add    t8 <- t5, t7
    # ???   not implemented         #  12:     add    t9 <- t0, t8
    # ???   not implemented         #  13:     assign @t9 <- -3

    # end of text section
    #-----------------------------------------

    #-----------------------------------------
    # global data section
    #
    .data
    .align 4

    # scope: a
arr:                                # <array 5 of <array 3 of <int>>>
    .long    2
    .long    5
    .long    3
    .skip   60


    # end of global data section
    #-----------------------------------------

    .end
##################################################
