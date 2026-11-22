// MEM/WB pipeline register (passes MEM control and data signals to WB on posedge clk)
// inputs: clk, reset, RegWriteM, MemtoRegM, ALUOutM, ReadDataM, WriteRegM
// outputs: RegWriteW, MemtoRegW, ALUOutW, ReadDataW, WriteRegW

module mem_wb (
    // Inputs coming from the MEM stage
    input clk, reset, RegWriteM, MemtoRegM,
    input [31:0] ALUOutM, ReadDataM, 
    input [4:0] WriteRegM, 
    // Control Output
    output reg RegWriteW, MemtoRegW,
    // Data Output 
    output reg [31:0] ALUOutW, ReadDataW, 
    output reg [4:0] WriteRegW
); 

always @(posedge clk or posedge reset) begin
    if (reset) begin 
        RegWriteW <= 1'b0; MemtoRegW <= 1'b0; 
        ALUOutW <= 32'h00000000; ReadDataW <= 32'h00000000; 
        WriteRegW <= 5'b00000;     
    end else begin
        RegWriteW <= RegWriteM; MemtoRegW <= MemtoRegM;  
        ALUOutW <= ALUOutM; ReadDataW <= ReadDataM; 
        WriteRegW <= WriteRegM;
    end
end

endmodule