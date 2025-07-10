// Module: Transmit Shift Register (tsr) Testbench
// Description: This testbench verifies the functionality of the Transmit Shift Register (tsr) module.
// It initializes the inputs, toggles the clock, and checks the output data after loading and shifting operations.


`timescale 1ns/1ps

module tsr_tb #(
	parameter WIDTH = 8
 ) ();
	logic	[WIDTH-1:0] d_in;
	logic	 ld_sh;
	logic	 en;
	logic	 clk;
	logic	 rst_n;
	logic 	 d_out;

	
  tsr #(.WIDTH(WIDTH)) DUT (
	.ld_sh(ld_sh),
        .en   (en),
        .clk  (clk),
        .rst_n(rst_n),
        .d_out(d_out),
	.d_in (d_in)
  );

  initial forever #10 clk =~clk;

  initial begin
    clk = 0;
    ld_sh = 0;
    en = 0;
    rst_n = 1;

    #10
    rst_n = 0;
    #10
    rst_n = 1;
    
	for (int i = 0; i < 5; i++) begin
    #10
    en = 1;
    ld_sh = 1;
    d_in = $random;
    
    #10
    ld_sh = 0;

    #160;
    en = 0;
	end
  end
  
    initial begin
        #1020
	$finish;
    end

    initial begin
	$dumpfile("tsr.vcd");
	$dumpvars;
    end

    
endmodule
