
`timescale 1ns/1ps

module rsr #(
	parameter WIDTH = 8
 ) (
	input 	d_in,
	input 	ld_sh,
	input 	clk,
	input	en,
	input 	rst_n,
	input	parity,
	output 	reg [WIDTH-1:0] d_out,
	output  reg [WIDTH-1:0] fifo_out
);

	reg [WIDTH-1:0] d_in_reg;
	integer i;
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		d_in_reg = 0;
	end
	else begin
		if (!en) begin
			d_in_reg = d_in_reg;
		end
		else begin
			if (ld_sh) begin
				d_out = d_in_reg;
				d_in_reg = 0;
			end
			else begin
				d_in_reg = d_in_reg << 1;
				d_in_reg[0] = d_in;
			end
		end
	end
end
	
	always @(*) begin
		if(!parity) begin
			fifo_out <= d_out;
		end
		else begin
			fifo_out <= fifo_out;
		end 
	end	



endmodule
