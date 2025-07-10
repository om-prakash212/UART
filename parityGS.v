

`timescale 1ns/1ps

module parityGS (
	input clk,
	input rstn,
	input en,
	input d_in,
	input [2:0] count,
	output parity_out
);
	reg parity_out_reg;

	always @(posedge clk, negedge rstn) begin
		if(!rstn) begin
			parity_out_reg <= 0;
		end
		else begin
			if(en) begin
				if(count == 0) begin
					parity_out_reg <= d_in;
				end
				else begin
					parity_out_reg <= parity_out_reg ^ d_in;
				end
			end
			else begin
				parity_out_reg <= parity_out_reg;
			end
		end
	end

	assign parity_out = parity_out_reg;


endmodule
