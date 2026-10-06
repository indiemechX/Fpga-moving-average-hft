`timescale 1ns/1ps

module tb_moving_avg;

    reg clk;
    reg rst_n;
    reg [7:0] price_in;
    wire [7:0] sma_out;

    // Instantiate the Moving Average Unit Under Test (UUT)
    moving_avg uut (
        .clk(clk),
        .rst_n(rst_n),
        .price_in(price_in),
        .sma_out(sma_out)
    );

    // Generate 100MHz clock signal (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        rst_n = 0;
        price_in = 0;

        // Apply Reset
        #15 rst_n = 1;

        // Feed simulated stream of stock prices
        #10 price_in = 8'd10;  // Price = 10
        #10 price_in = 8'd20;  // Price = 20
        #10 price_in = 8'd30;  // Price = 30
        #10 price_in = 8'd40;  // Price = 40 (Average of 10,20,30,40 = 25)
        #10 price_in = 8'd50;  // Price = 50 (Average of 20,30,40,50 = 35)
        #10 price_in = 8'd20;  // Price = 20
        #10 price_in = 8'd10;  // Price = 10

        #50;
        $finish;
    end

endmodule