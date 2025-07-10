/*
Name	: Nazim
Design	: UART Receiver Test bench
Date	: 12th Apr, 2019
*/

`timescale 1ns/1ps

module receiver_tb #(
		parameter WIDTH = 8
	) ();
		logic clk;    // Clock
		logic rstn;  // Asynchronous reset active low
		logic rx_data;
		logic [WIDTH-1:0] d_out;
		logic fifo_we_en;


		receiver #(.WIDTH(WIDTH)) DUT (
				.clk(clk),
				.rstn(rstn),
				.rx_data(rx_data),
				.d_out(d_out),
				.fifo_we_en(fifo_we_en)
			);

	initial forever #10 clk = ~clk;

	initial begin
		clk = 0;
		rstn = 1;
		rx_data = 1;

		@(posedge clk);
		rstn = 0;

		@(posedge clk);
		rstn = 1;

		@(posedge clk);
		rx_data = 0;

		@(posedge clk);
		rx_data = 0;

		@(posedge clk);
		rx_data = 0;
		
		@(posedge clk);
		rx_data = 1;

		@(posedge clk);
		rx_data = 0;

		@(posedge clk);
		rx_data = 0;

		@(posedge clk);
		rx_data = 1;

		@(posedge clk);
		rx_data = 0;

		@(posedge clk);
		rx_data = 0;

		@(posedge clk);
		rx_data = 0;

		@(posedge clk);
		rx_data = 1;

		#100
		$finish;
	end

	initial begin
		$dumpfile("receiver.vcd");
		$dumpvars;
	end


endmodule