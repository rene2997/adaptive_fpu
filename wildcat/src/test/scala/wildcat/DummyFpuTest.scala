package wildcat

import chisel3._
import chisel3.util._
import wildcat.MemMap._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec
import wildcat.pipeline._

class DummyFpuWrapper extends Module {
  val io = IO(new Bundle {
    val cpu     = Flipped(new MemIO())
    val fpuDone = Output(Bool())
  })

  // instantiate modules
  val fpu     = Module(new DummyFpu())
  val dmem    = Module(new ScratchPadMem(Array.fill(16)(0), 64))
  val arbiter = Module(new MemArbiter())

  // expose done signal to testbench
  io.fpuDone := fpu.io.done

  // connect FPU <-> Arbiter <-> Memory
  arbiter.io.fpu  <> fpu.io
  arbiter.io.dmem <> dmem.io

  // expose io.cpu port to poke with values
  io.cpu <> arbiter.io.cpu
}

class DummyFpuTest extends AnyFlatSpec with ChiselScalatestTester {
  "DummyFpu system" should "perform a simple add through the arbiter and memory" in {
    test(new DummyFpuWrapper()).withAnnotations(Seq(WriteVcdAnnotation)) { c =>

      // Enable all byte lanes
      for (i <- 0 until 4) {
        c.io.cpu.wrEnable(i).poke(true.B)
      }

      // Write A = 4 to FPU_BASE
      c.io.cpu.wrAddress.poke(FPU_BASE.U)
      c.io.cpu.wrData.poke(4.U)
      c.clock.step()

      // Write B = 5 to FPU_TOP
      c.io.cpu.wrAddress.poke(FPU_TOP.U)
      c.io.cpu.wrData.poke(5.U)
      c.clock.step()

      // Disable write
      for (i <- 0 until 4) {
        c.io.cpu.wrEnable(i).poke(false.B)
      }

      // Wait until FPU is done
      var waitCycles = 0
      while (!c.io.fpuDone.peek().litToBoolean && waitCycles < 10) {
        c.clock.step()
        waitCycles += 1
      }

      c.io.cpu.rdAddress.poke(FPU_TOP.U)
      c.clock.step()

      val result = c.io.cpu.rdData.peek().litValue
      println(s"FPU result = $result after $waitCycles cycles")
      assert(result == 9, "FPU add result should be 9")

    }
  }
}