// Code your design here


`timescale 1ns/1ps

`include "baud_gen.v"
`include "mux_2_1.v"
`include "rfifo.sv"
`include "tfifo.sv"
`include "transmitter.v"
`include "receiver.v"


module uart_top #(
	parameter WIDTH = 8
 ) (
	input 				clk,
	input 				clk_sel,
	input 				rstn,
	input 				tr_en,
	input 				mode_osl,
	input 	[15:0] 		dlh_dll,
	input	[WIDTH-1:0] tr_fifo_data_w,
	input				rx_data_in, 
	output				tx_data_out,
	output	[WIDTH-1:0] rx_data_read_out,
	input				rx_data_read_en, 
	input				tx_data_w_en, 
	output				transmit_busy,
	output				tx_i_interpt,
	output				rx_i_interpt,
	output				tx_o_interpt,
	output				rx_o_interpt,
	input				tr_data_load
);
	wire clk_out;
	wire modified_clk;	
	wire tr_d_ready;	
	wire rx_fifo_en;	
	wire [WIDTH-1:0] tr_fifo_data_in;
	wire [WIDTH-1:0] rx_fifo_data_in;
	wire tr_bz;

	assign transmit_busy = tr_bz;

  mux_2_1 ck_mux (
	.in_0(clk),
	.in_1(clk_out),
	.sel(clk_sel),
	.out(modified_clk)
  );

  baud_gen clk_generator(
  	.clk(clk),
  	.rstn(rstn),
  	.dlh_dll(dlh_dll),
  	.mode_osl(mode_osl),
  	.bclk(clk_out)
  );


  tfifo tr_fifo (
  	.clk_i(modified_clk),
  	.rst_n_i(rstn),
  	.we_i(tx_data_w_en),
  	.re_i(tr_data_load),
  	.wdata_i(tr_fifo_data_w),
  	.o_interpt(tx_o_interpt),
  	.i_interpt(tx_i_interpt),
  	.d_ready(tr_d_ready),
  	.rdata_o(tr_fifo_data_in),
	.tr_bz(tr_bz)
  );
  
 transmitter #(.WIDTH(WIDTH)) tr_module(
	.en(tr_en), 
	.d_ready(tr_d_ready), 
	.clk(modified_clk), 
	.rstn(rstn), 
	.d_in(tr_fifo_data_in),
 	.tx_data(tx_data_out),
	.tr_bz(tr_bz)
);
  
  rfifo rr_fifo(
  	.clk_i(modified_clk),
  	.rst_n_i(rstn),
  	.we_i(rx_fifo_en),
  	.re_i(rx_data_read_en),
  	.wdata_i(rx_fifo_data_in),
  	.o_interpt(rx_o_interpt),
  	.i_interpt(rx_i_interpt),
  	.rdata_o(rx_data_read_out)
  );

receiver #(.WIDTH(WIDTH)) rx_module (
		.clk(modified_clk), 
		.rstn(rstn), 
		.rx_data(rx_data_in),
		.d_out(rx_fifo_data_in),
		.fifo_we_en(rx_fifo_en)
	);
	

endmodule