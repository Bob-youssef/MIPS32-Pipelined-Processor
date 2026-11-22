// ALU: 9 operations selected by ALUControlE (Table 5.2), shifts work on SrcBE by shamtE
// inputs: SrcAE, SrcBE, ALUControlE, shamtE    outputs: ALUOutE, ZeroE

module alu (
    input [31:0] SrcAE, SrcBE,
    input [3:0] ALUControlE,
    input [4:0] shamtE,
    output reg [31:0] ALUOutE,
    output ZeroE
);

always @(*) begin
    case (ALUControlE)
        4'b0010: ALUOutE = SrcAE + SrcBE;
        4'b0110: ALUOutE = SrcAE - SrcBE;
        4'b0000: ALUOutE = SrcAE & SrcBE;
        4'b0001: ALUOutE = SrcAE | SrcBE;
        4'b0100: ALUOutE = SrcAE ^ SrcBE;
        4'b0011: ALUOutE = ~(SrcAE | SrcBE);
        4'b1000: ALUOutE = SrcBE << shamtE;
        4'b1001: ALUOutE = SrcBE >> shamtE;
        4'b1010: ALUOutE = $signed(SrcBE) >>> shamtE;
        default: ALUOutE = 32'h00000000;
    endcase
end

assign ZeroE = (ALUOutE == 0);

endmodule
