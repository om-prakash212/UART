`timescale 1ns/1ps

module ufsm_tb#(
	parameter WIDTH=8
	);
	reg clk,reset,enable,d_ready;
	wire [1:0]sel;

	ufsm #(
		.WIDTH(WIDTH)
		)
		DUT0(
			.clk(clk),
			.rstn(reset),
			.en(enable),
			.d_ready(d_ready),
			.sel(sel)
		);

initial begin
	reset=0;clk=0;enable=0;d_ready=0;
	@(posedge clk)
			reset=1;
	repeat(2)
		@(posedge clk)
			enable=1;
	repeat(2)
		@(posedge clk)
			d_ready=1;
	repeat(2)
		@(posedge clk)
			d_ready=0;
	#1000 $finish();
end	

always begin 
		#10 clk=~clk;
end


initial begin
	$dumpfile("ufsm.vcd");
	$dumpvars;
end


endmodule
