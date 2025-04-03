package wildcat.pipeline

import wildcat.MemMap._
import chisel3._
import chisel3.util._

class MemArbiter extends Module {
  val io = IO(new Bundle {
    val cpu = Flipped(new MemIO)
    val dmem = new MemIO()
    val fpu = Flipped(new FpuIO())
  })


  // Migrated code (dmem of cpu is implicit)
  when ((io.cpu.wrAddress(31, 28) === 0xf.U) && io.cpu.wrEnable(0)) {
    io.dmem.wrEnable := VecInit(Seq.fill(4)(false.B))
  }

  // 1) Provide default assignments to everything
  io.cpu.stall    := false.B
  io.cpu.rdData   := 0.U

  io.dmem.rdEnable := false.B
  io.dmem.wrEnable := VecInit(Seq.fill(4)(false.B))
  io.dmem.rdAddress := 0.U
  io.dmem.wrAddress := 0.U
  io.dmem.wrData    := 0.U

  io.fpu.a := 0.U
  io.fpu.b := 0.U


  io.fpu.op := 0.U
  when (io.fpu.done) {
    // Something
  }

  when (io.cpu.wrAddress === FPU_BASE.U) {
    io.fpu.a := io.cpu.wrData
  } .elsewhen (io.cpu.wrAddress === FPU_TOP.U) {
    io.fpu.b := io.cpu.wrData
  } .otherwise {
  }

}
