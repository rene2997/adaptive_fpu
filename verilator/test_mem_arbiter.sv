`timescale 1ns/1ps

module test_mem_arbiter;
  // clock & reset
  reg  clk = 0;
  reg  rst = 1;

  // DUT I/Os
  wire [15:0] led;
  wire        tx;
  reg         rx = 1;      // idle high on UART RX

  // instantiate your top‑level
  WildcatTop dut (
    .clock(clk),
    .reset(rst),
    .io_led(led),
    .io_tx(tx),
    .io_rx(rx)
  );

  // clock: 10 ns period (100 MHz)
  always #5 clk = ~clk;

  initial begin
    // dump waves for GTKWave
    $dumpfile("tb.vcd");
    $dumpvars(0, test_mem_arbiter);


    // hold reset for 100 ns
    #100;
    rst = 0;

    // Optionally: drive some rx pulses here for UART receive
    // e.g. send ASCII “A” (0x41) at 115200 baud…
    // you’d have to stretch bits at ~8.68 μs per bit, etc.

    // let it run for 1 ms
    #1_000_000;

    $finish;
  end
endmodule
