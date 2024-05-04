module clk_strobe #(parameter DIV = 4)(
    input clk,
    input reset,

    output strobe
);

reg [31:0]counter = 0;
assign strobe = (counter == DIV - 1);

always @(posedge clk) begin
    if (!reset || counter == DIV - 1)
        counter <= 0;
    else
        counter <= counter + 1;
end

endmodule