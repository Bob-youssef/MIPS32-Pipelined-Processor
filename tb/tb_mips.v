`timescale 1ns/1ps

// top level testbench: loads test1 or test2 into imem, runs the pipeline,
// prints PC / instruction every cycle, then checks the registers and dmem.
//
// runs test 1 by default, run test 2 with:  xsim ... -testplusarg test2
// (in a Vivado project add test1.hex / test2.hex to the simulation sources)

// change these if the instance names inside mips.v are different
`define IMEM   dut.imem1.RAM
`define DMEM   dut.dmem1.RAM
`define RF     dut.decode_0.register_file_0.registers
`define PC     dut.PCF
`define INSTRD dut.InstrD

module tb_mips;
    reg clk, reset;

    mips dut (.clk(clk), .reset(reset));

    integer test, cycles, errors, i;
    reg [8*64-1:0] hexfile;

    always #5 clk = ~clk;

    task check;
        input [8*8-1:0] name;
        input [31:0] got, expected;
        begin
            if (got !== expected) begin
                $display("FAIL: %0s = %h, expected %h", name, got, expected);
                errors = errors + 1;
            end else
                $display("PASS: %0s = %h", name, got);
        end
    endtask

    initial begin
        errors = 0;
        if ($test$plusargs("test2")) begin
            test = 2; hexfile = "test/test2.hex"; cycles = 34;
            $dumpfile("waves/vcd/mips_test2.vcd");
        end else begin
            test = 1; hexfile = "test/test1.hex"; cycles = 22;
            $dumpfile("waves/vcd/mips_test1.vcd");
        end

        $dumpvars(0, tb_mips);

        clk = 0;
        reset = 1;
        #1;
        for (i = 0; i < 64; i = i + 1) `IMEM[i] = 32'h00000000;
        $readmemh(hexfile, `IMEM);
        $display("running test %0d (%0s) for %0d cycles", test, hexfile, cycles);

        #21 reset = 0;

        for (i = 1; i <= cycles; i = i + 1) begin
            @(posedge clk); #1;
            $display("cycle %2d: PCF = %h  InstrD = %h", i, `PC, `INSTRD);
        end

        $display("---- registers ----");
        if (test == 2) begin
            check("$t0", `RF[8],  32'h000080FF);
            check("$t1", `RF[9],  32'hFFFFFFF0);
            check("$t2", `RF[10], 32'h000080F0);
            check("$t3", `RF[11], 32'h00000055);
            check("$t4", `RF[12], 32'h00000000);
            check("$t5", `RF[13], 32'h00000055);
            check("$t6", `RF[14], 32'h00000000);
            check("$t7", `RF[15], 32'h00008100);
            $display("---- data memory ----");
            check("mem[4]", `DMEM[1], 32'h00000055);
            check("mem[8]", `DMEM[2], 32'h00008100);
        end else begin
            check("$t0", `RF[8],  5);
            check("$t1", `RF[9],  10);
            check("$t2", `RF[10], 15);
            check("$t3", `RF[11], 5);
            check("$t4", `RF[12], 0);
            check("$t5", `RF[13], 15);
            check("$t6", `RF[14], 15);
            check("$t7", `RF[15], 40);
            check("$s0", `RF[16], 5);
            check("$s1", `RF[17], 5);
        end

        if (errors == 0) $display("TEST %0d PASSED", test);
        else $display("TEST %0d FAILED (%0d errors)", test, errors);
        $finish;
    end
endmodule
