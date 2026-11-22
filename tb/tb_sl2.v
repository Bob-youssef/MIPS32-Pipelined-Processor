`timescale 1ns/1ps

// testbench for sl2

module tb_sl2;
    reg [31:0] a;
    wire [31:0] y;

    sl2 uut (.a(a), .y(y));

    integer errors = 0;

    task check;
        input [31:0] expected;
        begin
            #10;
            if (y !== expected) begin
                $display("FAIL: sl2(%h) = %h, expected %h", a, y, expected);
                errors = errors + 1;
            end else
                $display("PASS: sl2(%h) = %h", a, y);
        end
    endtask

    initial begin
        $dumpfile("waves/vcd/sl2.vcd");
        $dumpvars(0, tb_sl2);

        a = 0; check(0);
        a = 1; check(4);
        a = 10; check(32'h28);
        a = 32'hFFFFFFFF; check(32'hFFFFFFFC);
        a = 32'hFFFFFFF0; check(32'hFFFFFFC0);

        if (errors == 0) $display("tb_sl2: ALL TESTS PASSED");
        else $display("tb_sl2: %0d TESTS FAILED", errors);
        $finish;
    end
endmodule
