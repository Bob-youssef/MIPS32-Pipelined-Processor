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
// reg  [31:0] registers [31:0] ;
reg  [31:0][31:0] registers  ;
assign RD1 = A1==0? 0 : registers [A1];
assign RD2 = A2==0? 0 : registers [A2];

always @(negedge clk) begin
    if(WE3 && A3!=0) registers[A3] <= WD3;
end

    
endmodule