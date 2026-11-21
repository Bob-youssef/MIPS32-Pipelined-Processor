
`timescale 1ns / 1ps

module decode_tb;

    reg clk;
    reg reset;
    reg [31:0] instrD;
    reg [31:0] PCPlus4D;
    reg [4:0] WriteRegW;
    reg WE3;
    reg [31:0] ResultW;

    wire [31:0] RD1E, RD2E;
    wire RegWriteE, MemtoRegE, MemWriteE, BranchE;
    wire [3:0] ALUControlE;
    wire ALUSrcE, RegDstE;
    wire JumpD;
    wire [31:0] PCJumpD;
    wire [4:0] RtE, RdE;
    wire [31:0] SignImmE, PCPlus4E;

    integer errors;

    // Device under test
    decode dut (
        .clk(clk),
        .reset(reset),
        .instrD(instrD),
        .PCPlus4D(PCPlus4D),
        .WriteRegW(WriteRegW),
        .WE3(WE3),
        .ResultW(ResultW),

        .RD1E(RD1E),
        .RD2E(RD2E),
        .RegWriteE(RegWriteE),
        .MemtoRegE(MemtoRegE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .RegDstE(RegDstE),

        .JumpD(JumpD),
        .PCJumpD(PCJumpD),

        .RtE(RtE),
        .RdE(RdE),
        .SignImmE(SignImmE),
        .PCPlus4E(PCPlus4E)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        $readmemh("memory/registers.mem", dut.register_file_0.registers);
    end
    // Check an output against its expected value
    task check;
        input [31:0] actual;
        input [31:0] expected;
        input [255:0] test_name;
        begin
            if (actual !== expected) begin
                $display("FAIL: %0s | Expected=%h, Actual=%h",
                         test_name, expected, actual);
                errors = errors + 1;
            end
            else
                $display("PASS: %0s", test_name);
        end
    endtask

    // Apply an instruction and wait until it reaches EX
    task apply_instruction;
        input [31:0] instruction;
        input [31:0] pc;
        begin
            @(negedge clk);
            #1;
            instrD = instruction;
            PCPlus4D = pc;

            // Allow combinational decode to settle
            #1;

            // ID/EX captures values on rising edge
            @(posedge clk);
            #1;
        end
    endtask

    initial begin

        // Initialize
        clk = 0;
        reset = 1;
        instrD = 0;
        PCPlus4D = 0;
        WriteRegW = 0;
        WE3 = 0;
        ResultW = 0;
        errors = 0;

        $display("\n===== DECODE STAGE TESTBENCH =====");

        // ------------------------------------
        // TEST 1: Reset
        // ------------------------------------
        $display("\nTEST 1: Reset");

        @(posedge clk);
        #1;

        check(RD1E, 0, "Reset RD1E");
        check(RD2E, 0, "Reset RD2E");
        check(RegWriteE, 0, "Reset RegWriteE");
        check(BranchE, 0, "Reset BranchE");
        check(PCPlus4E, 0, "Reset PCPlus4E");

        check(dut.register_file_0.registers[8], 32'h23874827, "Preloaded $t0");
        check(dut.register_file_0.registers[9], 32'h23442344, "Preloaded $t1");

        reset = 0;

        // ------------------------------------
        // Initialize registers through WB
        // ------------------------------------
        $display("\nInitializing register file");

        // Write $t0 = 10 (register 8)
        WE3 = 1;
        WriteRegW = 5'd8;
        ResultW = 32'd10;

        @(negedge clk);
        #1;

        // Write $t1 = 3 (register 9)
        WriteRegW = 5'd9;
        ResultW = 32'd3;

        @(negedge clk);
        #1;

        WE3 = 0;

        // ------------------------------------
        // TEST 2: R-type ADD
        // add $t2, $t0, $t1
        // ------------------------------------
        $display("\nTEST 2: R-type ADD");

        apply_instruction(
            {6'b000000, 5'd8, 5'd9, 5'd10,
             5'd0, 6'b100000},
            32'h00001004
        );

        check(RD1E, 32'd10, "ADD RD1E");
        check(RD2E, 32'd3, "ADD RD2E");
        check(RtE, 5'd9, "ADD RtE");
        check(RdE, 5'd10, "ADD RdE");
        check(RegWriteE, 1, "ADD RegWriteE");
        check(RegDstE, 1, "ADD RegDstE");
        check(ALUSrcE, 0, "ADD ALUSrcE");
        check(ALUControlE, 4'b0010, "ADD ALUControlE");
        check(PCPlus4E, 32'h00001004, "ADD PCPlus4E");

        // ------------------------------------
        // TEST 3: ADDI with negative immediate
        // addi $t2, $t0, -2
        // ------------------------------------
        $display("\nTEST 3: ADDI");

        apply_instruction(
            {6'b001000, 5'd8, 5'd10, 16'hFFFE},
            32'h00001008
        );

        check(SignImmE, 32'hFFFFFFFE, "ADDI Sign Extension");
        check(ALUControlE, 4'b0010, "ADDI ALUControlE");
        check(ALUSrcE, 1, "ADDI ALUSrcE");
        check(RegDstE, 0, "ADDI RegDstE");
        check(RegWriteE, 1, "ADDI RegWriteE");

        // ------------------------------------
        // TEST 4: ANDI with zero extension
        // andi $t2, $t0, 0x8001
        // ------------------------------------
        $display("\nTEST 4: ANDI");

        apply_instruction(
            {6'b001100, 5'd8, 5'd10, 16'h8001},
            32'h0000100C
        );

        check(SignImmE, 32'h00008001, "ANDI Zero Extension");
        check(ALUControlE, 4'b0000, "ANDI ALUControlE");
        check(ALUSrcE, 1, "ANDI ALUSrcE");
        check(RegWriteE, 1, "ANDI RegWriteE");

        // ------------------------------------
        // TEST 5: LW
        // lw $t2, 16($t0)
        // ------------------------------------
        $display("\nTEST 5: LW");

        apply_instruction(
            {6'b100011, 5'd8, 5'd10, 16'd16},
            32'h00001010
        );

        check(SignImmE, 32'd16, "LW Immediate");
        check(RegWriteE, 1, "LW RegWriteE");
        check(MemtoRegE, 1, "LW MemtoRegE");
        check(MemWriteE, 0, "LW MemWriteE");
        check(ALUSrcE, 1, "LW ALUSrcE");
        check(ALUControlE, 4'b0010, "LW ALUControlE");

        // ------------------------------------
        // TEST 6: BEQ
        // beq $t0, $t1, -4
        // ------------------------------------
        $display("\nTEST 6: BEQ");

        apply_instruction(
            {6'b000100, 5'd8, 5'd9, 16'hFFFC},
            32'h00001014
        );

        check(BranchE, 1, "BEQ BranchE");
        check(RegWriteE, 0, "BEQ RegWriteE");
        check(ALUSrcE, 0, "BEQ ALUSrcE");
        check(ALUControlE, 4'b0110, "BEQ ALUControlE");
        check(SignImmE, 32'hFFFFFFFC, "BEQ Sign Extension");

        // ------------------------------------
        // TEST 7: SRA
        // sra $t2, $t1, 3
        // ------------------------------------
        $display("\nTEST 7: SRA");

        apply_instruction(
            {6'b000000, 5'd0, 5'd9, 5'd10,
             5'd3, 6'b000011},
            32'h00001018
        );

        check(ALUControlE, 4'b1010, "SRA ALUControlE");
        check(SignImmE[10:6], 5'd3, "SRA Shift Amount");
        check(RtE, 5'd9, "SRA RtE");
        check(RdE, 5'd10, "SRA RdE");

        // ------------------------------------
        // TEST 8: Jump
        // ------------------------------------
        $display("\nTEST 8: Jump");

        apply_instruction(
            {6'b000010, 26'h0001234},
            32'hA0001004
        );

        check(JumpD, 1, "JumpD");
        check(PCJumpD, 32'hA00048D0, "Jump Target");
        check(RegWriteE, 0, "Jump RegWriteE");
        check(MemWriteE, 0, "Jump MemWriteE");

        // ------------------------------------
        // Final result
        // ------------------------------------
        if (errors == 0)
            $display("\nALL DECODE TESTS PASSED!");
        else
            $display("\nDECODE TESTS FAILED: %0d errors", errors);

        $stop;
    end

endmodule
