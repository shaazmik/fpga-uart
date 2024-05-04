module uart_tx #(
    parameter CLK_FREQ = 14745600, 
    parameter BAUDRATE = 115200, 
    parameter DATA_WIDTH = 8
) (
    input wire clk,
    input wire next_addr,
    input wire start, // ready data to transmit
    input wire [DATA_WIDTH - 1:0] transmit_data, // data from source, for example ROM
    
    output reg tx_line
);

reg is_send;

assign next_addr = is_send;

initial begin 
    tx_line = 1;
    is_send = 0;
end

localparam  TX_IDLE   = 3'd0,
            TX_START  = 3'd1,
            TX_RUN    = 3'd2,
            TX_LAST   = 3'd3,
            TX_FINISH = 3'd4;


wire tx_strobe;
reg reset = 0;

// Clock division for baud rate adjustment
clk_strobe #(
    .DIV(CLK_FREQ / BAUDRATE)
) clk_div (
    .clk(clk), 
    .strobe(tx_strobe),
    .reset(reset)
);


reg [DATA_WIDTH - 1:0] data = 0;
reg [3:0] bit_num = 0;
reg [3:0] state = TX_IDLE;


always @(posedge clk) begin
    case (state)
        TX_IDLE: begin
            if (start) begin
                is_send <= 0;
                state <= TX_START;
                reset <= 1'b1;
            end
        end
        TX_START: begin
            if (tx_strobe) begin
                data <= transmit_data;
                state <= TX_RUN;
                bit_num <= 0;
                tx_line <= 0;
            end
        end
        TX_RUN: begin
            if (tx_strobe) begin
                if (bit_num != DATA_WIDTH) begin
                    tx_line <= data[bit_num];
                    bit_num <= bit_num + 1;
                end 
                else begin
                    state <= TX_LAST;
                end
            end
        end
        TX_LAST: begin
            if (tx_strobe) begin
                state <= TX_FINISH;
                tx_line <= 1;
            end
        end
        TX_FINISH: begin
            state <= TX_IDLE;
            is_send <= 1;
            reset <= 1'b0;            
        end
        default: state <= TX_IDLE;
    endcase
end

endmodule
