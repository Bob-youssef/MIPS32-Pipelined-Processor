// shift left by 2 (word offset -> byte offset for the branch target)
// input: a    output: y = a << 2

module sl2 (
    input [31:0] a,
    output [31:0] y
);

assign y = {a[29:0], 2'b00};

endmodule
