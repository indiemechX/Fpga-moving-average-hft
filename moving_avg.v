module moving_avg (
    input wire clk,
    input wire rst_n,          // Active-low asynchronous reset
    input wire [7:0] price_in, // 8-bit incoming stock price
    output reg [7:0] sma_out   // 8-bit calculated moving average
);

    // Shift register to store the last 4 stock price samples
    reg [7:0] shift_reg [0:3];
    
    // 10-bit register to prevent overflow when adding four 8-bit numbers
    reg [9:0] sum;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear shift registers and outputs on reset
            shift_reg[0] <= 8'd0;
            shift_reg[1] <= 8'd0;
            shift_reg[2] <= 8'd0;
            shift_reg[3] <= 8'd0;
            sum          <= 10'd0;
            sma_out      <= 8'd0;
        end else begin
            // Shift older price samples down the pipeline
            shift_reg[3] <= shift_reg[2];
            shift_reg[2] <= shift_reg[1];
            shift_reg[1] <= shift_reg[0];
            shift_reg[0] <= price_in;

            // Compute total sum of the last 4 prices
            sum <= shift_reg[0] + shift_reg[1] + shift_reg[2] + shift_reg[3];

            // Divide sum by 4 (shift right by 2 bits) to get the average
            sma_out <= sum >> 2;
        end
    end

endmodule