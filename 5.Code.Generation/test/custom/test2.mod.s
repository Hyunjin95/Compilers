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

    # scope foo
foo:
    # ???   not implemented         #   0:     if     v < v goto 3
    # ???   not implemented         #   1:     goto   2_if_false
l_test_3:
    # ???   not implemented         #   3:     &()    t11 <- a
    # ???   not implemented         #   4:     param  1 <- 2
    # ???   not implemented         #   5:     &()    t12 <- a
    # ???   not implemented         #   6:     param  0 <- t12
    # ???   not implemented         #   7:     call   t13 <- DIM
    # ???   not implemented         #   8:     mul    t14 <- v, t13
    # ???   not implemented         #   9:     add    t15 <- t14, v
    # ???   not implemented         #  10:     mul    t16 <- t15, 4
    # ???   not implemented         #  11:     &()    t17 <- a
    # ???   not implemented         #  12:     param  0 <- t17
    # ???   not implemented         #  13:     call   t18 <- DOFS
    # ???   not implemented         #  14:     add    t19 <- t16, t18
    # ???   not implemented         #  15:     add    t20 <- t11, t19
    # ???   not implemented         #  16:     if     v > @t20 goto 1_if_true
    # ???   not implemented         #  17:     goto   2_if_false
l_test_1_if_true:
    # ???   not implemented         #  19:     goto   0
l_test_2_if_false:
l_test_0:
    # ???   not implemented         #  22:     return t

    # scope test
main:
    # ???   not implemented         #   0:     assign t <- 999
    # ???   not implemented         #   1:     if     t < t goto 4
    # ???   not implemented         #   2:     goto   3_if_false
l_test_4:
    # ???   not implemented         #   4:     &()    t0 <- a
    # ???   not implemented         #   5:     param  1 <- 2
    # ???   not implemented         #   6:     &()    t1 <- a
    # ???   not implemented         #   7:     param  0 <- t1
    # ???   not implemented         #   8:     call   t2 <- DIM
    # ???   not implemented         #   9:     mul    t3 <- t, t2
    # ???   not implemented         #  10:     add    t4 <- t3, t
    # ???   not implemented         #  11:     mul    t5 <- t4, 4
    # ???   not implemented         #  12:     &()    t6 <- a
    # ???   not implemented         #  13:     param  0 <- t6
    # ???   not implemented         #  14:     call   t7 <- DOFS
    # ???   not implemented         #  15:     add    t8 <- t5, t7
    # ???   not implemented         #  16:     add    t9 <- t0, t8
    # ???   not implemented         #  17:     if     t > @t9 goto 2_if_true
    # ???   not implemented         #  18:     goto   3_if_false
l_test_2_if_true:
    # ???   not implemented         #  20:     goto   1
l_test_3_if_false:
l_test_1:
    # ???   not implemented         #  23:     param  0 <- t
    # ???   not implemented         #  24:     call   WriteInt
    # ???   not implemented         #  25:     call   t10 <- foo
    # ???   not implemented         #  26:     param  0 <- t10
    # ???   not implemented         #  27:     call   WriteInt

    # end of text section
    #-----------------------------------------

    #-----------------------------------------
    # global data section
    #
    .data
    .align 4

    # scope: test
a:                                  # <array 100 of <array 100 of <int>>>
    .long    2
    .long  100
    .long  100
    .skip 40000
t:                                  # <int>
    .skip    4


    # end of global data section
    #-----------------------------------------

    .end
##################################################
