`timescale 1ns / 1ps

module test_fpu;

    // Parameters
    parameter BRAM_WIDTH = 10;
    parameter DATA_WIDTH = 32;

    // DUT I/Os
    logic clock;
    logic reset;

    logic [2:0] op;
    logic start;
    logic [31:0] a;
    logic [31:0] b;
    logic [31:0] result;
    logic result_rdy_out;

    // Instantiate your FPU
    fpu DUT (
        .start(start),
        .clock(clock),
        .reset(reset),
        .op(op),
        .a(a),
        .b(b),
        .result(result),
        .result_rdy_out(result_rdy_out)
    );

    initial begin
        fd = $fopen("fpu_edge_cases_correct.csv", "r");
        if (fd == 0) begin
            $display("Error: Could not open test vector file.");
            $finish;
        end
    end

    always #10ns clock = ~clock;

    initial begin
        reset = 1;
        start = 0;
        a = 0;
        b = 0;
        op = 3'b000;
        state = LOAD_INPUT;
        #20;
        reset = 0;
    end

  typedef enum logic [1:0] {
      LOAD_INPUT,
      WAIT_RESULT,
      CHECK_RESULT
  } state_t;

  state_t state;
  logic [31:0] a_hex, b_hex, expected_result;
  int fd, dummy, line_num;
  string line;


  // Clocked process
  always_ff @(posedge clock) begin
      case (state)
          LOAD_INPUT: begin
              if (!$feof(fd)) begin
                  void'($fgets(line, fd));
                  line = line.toupper(); // no effect but shows intent — optionally strip \n or \r
                  dummy = $sscanf(line, "%h,%h,%h", a_hex, b_hex, expected_result);
                  a <= a_hex;
                  b <= b_hex;
                  start <= 1;
                  state <= WAIT_RESULT;
              end else begin
                  $display("All tests completed.");
                  $finish;
              end
          end

          WAIT_RESULT: begin
              start <= 0;
              if (result_rdy_out) begin
                  state <= CHECK_RESULT;
              end
          end

          CHECK_RESULT: begin
              if (result === expected_result)
                  $display("PASS: Got %h, expected %h", result, expected_result);
              else
                  $display("FAIL: Got %h (operand a %h, operand b %h ), expected %h", result, a_hex, b_hex, expected_result);
              state <= LOAD_INPUT;
          end

          default: begin
            // do nothing

          end
      endcase
  end

endmodule