// 32x32 register file ($zero hardwired to 0, comb reads, negedge clk write)
// inputs: clk, A1, A2, A3, WE3, WD3    outputs: RD1, RD2

module register_file (
    input clk,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input WE3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
);
reg [31:0] registers [0:31];
assign RD1 = A1==0? 0 : registers [A1];
assign RD2 = A2==0? 0 : registers [A2];
integer i; 
initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'h00000000;
end

always @(negedge clk) begin
    if(WE3 && A3!=0) registers[A3] <= WD3;
end

    
endmodule
