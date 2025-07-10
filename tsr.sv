//Module: Transmit Shift Register (tsr)
//Description: This module implements a transmitter for UART communication.
// It includes a finite state machine (FSM) for control, a parity generator, a shift register, and a multiplexer to select the output data.
// It handles the transmission of data with start and stop bits, and parity checking.

`timescale 1ns/1ps

module tsr #(
	parameter WIDTH = 8
 ) (
	input 	[WIDTH-1:0] d_in,
	input 	reg ld_sh,
	input 	reg en,
	input 	reg clk,
	input 	reg rst_n,
	output 	d_out
);

	reg [WIDTH-1:0] d_in_reg;
	reg d_out_reg;


always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		d_in_reg <= 0;
	end
	else begin
		if (en) begin
			if (ld_sh) begin
				d_in_reg <= d_in;
			end
			else begin
			   d_out_reg <= d_in_reg[WIDTH-1];
		 	  	d_in_reg <= d_in_reg << 1;	
			   d_in_reg[0] <= 1'b0;
			end
		end
		else begin
			d_in_reg <= d_in_reg;	
		end
	end
end
	
assign d_out = d_out_reg;

endmodule
