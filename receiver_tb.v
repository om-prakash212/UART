`timescale 1ns/1ps  // Sets simulation time unit to 1ns and precision to 1ps

module receiver_tb #(
    parameter WIDTH = 8  // Default data width is 8 bits
) ();
    // Testbench signals
    logic clk;          // Clock signal
    logic rstn;         // Active-low reset
    logic rx_data;      // Serial data input
    logic [WIDTH-1:0] d_out;  // Parallel data output
    logic fifo_we_en;   // FIFO write enable output

    // Instantiate the Device Under Test (DUT)
    receiver #(.WIDTH(WIDTH)) DUT (
        .clk(clk),        // Clock input
        .rstn(rstn),      // Reset input
        .rx_data(rx_data), // Serial data input
        .d_out(d_out),    // Parallel data output
        .fifo_we_en(fifo_we_en)  // FIFO write enable
    );

    // Clock generation (50MHz clock -> 20ns period)
    initial forever #10 clk = ~clk;

    // Main test sequence
    initial begin
        // Initialize all inputs
        clk = 0;
        rstn = 1;
        rx_data = 1;  // Idle state (UART normally high)

        // Reset sequence
        @(posedge clk);  // Wait for clock edge
        rstn = 0;        // Assert reset (active low)
        @(posedge clk);
        rstn = 1;        // Deassert reset

        // Simulate UART frame transmission (LSB first)
        // Start bit (0)
        @(posedge clk);
        rx_data = 0;
        
        // Data bits (01001000) - in reverse order (LSB first)
        // This represents hexadecimal 0x12 (binary 00010010)
        @(posedge clk); rx_data = 0;  // Bit 0
        @(posedge clk); rx_data = 1;  // Bit 1
        @(posedge clk); rx_data = 0;  // Bit 2
        @(posedge clk); rx_data = 0;  // Bit 3
        @(posedge clk); rx_data = 1;  // Bit 4
        @(posedge clk); rx_data = 0;  // Bit 5
        @(posedge clk); rx_data = 0;  // Bit 6
        @(posedge clk); rx_data = 0;  // Bit 7
        
        // Stop bit (1)
        @(posedge clk);
        rx_data = 1;

        // Wait for completion and end simulation
        #100
        $finish;
    end

    // Waveform dumping
    initial begin
        $dumpfile("receiver.vcd");  // Create waveform file
        $dumpvars;  // Dump all variables
    end

endmodule