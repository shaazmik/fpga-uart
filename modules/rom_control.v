module rom_control #(parameter ADDR_WIDTH = 5, parameter DATA_WIDTH = 8)(
    
    input wire clk,

    input wire next_addr, // signal for next addr

    output reg [ADDR_WIDTH - 1:0]addr = 0
);

always @(posedge clk) begin
    
    if (next_addr && addr != 2**ADDR_WIDTH - 1)
        addr <= addr + 1;
end

endmodule