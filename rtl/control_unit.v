module control_unit (
    input [5:0] Op,
    input [5:0] Funct,
    output RegWriteD,
    output MemtoRegD,
    output MemWriteD,
    output BranchD,
    output reg [3:0] ALUControlD,
    output ALUSrcD,
    output RegDstD,
    output JumpD,
    output ZeroExtD 
);


wire [2:0] ALUOp;
reg [10:0] control_signals;
assign {RegWriteD, RegDstD, ALUSrcD, BranchD, MemWriteD, MemtoRegD, JumpD, ZeroExtD,ALUOp} = control_signals;


always @(*) begin
    case (Op) 
        6'b000_000 : control_signals = 'b11000000_010; // all R type
        6'b100_011 : control_signals = 'b10100100_000; // lw
        6'b101_011 : control_signals = 'b00101000_000; // sw 
        6'b000_100 : control_signals = 'b00010000_001; // beq 
        6'b001_000 : control_signals = 'b10100000_000; // addi
        6'b001_100 : control_signals = 'b10100001_011; // andi 
        6'b001_101 : control_signals = 'b10100001_100; // ori 
        6'b001_110 : control_signals = 'b10100001_101; // xori 
        6'b000_010 : control_signals = 'b00000010_000; // j 
        default : control_signals = 0;
    endcase
end


always @(*) begin
    casex ({ALUOp, Funct})
        {3'b000, 6'bxxxxxx}: ALUControlD = 4'b0010; // A+B
        {3'b001, 6'bxxxxxx}: ALUControlD = 4'b0110; // A-B
        {3'b011, 6'bxxxxxx}: ALUControlD = 4'b0000; // A&B
        {3'b100, 6'bxxxxxx}: ALUControlD = 4'b0001; // A|B
        {3'b101, 6'bxxxxxx}: ALUControlD = 4'b0100; // A^B

        // R-type instructions
        {3'b010, 6'b100000}: ALUControlD = 4'b0010; // ADD
        {3'b010, 6'b100010}: ALUControlD = 4'b0110; // SUB
        {3'b010, 6'b100100}: ALUControlD = 4'b0000; // AND
        {3'b010, 6'b100101}: ALUControlD = 4'b0001; // OR
        {3'b010, 6'b100110}: ALUControlD = 4'b0100; // XOR
        {3'b010, 6'b100111}: ALUControlD = 4'b0011; // NOR
        {3'b010, 6'b000000}: ALUControlD = 4'b1000; // SLL
        {3'b010, 6'b000010}: ALUControlD = 4'b1001; // SRL
        {3'b010, 6'b000011}: ALUControlD = 4'b1010; // SRA

        default: ALUControlD = 4'b0000;
    endcase
end



    
endmodule


// wire  RegWriteD;
// wire  MemtoRegD;
// wire  MemWriteD;
// wire  BranchD;
// wire [3:0] ALUControlD;
// wire  ALUSrcD;
// wire  RegDstD;

// always @(posedge clk or posedge reset) begin
//     if(reset) begin
//         RegWriteE<=0;
//         MemtoRegE<=0;
//         MemWriteE<=0;
//         BranchE<=0;
//         ALUControlE<=0;
//         ALUSrcE<=0;
//         RegDstE<=0;
//     end else begin
//         RegWriteE<=RegWriteD;
//         MemtoRegE<=MemtoRegD;
//         MemWriteE<=MemWriteD;
//         BranchE<=BranchD;
//         ALUControlE<=ALUControlD;
//         ALUSrcE<=ALUSrcD;
//         RegDstE<=RegDstD;
//     end
// end