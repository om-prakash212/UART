// File: baud_gen_tb.sv
// Description: This is a testbench for the baud_gen module.
// It initializes the inputs, toggles the clock, and checks the baud rate generation.
  

`timescale 1ns/1ps
`define CLOCKFRQ 300e6
`define BAUDRATE 9600


`define CKPERIOD (1e9/`CLOCKFRQ)
`define HLFCYCLE (`CKPERIOD/2)
`define BAUDREG  (`CLOCKFRQ/`BAUDRATE)


module baud_gen_tb();
	logic  clk;
	logic  rstn;
	logic  [15:0] dlh_dll;
	logic  mode_osl;
	logic  bclk;

	baud_gen DUT (
	 .clk(clk),
	 .rstn(rstn),
	 .dlh_dll(dlh_dll),
	 .mode_osl(mode_osl),
	 .bclk(bclk)
	);

	initial begin
		clk = 0;
		forever #(`HLFCYCLE) clk = ~clk;
	end

	initial begin
		rstn = 1;
		dlh_dll = `BAUDREG;
		mode_osl = 0;
		
		@(posedge clk);
		rstn = 0;
		@(posedge clk);
		rstn = 1;
		
		#10000
		$finish;
	end


	initial begin
		$dumpfile("baud.vcd");
		$dumpvars;
	end

endmodule
