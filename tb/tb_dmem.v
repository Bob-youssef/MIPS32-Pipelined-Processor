`timescale 1ns/1ps

module tb_dmem;
    reg clk; 
    reg we; 
    reg [31:0] a; 
    reg [31:0] wd; 
    wire [31:0] rd;


    dmem uut (.clk(clk), .we(we), .a(a), .wd(wd), .rd(rd));
    
    initial clk = 0; always #5 clk=~clk; 

    initial begin
        $dumpfile("waves/vcd/dmem_waves.vcd");
        $dumpvars(1, tb_dmem);
        
        //idle state
        we = 0; 
        a = 32'h0;
        wd = 32'h0;
        #12; 
        
        //test 1
        a = 32'h00000004;
        wd = 32'h000000AA; 
        we = 1; 
        #10
        we = 0;

        //read back test 1
        #5
        $display("At Address 0x%08h -> rd = 0x%08h (Expected: 0x000000AA)", a, rd);


        //test 2
        #5
        a  = 32'h00000008;
        wd = 32'h12345678;
        we = 1; 
        #10
        we = 0; 

        //read back test 2
        #5
        $display("At Address 0x%08h -> rd = 0x%08h (Expected: 0x12345678)", a, rd);

        //i try to write when we = 0, shouldn't work 
         a  = 32'h00000004;
        wd = 32'hFFFFFFFF;
        we = 0;              
        #10;
        $display("At Address 0x%08h (we=0) -> rd = 0x%08h (Must stay: 0x000000AA)", a, rd);

        $finish;
    end
endmodule