`timescale 1ns/1ps

module test_mem_arbiter;
  // clock & reset
  reg  clk = 0;
  reg  rst = 1;

  // DUT I/Os
  wire [15:0] led;
  wire        tx;
  reg         rx = 1;

  // Instantiate DUT
  WildcatTop dut (
    .clock(clk),
    .reset(rst),
    .io_led(led),
    .io_tx(tx),
    .io_rx(rx)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    // Dump VCD for waveform
    $dumpfile("tb.vcd");
    $dumpvars(0, test_mem_arbiter);

    // Reset
    #100;
    rst = 0;

    // Optional: simulate UART RX

    // Let simulation run
    #1_000_000;

    $finish;
  end
endmodule
