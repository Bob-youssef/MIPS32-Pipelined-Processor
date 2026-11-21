`timescale 1ns/1ps

module tb_if_id;
    reg clk;
    reg reset;
    reg [31:0] InstrF, PCPlus4F;
    wire [31:0] InstrD, PCPlus4D;

    if_id uut (
        .clk(clk),
        .reset(reset),
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .InstrD(InstrD),
        .PCPlus4D(PCPlus4D)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves/vcd/if_id_waves.vcd");
        $dumpvars(1, tb_if_id);

        reset = 1;
        InstrF = 32'h00000000;
        PCPlus4F = 32'h00000000;

        #12;
        reset = 0;
        InstrF = 32'h01010101;
        PCPlus4F = 32'h10101010;

        #10;
        InstrF = 32'h89ABCDEF;
        PCPlus4F = 32'h00000004;

        #10;
        reset = 1;

        #10;
        $finish;
    end
endmodule