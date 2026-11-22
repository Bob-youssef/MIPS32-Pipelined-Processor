`timescale 1ns/1ps

module control_unit_tb;

    reg  [5:0] Op;
    reg  [5:0] Funct;
    wire       RegWriteD;
    wire       MemtoRegD;
    wire       MemWriteD;
    wire       BranchD;
    wire [3:0] ALUControlD;
    wire       ALUSrcD;
    wire       RegDstD;
    wire       JumpD;
    wire       ZeroExtD;

    control_unit dut (
        .Op(Op),
        .Funct(Funct),
        .RegWriteD(RegWriteD),
        .MemtoRegD(MemtoRegD),
        .MemWriteD(MemWriteD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RegDstD(RegDstD),
        .JumpD(JumpD),
        .ZeroExtD(ZeroExtD)
    );

    // Packed order: {RegWrite, MemtoReg, MemWrite, Branch,
    //                ALUControl[3:0], ALUSrc, RegDst, Jump, ZeroExt}
    wire [11:0] actual = {
        RegWriteD, MemtoRegD, MemWriteD, BranchD,
        ALUControlD, ALUSrcD, RegDstD, JumpD, ZeroExtD
    };

    // A mask bit of 0 means that output is a don't-care for the instruction.
    localparam [11:0] ALL_MASK    = 12'b1111_1111_1111;
    localparam [11:0] RTYPE_MASK  = 12'b1111_1111_1110; // ZeroExt
    localparam [11:0] SWBEQ_MASK  = 12'b1011_1111_1011; // MemtoReg, RegDst
    localparam [11:0] JUMP_MASK   = 12'b1011_0000_0010; // only RW, MW, Branch, Jump

    integer passed = 0;
    integer failed = 0;

    task check;
        input [8*20-1:0] test_name;
        input [5:0] op_value;
        input [5:0] funct_value;
        input [11:0] expected;
        input [11:0] mask;
        begin
            Op = op_value;
            Funct = funct_value;
            #10; // Let the combinational control logic settle.

            if ((actual & mask) !== (expected & mask)) begin
                $display("FAIL: %0s | Op=%b Funct=%b | got=%b expected=%b mask=%b",
                         test_name, Op, Funct, actual, expected, mask);
                failed = failed + 1;
                $stop;
            end else begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/vcd/control_unit_waves.vcd");
        $dumpvars(0, control_unit_tb);

        // R-type: Op=000000; Funct selects the ALU operation.
        check("add",  6'b000000, 6'b100000, 12'b1000_0010_0100, RTYPE_MASK);
        check("sub",  6'b000000, 6'b100010, 12'b1000_0110_0100, RTYPE_MASK);
        check("and",  6'b000000, 6'b100100, 12'b1000_0000_0100, RTYPE_MASK);
        check("or",   6'b000000, 6'b100101, 12'b1000_0001_0100, RTYPE_MASK);
        check("xor",  6'b000000, 6'b100110, 12'b1000_0100_0100, RTYPE_MASK);
        check("nor",  6'b000000, 6'b100111, 12'b1000_0011_0100, RTYPE_MASK);
        check("sll",  6'b000000, 6'b000000, 12'b1000_1000_0100, RTYPE_MASK);
        check("srl",  6'b000000, 6'b000010, 12'b1000_1001_0100, RTYPE_MASK);
        check("sra",  6'b000000, 6'b000011, 12'b1000_1010_0100, RTYPE_MASK);

        // I-type instructions. Funct is irrelevant for all of these.
        check("addi", 6'b001000, 6'b000000, 12'b1000_0010_1000, ALL_MASK);
        check("andi", 6'b001100, 6'b000000, 12'b1000_0000_1001, ALL_MASK);
        check("ori",  6'b001101, 6'b000000, 12'b1000_0001_1001, ALL_MASK);
        check("xori", 6'b001110, 6'b000000, 12'b1000_0100_1001, ALL_MASK);
        check("lw",   6'b100011, 6'b000000, 12'b1100_0010_1000, ALL_MASK);
        check("sw",   6'b101011, 6'b000000, 12'b0010_0010_1000, SWBEQ_MASK);
        check("beq",  6'b000100, 6'b000000, 12'b0001_0110_0000, SWBEQ_MASK);

        // Jump: most other control signals are don't-care.
        check("j",    6'b000010, 6'b000000, 12'b0000_0000_0010, JUMP_MASK);

        $display("\nControl unit tests: %0d passed, %0d failed", passed, failed);
         if (failed != 0)
            $display("Control unit testbench FAILED");
        else
            $display("Control unit testbench PASSED");
        $stop;
    end

endmodule
