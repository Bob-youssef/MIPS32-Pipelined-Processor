module decode (
    input clk,
    input reset,
    input [31:0] instrD,
    input [31:0] PCPlus4D,
    input [4:0] WriteRegW,
    input WE3,
    input [31:0] ResultW,

    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg RegWriteE,
    output reg MemtoRegE,
    output reg MemWriteE,
    output reg BranchE,
    output reg [3:0] ALUControlE,
    output reg ALUSrcE,
    output reg RegDstE,

    output JumpD,
    output [31:0] PCJumpD,

    output reg [4:0] RtE,
    output reg [4:0] RdE,

    output reg [31:0] SignImmE,
    output reg [31:0] PCPlus4E

);


    
wire [5:0] Op;
wire [5:0] Funct;
wire RegWriteD;
wire MemtoRegD;
wire MemWriteD;
wire BranchD;
wire [3:0] ALUControlD;
wire ALUSrcD;
wire RegDstD;
wire ZeroExtD;


assign Op = instrD[31:26];
assign Funct = instrD[5:0];
control_unit control_unit_0 (
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

wire [31:0] RD1;
wire [31:0] RD2;
register_file register_file_0 (
    .clk(clk),
    .A1(instrD[25:21]),
    .A2(instrD[20:16]),
    .A3(WriteRegW),
    .WD3(ResultW),
    .WE3(WE3),
    .RD1(RD1),
    .RD2(RD2)
);

wire [31:0] SignImmD;
sign_extend sign_extend_0 (
    .ZeroExtD(ZeroExtD),
    .ImmD(instrD[15:0]),
    .SignImmD(SignImmD)
);

wire [25:0] target;
assign target = instrD[25:0];
assign PCJumpD = {PCPlus4D[31:28],target,2'b00};

always @(posedge clk or posedge reset) begin
    if(reset) begin
        RegWriteE<=0;
        MemtoRegE<=0;
        MemWriteE<=0;
        BranchE<=0;
        ALUControlE<=0;
        ALUSrcE<=0;
        RegDstE<=0;
        RtE<=0;
        RdE<=0;
        RD1E<=0;
        RD2E<=0;
        SignImmE<=0;
        PCPlus4E<=0;
    end else begin
        RegWriteE<=RegWriteD;
        MemtoRegE<=MemtoRegD;
        MemWriteE<=MemWriteD;
        BranchE<=BranchD;
        ALUControlE<=ALUControlD;
        ALUSrcE<=ALUSrcD;
        RegDstE<=RegDstD;
        RtE<=instrD[20:16];
        RdE<=instrD[15:11];
        RD1E<=RD1;
        RD2E<=RD2;
        SignImmE<=SignImmD;
        PCPlus4E<=PCPlus4D;
    end
end
endmodule