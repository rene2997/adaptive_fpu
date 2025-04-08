package wildcat.pipeline

import wildcat.MemMap._
import chisel3._
import chisel3.util._

class MemArbiter extends Module {
  val io = IO(new Bundle {
    val cpu  = Flipped(new MemIO)
    val dmem = new MemIO() // flipped within ScratchPadMem
    val fpu  = Flipped(new FpuIO())
  })

  val rdData = WireDefault(io.dmem.rdData) // Default: read from DMEM

  // default: connect CPU <-> DMEM
  io.dmem <> io.cpu
  io.cpu.stall := io.dmem.stall

  // FPU data regs
  val aReg  = Reg(UInt(32.W))
  val bReg  = Reg(UInt(32.W))
  val opReg = RegInit(0.U(3.W))

  // default: FPU disabled
  io.fpu.a := aReg
  io.fpu.b := bReg
  io.fpu.op := opReg

  // FSM: idle → gotA → gotB → start → wait
  val sIdle  = 0.U
  val sGotA  = 1.U
  val sGotB  = 2.U
  val sWait  = 3.U
  val state  = RegInit(sIdle)

  switch(state) {
    is(sIdle) {
      when(io.cpu.wrAddress === FPU_BASE.U) {
        aReg := io.cpu.wrData
        state := sGotA
      }
    }

    is(sGotA) {
      when(io.cpu.wrAddress === FPU_TOP.U) {
        bReg := io.cpu.wrData
        state := sGotB
      }
    }

    is(sGotB) {
      opReg := 1.U  // Trigger computation
      state := sWait
    }

    is(sWait) {
      opReg := 0.U  // Clear trigger
      when(io.fpu.done) {
        state := sIdle
      }
    }
  }

  // Override memory read result when accessing FPU and done
  val fpuRead = (io.cpu.rdAddress === FPU_BASE.U || io.cpu.rdAddress === FPU_TOP.U)
  when(fpuRead && io.fpu.done) {
    rdData := io.fpu.result
    io.dmem.rdEnable := false.B
  }

  // Block DMEM writes in IO range
  when(io.cpu.wrAddress(31, 28) === "hf".U && io.cpu.wrEnable(0)) {
    io.dmem.wrEnable := VecInit(Seq.fill(4)(false.B))
  }

  io.cpu.rdData := RegNext(rdData)
}