start:
    # Assume the FPU’s memory-mapped interface is at base address 0x80000000.
    li t0, 0x80000000    # t0 = FPU interface base address

    # Write operand A (for example, the value 10)
    li t1, 10
    sw t1, 0(t0)         # Store operand A at address 0x80000000

    # Write operand B (for example, the value 20)
    li t2, 20
    sw t2, 4(t0)         # Store operand B at address 0x80000004

    # Write operation code (e.g., 1 represents "add")
    li t3, 1
    sw t3, 8(t0)         # Store the operation code at address 0x80000008

    # Clear the done flag by storing 0 into the status register (at offset 16)
    li t4, 0
    sw t4, 16(t0)        # Done flag at address 0x80000010

    # Poll the done flag until the FPU sets it to a nonzero value.
poll_loop:
    lw t5, 16(t0)        # Load the done flag from 0x80000010
    beq t5, zero, poll_loop  # If done flag is 0, loop

    # When done, load the result from the result register (offset 12)
    lw t6, 12(t0)        # Load the result from address 0x8000000C

end:
    j end                # Infinite loop to stop execution
