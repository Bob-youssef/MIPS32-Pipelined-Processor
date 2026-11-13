`timescale 1ns/1ps

module tb_pc_reg; 

    reg clk;
    reg reset; 
    reg [31:0] PCNext;
    wire [31:0] PCF;
    
    pc_reg uut(.clk(clk), .reset(reset), .PCNext(PCNext), .PCF(PCF)); 

    initial clk = 0; always #5 clk=~clk; 

    initial begin 
        $dumpfile("waves/vcd/pc_reg_waves.vcd");
        $dumpvars(0, tb_pc_reg); 
        
        clk = 0; reset = 1; 
        PCNext = 32'h0; 
        #15 
        reset=0; 

        PCNext = 32'hAAAAAAAA; 
        #10
        
        PCNext = 32'h00000004; 
        #10

        $finish;
    end

endmodule 