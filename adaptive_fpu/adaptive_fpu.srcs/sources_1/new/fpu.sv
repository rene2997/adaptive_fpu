module fpu (
    input clk,
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output reg [31:0] result,
    output reg done

);
//synthesis translate off
always @(posedge clk) begin    
    valid <= 1'b1;
    out <= a + b;
end
//synthesis translate on
endmodule