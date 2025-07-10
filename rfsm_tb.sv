/*
Nazme	: Nazim
Design	: UART Receiver FSM
Date	: 10th April, 2019
*/

`timescale 1ns/1ps

module rfsm_tb #(
	parameter WIDTH = 8
	) ();
	logic clk;    // Clock
	logic d_ready; 
	logic rst_n;  // Asynchronous reset active low
	logic p_error; // parity error 
	logic sel;
	logic d_load;

	rfsm #(.WIDTH(WIDTH)) DUT (
			.clk(clk),
			.d_ready(d_ready),
			.rst_n (rst_n),
			.p_error(p_error),
			.sel(sel),
			.d_load(d_load)
		);

	initial forever #10 clk = ~clk;
	initial forever #110 d_ready= ~d_ready;

	initial begin
		clk = 0;
		d_ready = 1;
		rst_n = 1;
		p_error = 1;

		@(posedge clk);
		rst_n = 0;
		@(posedge clk);
		rst_n = 1;

		@(posedge clk);
		d_ready = 0;
		@(posedge clk);
		d_ready = 1;
		repeat (8) @(posedge clk)
		p_error = 0;

//		repeat(3) @(posedge clk)
		#100
		$finish;
	end
	

	initial begin
		$dumpfile ("rfsm.vcd");
		$dumpvars;
	end
	

endmodule




