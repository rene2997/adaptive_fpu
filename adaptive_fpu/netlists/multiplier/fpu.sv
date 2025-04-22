module fpu (
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    input [2:0] rm,
    output reg [31:0] out,
    output reg valid

);
always @(*) begin    
    valid <= 1'b1;
    out <= a - b;
end
endmodule