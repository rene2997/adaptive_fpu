package wildcat.pipeline

import chisel3._
import chisel3.util._
import wildcat.pipeline.FpuIO

class FPU extends BlackBox {
  val io = IO(new FpuIO())
  override def desiredName: String = "fpu_wrapper" // This sets the Verilog module name
}