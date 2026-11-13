`timescale 1ns/1ps

module tb_imem; 
    reg [31:0] a; 
    wire [31:0] rd; 

    imem uut (.a(a), .rd(rd));

    initial begin 
        $dumpfile("waves/vcd/imem_waves.vcd");
        $dumpvars(1, tb_imem); 

        a = 32'h00000000;
        #10; 

        a = 32'h00000004;
        #10; 

        a = 32'h00000010;
        #10; 

        $finish;
    end 
endmodule 