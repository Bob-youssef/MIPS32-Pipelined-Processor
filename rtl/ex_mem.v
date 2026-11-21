// EX/MEM Pipeline Register

module ex_mem (
    // all of these inputs are cominig from the EX stage
    input clk, reset, RegWriteE, MemWriteE, MemtoRegE, BranchE, ZeroE,
    input [31:0] ALUOutE, WriteDataE, PCBranchE, 
    input [4:0] WriteRegE, 
    // Control Output
    output reg RegWriteM, MemtoRegM, MemWriteM, BranchM,
    // Data Output 
    output reg [31:0] ALUOutM, WriteDataM, PCBranchM, 
    output reg [4:0] WriteRegM, 
    output reg ZeroM
); 

always @(posedge clk or posedge reset) begin
    if (reset) begin 
        RegWriteM <= 1'b0; MemtoRegM <= 1'b0; MemWriteM <= 1'b0; BranchM <= 1'b0; 
        ALUOutM <= 32'h00000000; WriteDataM <= 32'h00000000; PCBranchM <= 32'h00000000;
        WriteRegM <= 5'b00000; ZeroM <= 1'b0;    
    end else begin
        RegWriteM <= RegWriteE; MemtoRegM <= MemtoRegE; MemWriteM <= MemWriteE; BranchM <= BranchE; 
        ALUOutM <= ALUOutE; WriteDataM <= WriteDataE; PCBranchM <= PCBranchE;
        WriteRegM <= WriteRegE; ZeroM <= ZeroE;
    end
end

endmodule