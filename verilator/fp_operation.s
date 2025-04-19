    .text
    .globl _start
_start:
    li   x1, 0x12345678    # operand A
    li   x2, 0x87654321    # operand B

    lui  x4, 0x20000       # x4 = 0x2000_0000 (FPU_BASE)
    sw   x1, 0(x4)         # store A at FPU_BASE

    lui  x5, 0x2ffff       # x5 = 0x2fff_f000
    addi x5, x5, -1        # x5 = 0x2fff_ffff (FPU_TOP)
    sw   x2, 0(x5)         # store B at FPU_TOP

poll:
    lw   x3, 0(x4)         # read FPU result
    andi x6, x3, 1         # test done bit
    beq  x6, x0, poll      # if zero, loop
    # ... once done you could write x3 back to memory or trap
    j    poll             # just spin forever
