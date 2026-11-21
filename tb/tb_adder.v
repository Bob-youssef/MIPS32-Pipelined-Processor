`timescale 1ns/1ps

// testbench for adder

module tb_adder;
    reg [31:0] a, b;
    wire [31:0] y;

    adder uut (.a(a), .b(b), .y(y));

    integer errors = 0;

    task check;
        input [31:0] expected;
        begin
            #10;
            if (y !== expected) begin
                $display("FAIL: %h + %h = %h, expected %h", a, b, y, expected);
                errors = errors + 1;
            end else
                $display("PASS: %h + %h = %h", a, b, y);
        end
    endtask

    initial begin
        $dumpfile("waves/vcd/adder.vcd");
        $dumpvars(0, tb_adder);

        a = 0; b = 0; check(0);
        a = 0; b = 4; check(4);
        a = 32'h38; b = 32'h10; check(32'h48);
        a = 32'h10; b = 32'hFFFFFFF0; check(0);
        a = 32'hFFFFFFFF; b = 1; check(0);

        if (errors == 0) $display("tb_adder: ALL TESTS PASSED");
        else $display("tb_adder: %0d TESTS FAILED", errors);
        $finish;
    end
endmodule
