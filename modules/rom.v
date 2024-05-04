module rom #(parameter ADDR_WIDTH = 5, parameter WIDTH = 8)(
    input [ADDR_WIDTH - 1:0]addr,
    input clk,

    output reg [WIDTH - 1:0]q,
    output reg is_data
);


reg [WIDTH - 1:0]mem[2**ADDR_WIDTH - 1:0];

initial begin
    $readmemh("cmd/test.txt", mem);
    q <=mem[0];
    is_data <= 1;
end

always @(posedge clk) begin
    q <= mem[addr];
    if (q == 0) begin
        is_data <= 0;
    end
end

endmodule