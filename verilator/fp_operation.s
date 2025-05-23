    .text
    .globl _start
_start:
    
    li x5, 0x8100000     # Assuming DMEM base = 0x0000_0000
    addi x1, x1, 1000
    sw x1, 0(x5)
    lw x6, 0(x5)
    
    li   x1, 0xAA59111A    # operand A
    li   x2, 0xDC58479C    # operand B (Correct result : 0x47376326)

    lui  x4, 0x7FFFF       # x4 = 0x7FFFF   
    addi x4, x4, 1         # Determines op = 1
    sw   x1, 0(x4)         # store A

poll:
    lw   x3, 0(x4)         # read FPU result
    andi x6, x3, 1         # test done bit
    beq  x6, x0, poll      # if zero, loop

    ebreak                # signal we're done (for sim/debug)
