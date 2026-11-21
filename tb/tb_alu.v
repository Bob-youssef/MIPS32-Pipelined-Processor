`timescale 1ns/1ps

// testbench for alu: all 9 operations, ZeroE, and srl vs sra on a negative number

module tb_alu;
    reg [31:0] SrcAE, SrcBE;
    reg [3:0] ALUControlE;
    reg [4:0] shamtE;
    wire [31:0] ALUOutE;
    wire ZeroE;

    alu uut (
        .SrcAE(SrcAE),
        .SrcBE(SrcBE),
        .ALUControlE(ALUControlE),
        .shamtE(shamtE),
        .ALUOutE(ALUOutE),
        .ZeroE(ZeroE)
    );

    integer errors = 0;

    task check;
        input [31:0] expected;
        begin
            #10;
            if (ALUOutE !== expected) begin
                $display("FAIL: ALUControl=%b A=%h B=%h shamt=%0d -> %h, expected %h",
                         ALUControlE, SrcAE, SrcBE, shamtE, ALUOutE, expected);
                errors = errors + 1;
            end else
                $display("PASS: ALUControl=%b A=%h B=%h shamt=%0d -> %h zero=%b",
                         ALUControlE, SrcAE, SrcBE, shamtE, ALUOutE, ZeroE);
        end
    endtask

    initial begin
        $dumpfile("waves/vcd/alu.vcd");
        $dumpvars(0, tb_alu);
        shamtE = 0;

        // add
        ALUControlE = 4'b0010; SrcAE = 5; SrcBE = 10; check(15);
        SrcAE = 32'hFFFFFFFF; SrcBE = 1; check(0);
        // sub
        ALUControlE = 4'b0110; SrcAE = 10; SrcBE = 5; check(5);
        SrcAE = 5; SrcBE = 10; check(32'hFFFFFFFB);
        // and, or, xor, nor
        ALUControlE = 4'b0000; SrcAE = 32'hFFFFFFF0; SrcBE = 32'h80F0; check(32'h80F0);
        ALUControlE = 4'b0001; SrcAE = 5; SrcBE = 10; check(15);
        ALUControlE = 4'b0100; SrcAE = 32'h80FF; SrcBE = 32'h80AA; check(32'h55);
        ALUControlE = 4'b0011; SrcAE = 0; SrcBE = 0; check(32'hFFFFFFFF);
        // shifts (on SrcB)
        ALUControlE = 4'b1000; SrcAE = 0; SrcBE = 10; shamtE = 2; check(40);
        ALUControlE = 4'b1001; SrcBE = 10; shamtE = 1; check(5);
        ALUControlE = 4'b1010; SrcBE = 10; shamtE = 1; check(5);
        // negative number: srl fills with 0, sra fills with 1
        ALUControlE = 4'b1001; SrcBE = 32'h80000010; shamtE = 4; check(32'h08000001);
        ALUControlE = 4'b1010; SrcBE = 32'h80000010; shamtE = 4; check(32'hF8000001);

        // zero flag
        ALUControlE = 4'b0110; SrcAE = 32'h55; SrcBE = 32'h55; shamtE = 0; check(0);
        if (ZeroE !== 1) begin
            $display("FAIL: ZeroE should be 1 for A-A");
            errors = errors + 1;
        end
        SrcAE = 32'h80FF; SrcBE = 32'hFFFFFFF0; check(32'h810F);
        if (ZeroE !== 0) begin
            $display("FAIL: ZeroE should be 0 when A != B");
            errors = errors + 1;
        end

        if (errors == 0) $display("tb_alu: ALL TESTS PASSED");
        else $display("tb_alu: %0d TESTS FAILED", errors);
        $finish;
    end
endmodule
