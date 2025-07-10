// File: transmitter_tb.sv
// Description: This is a testbench for the transmitter module.
// It initializes the inputs, toggles the clock, and applies various test cases
// to verify the functionality of the transmitter.

`timescale 1ns/1ps

module transmitter_tb #(
	parameter WIDTH = 8
	) ();

	logic en, d_ready, clk, rstn, tx_data;
	logic [WIDTH-1:0] d_in;

	transmitter #(.WIDTH(WIDTH)) DUT (
			.en			(en),
			.clk		(clk),
			.d_ready	(d_ready),
			.rstn		(rstn),
			.tx_data	(tx_data),
			.d_in		(d_in)
		);



	initial forever #10 clk = ~clk;

	initial begin
		en = 0;
		clk = 0;
		d_ready = 0;
		rstn =1;
		d_in = 0;

		@(posedge clk);
		rstn = 0;
		@(posedge clk);
		rstn = 1;

		@(posedge clk);
		en = 1;

		@(posedge clk);
		d_in = $random();
		d_ready = 1;

		@(posedge clk);
		d_ready = 0;

		repeat(11)@(posedge clk);
		d_in = d_in + 1'b1;
		d_ready = 1;

		@(posedge clk);
		d_ready = 0;

		repeat(11)@(posedge clk);
		d_in = $random();
		d_ready = 1;

		@(posedge clk);
		d_ready = 0;


		repeat(11) @(posedge clk);
		$finish;

	end

	initial begin
		$dumpfile("transmitter.vcd");
		$dumpvars;
	end

endmodule