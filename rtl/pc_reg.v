// Program Counter register (updates on posedge clk, async reset to 0)
// inputs: clk, reset, PCNext    output: PCF

module pc_reg (
    input clk, reset, 
    input [31:0] PCNext,
    output reg [31:0] PCF 
);

always @(posedge clk or posedge reset) begin
    if (reset) PCF <= {32{1'b0}};
    else PCF <= PCNext; 
end 

endmodule