`timescale 1 ns / 100 ps

module testbench();

parameter CLK_FREQ = 1036800;

parameter BAUDRATE = 115200;

parameter ADDR_WIDTH = 5;

parameter DATA_WIDTH = 7;

reg clk = 1'b0;

always begin
    #1 clk = ~clk;
end


wire [ADDR_WIDTH - 1:0]addr;

wire [DATA_WIDTH - 1:0]transmit_data;

wire [DATA_WIDTH - 1:0]receive_data;

rom_control #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) rom_control(
    .clk(clk),
    .next_addr(uart_next_addr), 
    .addr(addr)
);

rom #(.ADDR_WIDTH(ADDR_WIDTH), .WIDTH(DATA_WIDTH)) rom(
    .clk(clk), 
    .addr(addr),
    .q(transmit_data),
    .is_data(uart_tx_start)
);

wire uart_next_addr;

wire uart_tx_line;

wire uart_tx_start;

wire uart_rx_ready;

uart_tx #(.CLK_FREQ(CLK_FREQ), .BAUDRATE(BAUDRATE), .DATA_WIDTH(DATA_WIDTH)) uart_tx(
    .clk(clk), 
    .start(uart_tx_start), 
    .transmit_data(transmit_data),
    .tx_line(uart_tx_line),
    .next_addr(uart_next_addr)
);


reg [2**ADDR_WIDTH - 1: 0] recv_ct = 0; // counter for recievied data
reg [DATA_WIDTH - 1:0]recv_data = 0;  // data for printing

always @(posedge clk) begin
    
    recv_ct <= recv_ct + (uart_rx_ready);

    recv_data <= receive_data;
end

initial begin
    
    $monitor("[$monitor] recv_data[%02d]=0x%0h (%0c)", recv_ct, recv_data, recv_data);

    $dumpvars;
    
    $display("Test started...");
    
    #10000 $finish;
end

endmodule