`timescale 1ns/1ps

// testbench for execute: R-type, I-type, shift, sw and beq (taken / not taken)

module tb_execute;
    reg [31:0] RD1E, RD2E, SignImmE, PCPlus4E;
    reg [4:0] RtE, RdE;
    reg [3:0] ALUControlE;
    reg ALUSrcE, RegDstE;
    wire [31:0] ALUOutE, WriteDataE, PCBranchE;
    wire ZeroE;
    wire [4:0] WriteRegE;

    execute uut (
        .RD1E(RD1E), .RD2E(RD2E), .SignImmE(SignImmE), .PCPlus4E(PCPlus4E),
        .RtE(RtE), .RdE(RdE),
        .ALUControlE(ALUControlE), .ALUSrcE(ALUSrcE), .RegDstE(RegDstE),
        .ALUOutE(ALUOutE), .ZeroE(ZeroE), .WriteDataE(WriteDataE),
        .WriteRegE(WriteRegE), .PCBranchE(PCBranchE)
    );

    integer errors = 0;

    task check;
        input [8*20-1:0] name;
        input [31:0] exp_out;
        input [4:0] exp_reg;
        input exp_zero;
        begin
            #10;
            if (ALUOutE !== exp_out || WriteRegE !== exp_reg || ZeroE !== exp_zero) begin
                $display("FAIL: %0s -> ALUOut=%h WriteReg=%0d Zero=%b, expected %h %0d %b",
                         name, ALUOutE, WriteRegE, ZeroE, exp_out, exp_reg, exp_zero);
                errors = errors + 1;
            end else
                $display("PASS: %0s -> ALUOut=%h WriteReg=%0d Zero=%b", name, ALUOutE, WriteRegE, ZeroE);
        end
    endtask

    initial begin
        $dumpfile("waves/vcd/execute.vcd");
        $dumpvars(0, tb_execute);
        PCPlus4E = 0;

        // add $t2, $t0, $t1   (01095020)
        RD1E = 5; RD2E = 10; SignImmE = 32'h00005020; RtE = 9; RdE = 10;
        ALUControlE = 4'b0010; ALUSrcE = 0; RegDstE = 1;
        check("add", 15, 10, 0);

        // sll $t7, $t1, 2   (00097880), shamt comes from SignImmE[10:6]
        RD1E = 0; RD2E = 10; SignImmE = 32'h00007880; RtE = 9; RdE = 15;
        ALUControlE = 4'b1000; ALUSrcE = 0; RegDstE = 1;
        check("sll", 40, 15, 0);

        // sra $s1, $t1, 1   (00098843)
        RD1E = 0; RD2E = 32'h80000010; SignImmE = 32'hFFFF8843; RtE = 9; RdE = 17;
        ALUControlE = 4'b1010; ALUSrcE = 0; RegDstE = 1;
        check("sra", 32'hC0000008, 17, 0);

        // addi $t1, $0, -16   (2009fff0)
        RD1E = 0; RD2E = 0; SignImmE = 32'hFFFFFFF0; RtE = 9; RdE = 31;
        ALUControlE = 4'b0010; ALUSrcE = 1; RegDstE = 0;
        check("addi", 32'hFFFFFFF0, 9, 0);

        // andi $t2, $t1, 0x80F0 (zero extended)
        RD1E = 32'hFFFFFFF0; RD2E = 0; SignImmE = 32'h000080F0; RtE = 10; RdE = 0;
        ALUControlE = 4'b0000; ALUSrcE = 1; RegDstE = 0;
        check("andi", 32'h80F0, 10, 0);

        // sw $t3, 4($0): address 4, write data = rt value
        RD1E = 0; RD2E = 32'h55; SignImmE = 4; RtE = 11; RdE = 0;
        ALUControlE = 4'b0010; ALUSrcE = 1; RegDstE = 0;
        check("sw", 4, 11, 0);
        if (WriteDataE !== 32'h55) begin
            $display("FAIL: sw WriteDataE = %h", WriteDataE); errors = errors + 1;
        end

        // beq $t0, $t1 at 0x24, offset 10 -> not taken, target 0x50
        RD1E = 32'h80FF; RD2E = 32'hFFFFFFF0; SignImmE = 10; PCPlus4E = 32'h28; RtE = 9; RdE = 0;
        ALUControlE = 4'b0110; ALUSrcE = 0; RegDstE = 0;
        check("beq not taken", 32'h810F, 9, 0);
        if (PCBranchE !== 32'h50) begin
            $display("FAIL: PCBranchE = %h, expected 50", PCBranchE); errors = errors + 1;
        end

        // beq $t3, $t5 at 0x34, offset 4 -> taken, target 0x48
        RD1E = 32'h55; RD2E = 32'h55; SignImmE = 4; PCPlus4E = 32'h38; RtE = 13; RdE = 0;
        check("beq taken", 0, 13, 1);
        if (PCBranchE !== 32'h48) begin
            $display("FAIL: PCBranchE = %h, expected 48", PCBranchE); errors = errors + 1;
        end

        // backwards branch: offset -3 from 0x20 -> 0x14
        SignImmE = 32'hFFFFFFFD; PCPlus4E = 32'h20;
        #10;
        if (PCBranchE !== 32'h14) begin
            $display("FAIL: PCBranchE = %h, expected 14", PCBranchE); errors = errors + 1;
        end else
            $display("PASS: backwards branch -> PCBranch=%h", PCBranchE);

        if (errors == 0) $display("tb_execute: ALL TESTS PASSED");
        else $display("tb_execute: %0d TESTS FAILED", errors);
        $finish;
    end
endmodule
