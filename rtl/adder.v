// 32-bit adder, used for PC+4 and the branch target
// inputs: a, b    output: y = a + b

module adder (
    input [31:0] a, b,
    output [31:0] y
);

assign y = a + b;

endmodule
