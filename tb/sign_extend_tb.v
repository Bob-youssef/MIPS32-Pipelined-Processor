module sign_extend_tb ();

reg [15:0] ImmD;
reg ZeroExtD;
wire [31:0] SignImmD;

reg [31:0] SignImmD_expected;

sign_extend dut (
    .ImmD(ImmD),
    .ZeroExtD(ZeroExtD),
    .SignImmD(SignImmD)
);

task check;
    input [31:0] SignImmD;
    input [31:0] SignImmD_expected;
    begin
        if(SignImmD!==SignImmD_expected) begin
            $display("Error");
            $display("SignImmD=%b, SignImmD_expected=%b", SignImmD, SignImmD_expected);
            $stop;
        end
    end
endtask
initial begin
    repeat(10) begin
        ZeroExtD=1;
        ImmD=$random;
        SignImmD_expected = ImmD;
        #10;
        check(SignImmD, SignImmD_expected);
    end
    
    repeat(10) begin
        ZeroExtD=0;
        ImmD=$random;
        SignImmD_expected=ImmD;
        if(ImmD[15]===1) SignImmD_expected = SignImmD_expected + (((1<<16)-1)<<16);
        #10;
        check(SignImmD, SignImmD_expected);

    end

    $display("Tests passed");
    $stop;

end
    
endmodule