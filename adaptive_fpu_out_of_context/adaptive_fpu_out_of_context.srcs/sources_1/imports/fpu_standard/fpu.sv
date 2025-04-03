module fpu (
    input clk,
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output reg [31:0] result,
    output reg done

);
always @(posedge clk) begin    
    done <= 1'b1;
    result <= a + b;
end
endmodule