module test_memarbiter;

  logic clock;
  logic [31:0] cpu_rd_addr, cpu_rd_data;
  logic [31:0] cpu_wr_addr, cpu_wr_data;
  logic cpu_wr_en0, cpu_wr_en1, cpu_wr_en2, cpu_wr_en3;

  logic [31:0] dmem_rd_addr, dmem_rd_data;
  logic [31:0] dmem_wr_addr, dmem_wr_data;
  logic dmem_wr_en0, dmem_wr_en1, dmem_wr_en2, dmem_wr_en3;

  logic [2:0] fpu_op;
  logic [31:0] fpu_ab, fpu_result;
  logic fpu_done;

  MemArbiter uut (
    .clock(clock),
    .io_cpu_rdAddress(cpu_rd_addr),
    .io_cpu_rdData(cpu_rd_data),
    .io_cpu_wrAddress(cpu_wr_addr),
    .io_cpu_wrData(cpu_wr_data),
    .io_cpu_wrEnable_0(cpu_wr_en0),
    .io_cpu_wrEnable_1(cpu_wr_en1),
    .io_cpu_wrEnable_2(cpu_wr_en2),
    .io_cpu_wrEnable_3(cpu_wr_en3),

    .io_dmem_rdAddress(dmem_rd_addr),
    .io_dmem_rdData(dmem_rd_data),
    .io_dmem_wrAddress(dmem_wr_addr),
    .io_dmem_wrData(dmem_wr_data),
    .io_dmem_wrEnable_0(dmem_wr_en0),
    .io_dmem_wrEnable_1(dmem_wr_en1),
    .io_dmem_wrEnable_2(dmem_wr_en2),
    .io_dmem_wrEnable_3(dmem_wr_en3),

    .io_fpu_op(fpu_op),
    .io_fpu_ab(fpu_ab),
    .io_fpu_result(fpu_result),
    .io_fpu_done(fpu_done)
  );

  // Add mock memory, clock gen, and assertions here

endmodule