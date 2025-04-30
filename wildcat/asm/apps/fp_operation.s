.text
.globl _start
_start:
#— Load operands (raw IEEE-754 bits)
li   x10, 0xAA59111A      # operand A
li   x11, 0xDC58479C      # operand B

#— 1) Sign = XOR of signs
xor  x12, x10, x11
srli x12, x12, 31         # x12 = result sign

#— 2) Exponents
srli x13, x10, 23
andi x13, x13, 0xFF       # exp_a
srli x14, x11, 23
andi x14, x14, 0xFF       # exp_b
add  x15, x13, x14        # exp_a + exp_b
addi x15, x15, -127       # bias adjust

#— 3) Mantissas w/ implicit leading 1
li   x23, 0x7FFFFF        # mask = 23 ones
and  x16, x10, x23        # mant_a = bits[22:0]
li   x23, 0x800000
add  x16, x16, x23        # mant_a |= 1<<23

li   x23, 0x7FFFFF
and  x17, x11, x23        # mant_b = bits[22:0]
li   x23, 0x800000
add  x17, x17, x23        # mant_b |= 1<<23

#— 4) 48-bit shift-add multiply into (x19=hi, x18=lo)
li   x19, 0
li   x18, 0
li   x24, 0              # curr_hi
mv   x25, x16           # curr_lo = mant_a
li   x20, 24            # loop count

mul_loop:
beq  x20, x0, mul_done
andi x21, x17, 1
beq  x21, x0, skip_add
  add  x18, x18, x25    # lo += curr_lo
  slt  x29, x18, x25    # carry?
  add  x19, x19, x24    # hi += curr_hi
  add  x19, x19, x29    # +carry
skip_add:
# shift curr (hi:lo) left by 1
srli x26, x25, 31
slli x24, x24, 1
or   x24, x24, x26
slli x25, x25, 1

# shift multiplier right
srli x17, x17, 1
addi x20, x20, -1
j    mul_loop

mul_done:
#— 5) Normalize if bit47 set (x19 bit15)
li   x23, 0x8000
and  x27, x19, x23
beq  x27, x0, extract_mant
  andi x26, x19, 1
  slli x26, x26, 31
  srli x18, x18, 1
  or   x18, x18, x26
  srli x19, x19, 1
  addi x15, x15, 1      # exp++

extract_mant:
#— 6) Build 23-bit mantissa = bits[45:23] of 48-bit product
li   x23, 0x7FFF
and  x28, x19, x23      # hi bits[14:0] = bits[46:32]
slli x28, x28, 9        # shift into [22:9]
srli x29, x18, 23       # lo bits[31:23] → [8:0]
or   x28, x28, x29      # final mantissa in x28

#— 7) Reassemble sign|exp|mantissa
slli x30, x12, 31
slli x31, x15, 23
or   x30, x30, x31
or   x30, x30, x28      # x30 = IEEE-754(A×B)

#— 8) Store result and finish
li   x5, 0x08100000
sw   x30, 4(x5)         # write at DMEM+4
ebreak                  # for your sim/debug
