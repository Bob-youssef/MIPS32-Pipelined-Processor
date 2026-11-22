// Data memory (64x32 RAM, combinational read, synchronous posedge write)
// inputs: clk, we, a, wd    output: rd

module dmem (
    input clk, we, 
    input [31:0] a, 
    input [31:0] wd, 
    output [31:0] rd
);

    reg [31:0] RAM [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            RAM[i] = 32'h00000000;
    end

    assign rd = RAM[a[7:2]];

    always @(posedge clk) begin
        if (we) RAM[a[7:2]] <= wd;
    end

endmodule