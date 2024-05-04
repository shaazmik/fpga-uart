module uart_rx #(
    parameter CLK_FREQ = 14745600,  // Clock frequency
    parameter BAUDRATE = 115200,    // Baud rate
    parameter DATA_WIDTH = 8        // Data width
) (
    input wire clk,
    input wire tx_line,          
    
    output reg [DATA_WIDTH-1:0] receive_data = 0, 
    output reg is_receiving,         
    output reg is_finished
);


localparam  RX_IDLE   = 3'd0,
            RX_RECV   = 3'd1,
            RX_LAST   = 3'd2,
            RX_FINISH = 3'd3;

initial begin
    is_receiving = 0;
    is_finished  = 0;
    receive_data = 0;
end

wire rx_strobe;
reg reset = 1'b0;
// Clock division for baud rate adjustment
clk_strobe #(
    .DIV(CLK_FREQ / BAUDRATE)
) clk_div (
    .clk(clk), 
    .strobe(rx_strobe),
    .reset(reset)
);


reg [3:0]state   = RX_IDLE;
reg [3:0]bit_num = 0;

always @(posedge clk) begin
    case (state)
        RX_IDLE:
            if (tx_line == 0) begin
                state <= RX_RECV;
                is_receiving <= 1;
                is_finished <= 0;
                reset <= 1'b1;        
                 receive_data <= 0;
                bit_num <= 0;
            end
        RX_RECV:
            if (rx_strobe) begin
                if (bit_num != DATA_WIDTH) begin
                    receive_data[bit_num] <= tx_line;          
                    bit_num <= bit_num + 1;
                end
                else begin
                    state <= RX_LAST;
                end
            end
        RX_LAST:
            if (rx_strobe) begin
                is_finished <= 1;
                state <= RX_FINISH;
            end
        RX_FINISH: begin
            state <= RX_IDLE;
            is_receiving <= 0;
            reset <= 0;
        end
        default: state <= RX_IDLE;
    endcase
end



endmodule
