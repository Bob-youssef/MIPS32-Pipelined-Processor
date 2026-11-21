`timescale 1ns/1ps

module tb_mem_wb; 
    reg clk, reset, RegWriteM, MemtoRegM;
    reg [31:0] ALUOutM, ReadDataM; 
    reg [4:0] WriteRegM; 
    // Control Output
    wire RegWriteW, MemtoRegW;
    // Data Output 
    wire [31:0] ALUOutW, ReadDataW; 
    wire [4:0] WriteRegW; 

    mem_wb uut (
        .clk(clk), .reset(reset),
        .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM),
        .ALUOutM(ALUOutM), .ReadDataM(ReadDataM), .WriteRegM(WriteRegM),
        .RegWriteW(RegWriteW), .MemtoRegW(MemtoRegW),
        .ALUOutW(ALUOutW), .ReadDataW(ReadDataW), .WriteRegW(WriteRegW)
    );

    initial clk = 0; always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/vcd/mem_wb_waves.vcd");
        $dumpvars(1, tb_mem_wb);

        reset     = 1'b1;
        RegWriteM = 1'b0;
        MemtoRegM = 1'b0;
        ALUOutM   = 32'h00000000;
        ReadDataM = 32'h00000000;
        WriteRegM = 5'b00000;

        #12;
        reset     = 1'b0;
        RegWriteM = 1'b1;
        MemtoRegM = 1'b1;
        ALUOutM   = 32'h12345678;
        ReadDataM = 32'hAABBCCDD;
        WriteRegM = 5'b01010;

        #10;
        RegWriteM = 1'b1;
        MemtoRegM = 1'b0;
        ALUOutM   = 32'h87654321;
        ReadDataM = 32'h11223344;
        WriteRegM = 5'b10101;

        #10;
        reset = 1'b1;

        #10;
        $finish;
    end
endmodule