    li x1, 0x12345678          # operand A
    li x2, 0x87654321          # operand B

    lui x4, 0x20000            # x4 = 0x20000000
    sw x1, 0(x4)               # store x1 to FPU_BASE

    lui x5, 0x2ffff            # x5 = 0x2ffff000
    addi x5, x5, -1            # x5 = 0x2fffffff (FPU_TOP)
    sw x2, 0(x5)               # store x2 to FPU_TOP

poll:
    lw x3, 0(x4)               # read FPU result
    andi x6, x3, 1             # check if done bit is set
    beq x6, x0, poll           # loop until done