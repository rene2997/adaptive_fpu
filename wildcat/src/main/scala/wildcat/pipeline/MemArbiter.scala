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

  val rdData = WireDefault(io.dmem.rdData)
  io.dmem <> io.cpu
  io.cpu.stall := io.dmem.stall

  // FPU data regs
  val aReg  = Reg(UInt(32.W))
  val bReg  = Reg(UInt(32.W))
  val opReg = RegInit(0.U(2.W))
  val startReg = RegInit(false.B)
  val doneReg = RegInit(false.B)

  // FPU io connections
  io.fpu.clock := clock
  io.fpu.reset := reset
  io.fpu.a := aReg
  io.fpu.b := bReg
  io.fpu.op := opReg
  io.fpu.start := startReg

  // FSM: idle -> gotA -> gotB -> start -> wait
  val sIdle  = 0.U
  val sGotA  = 1.U
  val sGotB  = 2.U
  val sWait  = 3.U
  val state  = RegInit(sIdle)

  switch(state) {
    is(sIdle) { 
      when( (io.cpu.wrAddress(31, 12) === FPU_OP.U(32.W)(31, 12)) && (io.cpu.wrEnable(0)) ) { // FPU_OP = 0xFFFFF---
        aReg := io.cpu.wrData
        opReg := io.cpu.wrAddress(1, 0) // opReg determines the operation, the lower 2 bits of the address
        state := sGotA
      }
    }

    is(sGotA) {
      when( (io.cpu.wrAddress(31, 12) === FPU_OP.U(32.W)(31, 12)) && (io.cpu.wrEnable(0)) ) { // FPU_OP = 0xFFFFF---
        bReg := io.cpu.wrData
        doneReg := false.B // Reset doneReg when receiving new data
        state := sGotB
      }
    }

    is(sGotB) {
      startReg := true.B
      state := sWait
    }

    is(sWait) {
      startReg := false.B
      when(io.fpu.done) {
        doneReg := true.B
        state := sIdle
      }
    }
  }

  // Override memory read result when accessing FPU and done
  val fpuRead = (io.cpu.rdAddress(31, 12) === FPU_OP.U(32.W)(31, 12)) // FPU_OP = 0xFFFFF---
  
  when(fpuRead && doneReg) {
      rdData := io.fpu.result
  } .otherwise {
    rdData := 0.U // Default value for rdData  
    io.dmem.rdEnable := false.B
  }

  // Block DMEM writes in IO range
  when(io.cpu.wrAddress(31, 28) === "hf".U && io.cpu.wrEnable(0)) {
    io.dmem.wrEnable := VecInit(Seq.fill(4)(false.B))
  }

  io.cpu.rdData := RegNext(rdData) // Register the read data to avoid timing issues
}