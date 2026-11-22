// Instruction memory (64x32 combinational ROM, word-addressed via a[7:2])
// input: a    output: rd

module imem #(
    parameter MEMFILE = "test/test1.hex"
) (
    input  [31:0] a, 
    output [31:0] rd 
);

    reg [31:0] RAM [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            RAM[i] = 32'h00000000;
        $readmemh(MEMFILE, RAM);
    end

    assign rd = RAM[a[7:2]];

endmodule