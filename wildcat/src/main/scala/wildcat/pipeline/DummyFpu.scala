package wildcat.pipeline

import wildcat.MemMap._
import chisel3._
import chisel3.util._

class DummyFpu extends Module {
  val io = IO(new FpuIO())

  val start = io.start
  val regA = Reg(UInt(32.W))
  val regB = Reg(UInt(32.W))
  val captured = RegInit(false.B)

  when (start && !captured) {
    regA := io.a
    regB := io.b
    captured := true.B
  }

  when (!start) {
    captured := false.B
  }

  val result = regA + regB
  val done   = RegNext(start, false.B)

  io.result := Mux(io.done, result, 0.U)
  io.done   := done

}