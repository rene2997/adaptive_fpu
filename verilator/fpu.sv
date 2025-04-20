`timescale 1ns / 1ps

module fpu_wrapper #(
    parameter int BRAM_WIDTH = 10,
    parameter int DATA_WIDTH = 32
) (
    input  logic        start,
    input  logic        clock,
    input  logic        reset,
    input  logic [2:0]  op, // 000 is IDLE
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] result,
    output logic        done
);

    logic [31:0] temp_result;
    logic [4:0]  counter;

    // Combinational assignment of result_rdy_out
    assign done = (counter == 31);

    always_ff @(posedge clock or posedge reset) begin
        if (reset) begin
            counter <= 0;
            result  <= 0;
        end else begin
            if (start || counter != 0) begin
                counter <= counter + 1;

                if (counter == 30) begin
                    result <= a + b; // assign on the 31st cycle
                end
            end

            if (counter == 31)
                counter <= 0; // Reset counter after done
        end
    end

endmodule