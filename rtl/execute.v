// Execute stage (combinational): ALUSrc mux, ALU, RegDst mux and branch target adder.
// The outputs go to ex_mem.
// inputs:  RD1E, RD2E, SignImmE, PCPlus4E, RtE, RdE, ALUControlE, ALUSrcE, RegDstE (from decode)
// outputs: ALUOutE, ZeroE, WriteDataE, WriteRegE, PCBranchE

module execute (
    input [31:0] RD1E, RD2E, SignImmE, PCPlus4E,
    input [4:0] RtE, RdE,
    input [3:0] ALUControlE,
    input ALUSrcE, RegDstE,
    output [31:0] ALUOutE,
    output ZeroE,
    output [31:0] WriteDataE,
    output [4:0] WriteRegE,
    output [31:0] PCBranchE
);

wire [31:0] SrcAE, SrcBE, SignImmShE;
wire [4:0] shamtE;

assign SrcAE = RD1E;
assign WriteDataE = RD2E;
assign shamtE = SignImmE[10:6];

mux2 srcbmux (.d0(RD2E), .d1(SignImmE), .s(ALUSrcE), .y(SrcBE));

alu alu_0 (
    .SrcAE(SrcAE),
    .SrcBE(SrcBE),
    .ALUControlE(ALUControlE),
    .shamtE(shamtE),
    .ALUOutE(ALUOutE),
    .ZeroE(ZeroE)
);

mux2 #(5) wrmux (.d0(RtE), .d1(RdE), .s(RegDstE), .y(WriteRegE));

sl2 immsh (.a(SignImmE), .y(SignImmShE));
adder pcadd2 (.a(SignImmShE), .b(PCPlus4E), .y(PCBranchE));

endmodule
