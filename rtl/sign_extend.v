// 16-to-32 bit immediate extender (ZeroExtD=1 for zero-ext, 0 for sign-ext)
// inputs: ImmD, ZeroExtD    output: SignImmD

module sign_extend (
    input [15:0] ImmD,
    input ZeroExtD,
    output reg [31:0] SignImmD
);
    
always @(*) begin
    if(ZeroExtD) SignImmD = {16'b0, ImmD};
    else SignImmD = { {16{ImmD[15]}} , ImmD};
end
endmodule