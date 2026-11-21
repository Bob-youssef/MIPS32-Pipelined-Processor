// 2:1 mux, parameterized width (32 by default, 5 for RegDst)
// inputs: d0, d1, s    output: y = s ? d1 : d0

module mux2 #(parameter WIDTH = 32) (
    input [WIDTH-1:0] d0, d1,
    input s,
    output [WIDTH-1:0] y
);

assign y = s ? d1 : d0;

endmodule
