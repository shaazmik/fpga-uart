module uart_rx #(
    parameter CLK_FREQ = 14745600,  // Clock frequency
    parameter BAUDRATE = 115200,    // Baud rate
    parameter DATA_WIDTH = 8        // Data width
) (
    input wire clk,
    input wire reset,
    input wire line,                 // RX line (serial input)
    output reg [DATA_WIDTH-1:0] receive_data = 0, // Received data
    output wire ready                // Ready signal indicating data reception is complete
);


endmodule
