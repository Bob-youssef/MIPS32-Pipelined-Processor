`timescale 1ns/1ps

module tb_ex_mem;
    reg clk, reset, RegWriteE, MemWriteE, MemtoRegE, BranchE, ZeroE;
    reg [31:0] ALUOutE, WriteDataE, PCBranchE; 
    reg [4:0] WriteRegE; 
    // Control Output
    wire RegWriteM, MemtoRegM, MemWriteM, BranchM;
    // Data Output 
    wire [31:0] ALUOutM, WriteDataM, PCBranchM; 
    wire [4:0] WriteRegM; 
    wire ZeroM;

    ex_mem uut (.clk(clk), .reset(reset), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .MemtoRegE(MemtoRegE), .BranchE(BranchE), .ZeroE(ZeroE),
                .ALUOutE(ALUOutE), .WriteDataE(WriteDataE), .PCBranchE(PCBranchE), .WriteRegE(WriteRegE), .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM), 
    .MemWriteM(MemWriteM), .BranchM(BranchM), .ALUOutM(ALUOutM), .WriteDataM(WriteDataM), .PCBranchM(PCBranchM), .WriteRegM(WriteRegM), .ZeroM(ZeroM));

    initial clk = 0; always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/vcd/ex_mem_waves.vcd");
        $dumpvars(1, tb_ex_mem);

        reset      = 1'b1;
        RegWriteE  = 1'b0;
        MemWriteE  = 1'b0;
        MemtoRegE  = 1'b0;
        BranchE    = 1'b0;
        ZeroE      = 1'b0;
        ALUOutE    = 32'h00000000;
        WriteDataE = 32'h00000000;
        PCBranchE  = 32'h00000000;
        WriteRegE  = 5'b00000;

        #12;
        reset      = 1'b0;
        RegWriteE  = 1'b1;
        MemWriteE  = 1'b1;
        MemtoRegE  = 1'b1;
        BranchE    = 1'b1;
        ZeroE      = 1'b1;
        ALUOutE    = 32'h12345678;
        WriteDataE = 32'hAABBCCDD;
        PCBranchE  = 32'h00000040;
        WriteRegE  = 5'b01010;

        #10;
        RegWriteE  = 1'b1;
        MemWriteE  = 1'b0;
        MemtoRegE  = 1'b0;
        BranchE    = 1'b0;
        ZeroE      = 1'b0;
        ALUOutE    = 32'h87654321;
        WriteDataE = 32'h11223344;
        PCBranchE  = 32'h00000084;
        WriteRegE  = 5'b10101;

        #10;
        reset = 1'b1;

        #10;
        $finish;
    end
endmodule