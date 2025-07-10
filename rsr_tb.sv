/*
Name 	: Nazim
Design 	: Rx Shift Register (SIPO) test bench
Date	: 6th April, 2019
*/

`timescale 1ns/1ps

module rsr_tb #(
	parameter WIDTH = 8
 ) ();
	logic	 d_in;
	logic	 ld_sh;
	logic	 en;
	logic	 clk;
	logic	 rst_n;
	logic 	 [WIDTH-1:0] d_out;

	
  rsr #(.WIDTH(WIDTH)) DUT (
		.ld_sh(ld_sh),
        .en   (en),
        .clk  (clk),
        .rst_n(rst_n),
        .d_out(d_out),
		.d_in (d_in)
  );

  initial forever #10 clk =~clk;
  initial forever #9  d_in = $random;

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
    @(posedge clk);
    en = 1;
    ld_sh = 1;
    
    @(posedge clk);
    ld_sh = 0;

    repeat(8)@(posedge clk);
    ld_sh = 1;
    @(posedge clk);
    ld_sh = 0;
    @(posedge clk);
    en = 0;
    @(posedge clk);
    ld_sh = 1;
	end
  end
  
    initial begin
        #1020
	$finish;
    end

    initial begin
	$dumpfile("rsr.vcd");
	$dumpvars;
    end

    
endmodule
