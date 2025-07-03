`timescale 1ns/1ps

module top_tb();

    // ======================
    // Common Signals
    // ======================
    reg clk;
    reg rstn;
    
    // Clock generation (50MHz)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Reset generation
    initial begin
        rstn = 1;
        #5 rstn = 0;  // Assert reset
        #20 rstn = 1; // Release reset
    end

    // ======================
    // Transmitter Instance
    // ======================
    reg tx_en;
    reg tx_d_ready;
    wire tx_serial_out;
    reg [7:0] tx_d_in;
    
    transmitter #(.WIDTH(8)) tx_dut (
        .en(tx_en),
        .clk(clk),
        .d_ready(tx_d_ready),
        .rstn(rstn),
        .tx_data(tx_serial_out),
        .d_in(tx_d_in)
    );

    // ======================
    // Receiver Instance 
    // ======================
    wire rx_serial_in = tx_serial_out; // Loopback connection
    wire [7:0] rx_d_out;
    wire rx_fifo_we_en;
    
    receiver #(.WIDTH(8)) rx_dut (
        .clk(clk),
        .rstn(rstn),
        .rx_data(rx_serial_in),
        .d_out(rx_d_out),
        .fifo_we_en(rx_fifo_we_en)
    );

    // ======================
    // Test Stimulus
    // ======================
    initial begin
        // Initialize
        tx_en = 0;
        tx_d_ready = 0;
        tx_d_in = 0;
        
        // Wait for reset to complete
        @(posedge rstn);
        #10;
        
        // Test Case 1: Send 0xA5
        tx_en = 1;
        tx_d_in = 8'hA5;
        tx_d_ready = 1;
        @(posedge clk);
        tx_d_ready = 0;
        
        // Wait for transmission to complete
        repeat(12) @(posedge clk);
        
        // Test Case 2: Send 0x3C
        tx_d_in = 8'h3C;
        tx_d_ready = 1;
        @(posedge clk);
        tx_d_ready = 0;
        
        // Wait and finish
        repeat(20) @(posedge clk);
        $display("Simulation complete");
        $finish;
    end

    // ======================
    // Monitor Received Data
    // ======================
    always @(posedge rx_fifo_we_en) begin
        $display("[RX] Received data: 0x%h", rx_d_out);
    end

    // ======================
    // Waveform Dumping
    // ======================
    initial begin
        $dumpfile("uart_loopback.vcd");
        $dumpvars(0, top_tb);
    end

endmodule