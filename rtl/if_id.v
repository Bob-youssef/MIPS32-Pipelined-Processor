module if_id (
    input clk, reset, 
    input [31:0] InstrF, PCPlus4F,
    output reg [31:0] InstrD, PCPlus4D 
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        InstrD <= 32'h00000000;
        PCPlus4D <= 32'h00000000;  
    end else begin
        InstrD <= InstrF; 
        PCPlus4D <= PCPlus4F; 
    end
end 
endmodule