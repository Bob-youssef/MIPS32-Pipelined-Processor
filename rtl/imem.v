module imem (
    input [31:0] a, 
    output [31:0] rd 
);

    reg [31:0] RAM [0:63]; 
    initial begin 
        $readmemh("test/test1.hex", RAM);
    end

    always @(*) begin
        rd = RAM[a[7:2]];
    end 
endmodule