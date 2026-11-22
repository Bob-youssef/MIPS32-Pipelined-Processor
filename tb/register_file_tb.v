
`timescale 1ns / 1ps

module register_file_tb;

    reg clk;
    reg WE3;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD3;

    wire [31:0] RD1, RD2;

    integer errors;

    // Instantiate the register file
    register_file uut (
        .clk(clk),
        .WE3(WE3),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .RD1(RD1),
        .RD2(RD2)
    );

    // Clock: period = 10 ns
    always #5 clk = ~clk;

    // Task to check expected results
    task check;
        input [31:0] actual;
        input [31:0] expected;
        input [255:0] test_name;
        begin
            if (actual !== expected) begin
                $display("FAIL: %0s | Expected = %h, Actual = %h",
                         test_name, expected, actual);
                errors = errors + 1;
            end
            else begin
                $display("PASS: %0s", test_name);
            end
        end
    endtask

    initial begin

        $dumpfile("waves/vcd/register_file_waves.vcd");
        $dumpvars(0, register_file_tb);

        // Initialize inputs
        clk = 0;
        WE3 = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;
        errors = 0;

        // Test 1: Register zero always reads zero
        #1;
        check(RD1, 32'd0, "Read register zero");

        // Test 2: Write to register 5
        WE3 = 1;
        A3 = 5;
        WD3 = 32'h12345678;

        @(negedge clk);
        #1;

        A1 = 5;
        #1;
        check(RD1, 32'h12345678, "Write and read register 5");

        // Test 3: Write to register 9
        A3 = 9;
        WD3 = 32'hABCDEF12;

        @(negedge clk);
        #1;

        A1 = 5;
        A2 = 9;
        #1;

        check(RD1, 32'h12345678, "Read register 5");
        check(RD2, 32'hABCDEF12, "Read register 9");

        // Test 4: Write enable disabled
        WE3 = 0;
        A3 = 5;
        WD3 = 32'hFFFFFFFF;

        @(negedge clk);
        #1;

        check(RD1, 32'h12345678, "Write disabled");

        // Test 5: Attempt writing to register zero
        WE3 = 1;
        A3 = 0;
        WD3 = 32'hFFFFFFFF;

        @(negedge clk);
        #1;

        A1 = 0;
        #1;

        check(RD1, 32'd0, "Register zero cannot be modified");

        // Test 6: Overwrite register 5
        A3 = 5;
        WD3 = 32'hDEADBEEF;

        @(negedge clk);
        #1;

        A1 = 5;
        #1;

        check(RD1, 32'hDEADBEEF, "Overwrite register 5");

        // Test 7: Read two registers simultaneously
        WE3 = 0;
        A1 = 9;
        A2 = 5;

        #1;

        check(RD1, 32'hABCDEF12, "Simultaneous read port 1");
        check(RD2, 32'hDEADBEEF, "Simultaneous read port 2");

        // Final result
        if (errors == 0)
            $display("\nALL TESTS PASSED!");
        else
            $display("\nTESTBENCH FAILED: %0d errors", errors);

        $stop;
    end

endmodule
