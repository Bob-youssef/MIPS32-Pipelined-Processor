`timescale 1ns/1ps

// testbench for mux2 (32-bit and 5-bit)

module tb_mux2;
    reg [31:0] d0, d1;
    reg s;
    wire [31:0] y;

    reg [4:0] a0, a1;
    reg s5;
    wire [4:0] y5;

    mux2 uut (.d0(d0), .d1(d1), .s(s), .y(y));
    mux2 #(5) uut5 (.d0(a0), .d1(a1), .s(s5), .y(y5));

    integer errors = 0;

    initial begin
        $dumpfile("waves/vcd/mux2.vcd");
        $dumpvars(0, tb_mux2);

        d0 = 32'hAAAAAAAA; d1 = 32'h55555555;
        s = 0; #10;
        if (y !== 32'hAAAAAAAA) begin $display("FAIL: s=0, y=%h", y); errors = errors + 1; end
        else $display("PASS: s=0, y=%h", y);

        s = 1; #10;
        if (y !== 32'h55555555) begin $display("FAIL: s=1, y=%h", y); errors = errors + 1; end
        else $display("PASS: s=1, y=%h", y);

        d1 = 32'h12345678; #10;
        if (y !== 32'h12345678) begin $display("FAIL: d1 changed, y=%h", y); errors = errors + 1; end
        else $display("PASS: d1 changed, y=%h", y);

        a0 = 5'd8; a1 = 5'd10;
        s5 = 0; #10;
        if (y5 !== 5'd8) begin $display("FAIL: 5-bit s=0, y=%0d", y5); errors = errors + 1; end
        else $display("PASS: 5-bit s=0, y=%0d", y5);

        s5 = 1; #10;
        if (y5 !== 5'd10) begin $display("FAIL: 5-bit s=1, y=%0d", y5); errors = errors + 1; end
        else $display("PASS: 5-bit s=1, y=%0d", y5);

        if (errors == 0) $display("tb_mux2: ALL TESTS PASSED");
        else $display("tb_mux2: %0d TESTS FAILED", errors);
        $finish;
    end
endmodule
