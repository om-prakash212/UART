// File: baud_gen.v
// Description: This module generates a baud clock based on the input parameters.

`timescale 1ns/1ps

module baud_gen(
	input clk,
	input rstn,
	input reg [15:0] dlh_dll,
	input mode_osl,
	output bclk
);

	wire [15:0] mode_0;
	wire [15:0] mode_1;

	reg [4:0] mode_reg_0 = 5'd16;
	reg [3:0] mode_reg_1 = 4'd13;

	reg [15:0] ck_count;

	assign mode_0 = dlh_dll / mode_reg_0;	
	assign mode_1 = dlh_dll / mode_reg_1;	

	always @(posedge clk, negedge rstn) begin
		if (!rstn) begin
			ck_count = 0;
		end
		else if (bclk) begin
			ck_count = 0;
		end
		else begin
			ck_count = ck_count + 1'b1; 
		end
	end

	assign bclk =  mode_osl ? ( mode_1 == ck_count ? 1 :0 ) : ( mode_0 == ck_count ? 1 :0 );

endmodule
