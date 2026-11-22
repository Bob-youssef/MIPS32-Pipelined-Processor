// Top-Level 5-Stage Pipelined MIPS32 Processor (Milestone 1)
// Stages: IF -> IF/ID -> ID (+ ID/EX in decode) -> EX -> EX/MEM -> MEM -> MEM/WB -> WB
// Inputs: clk, reset

module mips (
    input clk,
    input reset
);

    // IF stage signals
    wire [31:0] PCF, PCPlus4F, PCBrNext, PCNext, InstrF;

    // ID stage signals
    wire [31:0] InstrD, PCPlus4D, PCJumpD;
    wire JumpD;

    // EX stage signals
    wire [31:0] RD1E, RD2E, SignImmE, PCPlus4E;
    wire [4:0] RtE, RdE, WriteRegE;
    wire [3:0] ALUControlE;
    wire RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUSrcE, RegDstE;
    wire [31:0] ALUOutE, WriteDataE, PCBranchE;
    wire ZeroE;

    // MEM stage signals
    wire RegWriteM, MemtoRegM, MemWriteM, BranchM, ZeroM, PCSrcM;
    wire [31:0] ALUOutM, WriteDataM, PCBranchM, ReadDataM;
    wire [4:0] WriteRegM;

    // WB stage signals
    wire RegWriteW, MemtoRegW;
    wire [31:0] ALUOutW, ReadDataW, ResultW;
    wire [4:0] WriteRegW;

    // IF stage (JumpD has priority over PCSrcM)
    mux2 pcbrmux (
        .d0(PCPlus4F),
        .d1(PCBranchM),
        .s(PCSrcM),
        .y(PCBrNext)
    );

    mux2 pcmux (
        .d0(PCBrNext),
        .d1(PCJumpD),
        .s(JumpD),
        .y(PCNext)
    );

    pc_reg pc_reg_0 (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PCF(PCF)
    );

    adder pcadd1 (
        .a(PCF),
        .b(32'd4),
        .y(PCPlus4F)
    );

    imem imem1 (
        .a(PCF),
        .rd(InstrF)
    );

    // IF/ID pipeline register
    if_id if_id_0 (
        .clk(clk),
        .reset(reset),
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .InstrD(InstrD),
        .PCPlus4D(PCPlus4D)
    );

    // ID stage + ID/EX pipeline register
    decode decode_0 (
        .clk(clk),
        .reset(reset),
        .instrD(InstrD),
        .PCPlus4D(PCPlus4D),
        .WriteRegW(WriteRegW),
        .WE3(RegWriteW),
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

    // EX stage
    execute execute_0 (
        .RD1E(RD1E),
        .RD2E(RD2E),
        .SignImmE(SignImmE),
        .PCPlus4E(PCPlus4E),
        .RtE(RtE),
        .RdE(RdE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .RegDstE(RegDstE),
        .ALUOutE(ALUOutE),
        .ZeroE(ZeroE),
        .WriteDataE(WriteDataE),
        .WriteRegE(WriteRegE),
        .PCBranchE(PCBranchE)
    );

    // EX/MEM pipeline register
    ex_mem ex_mem_0 (
        .clk(clk),
        .reset(reset),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .MemtoRegE(MemtoRegE),
        .BranchE(BranchE),
        .ZeroE(ZeroE),
        .ALUOutE(ALUOutE),
        .WriteDataE(WriteDataE),
        .PCBranchE(PCBranchE),
        .WriteRegE(WriteRegE),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .MemWriteM(MemWriteM),
        .BranchM(BranchM),
        .ALUOutM(ALUOutM),
        .WriteDataM(WriteDataM),
        .PCBranchM(PCBranchM),
        .WriteRegM(WriteRegM),
        .ZeroM(ZeroM)
    );

    // MEM stage
    assign PCSrcM = BranchM & ZeroM;

    dmem dmem1 (
        .clk(clk),
        .we(MemWriteM),
        .a(ALUOutM),
        .wd(WriteDataM),
        .rd(ReadDataM)
    );

    // MEM/WB pipeline register
    mem_wb mem_wb_0 (
        .clk(clk),
        .reset(reset),
        .RegWriteM(RegWriteM),
        .MemtoRegM(MemtoRegM),
        .ALUOutM(ALUOutM),
        .ReadDataM(ReadDataM),
        .WriteRegM(WriteRegM),
        .RegWriteW(RegWriteW),
        .MemtoRegW(MemtoRegW),
        .ALUOutW(ALUOutW),
        .ReadDataW(ReadDataW),
        .WriteRegW(WriteRegW)
    );

    // WB stage
    mux2 resmux (
        .d0(ALUOutW),
        .d1(ReadDataW),
        .s(MemtoRegW),
        .y(ResultW)
    );

endmodule
