/*
Name	: Nazim
Design: mux 2 to 1 
Date	: 20th Apr, 2019
*/

`timescale 1ns/1ps

module mux_2_1_tb();
	logic in_0, in_1;
	logic sel;
	logic out;


	mux_2_1 DUT (
		.in_0(in_0),
		.in_1(in_1),
		.sel(sel),
		.out(out)
	);

	initial forever #10 sel =~sel;

	initial begin
		in_0 = 0;
		in_1 = 1;
		sel  = 0;
		#100
		$finish;
	end

	initial begin
		$dumpfile("mux_2_1.vcd");
		$dumpvars;
	end

endmodule
