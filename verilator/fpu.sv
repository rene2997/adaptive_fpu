`timescale 1ns / 1ps


module fpu #(
    parameter int BRAM_WIDTH = 10,
    parameter int DATA_WIDTH = 32
) (
    input start,
    input clk,
    input [2:0] op, // 000 is IDLE
    input [31:0] ab,
    output reg [31:0] result,
    output reg done
);
// Dual port Data-Memory to test of storing is handled and sent correctly from memArbiter

localparam TABLE_SIZE = 2 ** BRAM_WIDTH;
reg [DATA_WIDTH-1:0] ram [TABLE_SIZE-1:0] = '{default: '0};

// Temporary assignments to check if the input ab gets passed correctly into the correct index
localparam ADDR_A = 1000;
localparam ADDR_B = 2000;

always_ff @(posedge clk) begin
    done <= 0;
    case (op)
        3'b001: begin
            result <= 32'h00000000;
            ram[ADDR_A] <= ab;
            done <= 0;
        end
        3'b010: begin
            result <= 32'h00000000;
            ram[ADDR_B] <= ab;
            done <= 0;
        end
        default: begin
            result <= ram[ADDR_A] + ram[ADDR_B];
            done <= 1;
        end
    endcase
end

endmodule