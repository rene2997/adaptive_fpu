module fpu_wrapper #(
    parameter DATA_WIDTH      = 32,
    parameter EXPONENT_WIDTH  = 8,
    parameter FRACTION_WIDTH  = 23
)(
    input  logic                     clock,
    input  logic                     reset,
    input  logic [DATA_WIDTH-1:0]    a,
    input  logic [DATA_WIDTH-1:0]    b,
    input  logic [1:0]              op,
    input  logic                     start,
    output logic                     done,
    output logic [DATA_WIDTH-1:0]    result
);

  // Handshake signals to the multiplier
  logic input_a_stb, input_a_ack;
  logic input_b_stb, input_b_ack;
  logic output_z_stb, output_z_ack;

  // State machine states for wrapper sequencing
  typedef enum logic [1:0] { IDLE, WAIT_ACK, WAIT_Z } state_t;
  state_t state;

  reconfig_module core_inst (
    .clk          (clock),
    .rst          (reset),
    .input_a      (a),
    .input_a_stb  (input_a_stb),
    .input_a_ack  (input_a_ack),
    .input_b      (b),
    .input_b_stb  (input_b_stb),
    .input_b_ack  (input_b_ack),
    .output_z     (result), 
    .output_z_stb (output_z_stb),
    .output_z_ack (output_z_ack)
  );

  always_ff @(posedge clock or posedge reset) begin
    if (reset) begin
      state          <= IDLE;
      input_a_stb    <= 1'b0;
      input_b_stb    <= 1'b0;
      output_z_ack   <= 1'b0;
      done           <= 1'b0;
    end else begin
      input_a_stb    <= 1'b0;
      input_b_stb    <= 1'b0;
      output_z_ack   <= 1'b0;
      done           <= 1'b0;

      case (state)
        IDLE: begin
          if (start) begin
            input_a_stb <= 1'b1;
            input_b_stb <= 1'b1;
            state       <= WAIT_ACK;
          end
        end

        WAIT_ACK: begin
          input_a_stb <= 1'b1;
          input_b_stb <= 1'b1;
          // Wait for the multiplier to acknowledge the last input (input_b_ack)
          if (input_b_ack) begin
            state <= WAIT_Z;
          end
        end

        WAIT_Z: begin
          // Wait for the multiplier to produce a valid output
          if (output_z_stb) begin
            output_z_ack <= 1'b1;
            done         <= 1'b1;
            state        <= IDLE;
          end
        end

        default: state <= IDLE;
      endcase
    end
  end
endmodule
