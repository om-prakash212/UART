`timescale 1ns/1ps  // Sets simulation time unit to 1ns and precision to 1ps

module transmitter_tb #(
    parameter WIDTH = 8  // Default data width is 8 bits
) ();

    // Testbench signals
    logic en, d_ready, clk, rstn, tx_data;
    logic [WIDTH-1:0] d_in;

    // Instantiate the Device Under Test (DUT)
    transmitter #(.WIDTH(WIDTH)) DUT (
        .en(en),         // Transmitter enable
        .clk(clk),       // Clock input
        .d_ready(d_ready), // Data ready signal
        .rstn(rstn),     // Active-low reset
        .tx_data(tx_data), // Serial data output
        .d_in(d_in)      // Parallel data input
    );

    // Clock generation (50MHz clock -> 20ns period)
    initial forever #10 clk = ~clk;

    // Main test sequence
    initial begin
        // Initialize all inputs
        en = 0;
        clk = 0;
        d_ready = 0;
        rstn = 1;
        d_in = 0;

        // Reset sequence
        @(posedge clk);  // Wait for clock edge
        rstn = 0;        // Assert reset
        @(posedge clk);
        rstn = 1;        // Deassert reset

        // Enable transmitter
        @(posedge clk);
        en = 1;

        // First test case - random data
        @(posedge clk);
        d_in = $random();  // Generate random data
        d_ready = 1;      // Assert data ready

        @(posedge clk);
        d_ready = 0;      // Deassert after one cycle

        // Wait for transmission to complete (11 cycles)
        repeat(11) @(posedge clk);

        // Second test case - increment previous data
        d_in = d_in + 1'b1;
        d_ready = 1;

        @(posedge clk);
        d_ready = 0;

        // Wait for transmission
        repeat(11) @(posedge clk);

        // Third test case - new random data
        d_in = $random();
        d_ready = 1;

        @(posedge clk);
        d_ready = 0;

        // Final wait and finish
        repeat(11) @(posedge clk);
        $finish;  // End simulation
    end

    // Waveform dumping
    initial begin
        $dumpfile("transmitter.vcd");  // Create waveform file
        $dumpvars;  // Dump all variables
    end

endmodule