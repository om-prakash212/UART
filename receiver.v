// File: receiver.v
//Description: Receiver module for UART communication



`timescale 1ns/1ps

`include "dmux.v"
`include "rfsm.v"
`include "rsr.sv"
`include "parityGS.v"
`include "parity_check.v"


module receiver #( 
		parameter WIDTH = 8
	) (
		input  clk, rstn, 
		input  rx_data,
		output [WIDTH-1:0] d_out,
		output fifo_we_en
	);

	wire sel_wire;
	wire p_wire;
	wire [WIDTH-1:0] rsr_wire;
	wire data_load_wire;
	wire rsr_data;
	wire en_rsr;
	wire parity_error;
	wire [2:0] rfsm_count_out;
	wire p_check_in;
	wire parity_en;


	rfsm #(.WIDTH(WIDTH)) receiver_fsm (
		.clk(clk),
		.d_ready(rx_data),
		.rst_n(rstn),
		.p_error(parity_error),
		.sel(sel_wire),
		.d_load(data_load_wire),
		.fifo_we_i(fifo_we_en),
		.en_out_rsr(en_rsr),
		.count_out(rfsm_count_out),
		.en_out_parity(parity_en)
	);
 
    parityGS receiver_data_parity (
    	.clk(clk),
    	.rstn(rstn),
    	.en(en_rsr),
    	.d_in(rsr_data),
    	.count(rfsm_count_out),
    	.parity_out(p_check_in)

    );
	
	parity_check #(.WIDTH(WIDTH)) rparity_check (
		.clk(clk),
		.rstn(rstn),
		.en(parity_en),
		.d_in(p_check_in),
		.p_in(p_wire),
		.err_data(parity_error)
	);

	rsr #(.WIDTH(WIDTH)) receiver_rsr (
		.d_in(rsr_data),
		.ld_sh(data_load_wire),
		.clk(clk),
		.rst_n(rstn),
		.d_out(rsr_wire),
		.parity(parity_error),
		.fifo_out(d_out),
		.en(en_rsr)
	);


	dmux receiver_dmux (
		.in(rx_data),
		.sel(sel_wire),
		.out_0(rsr_data),
		.out_1(p_wire)
	);



endmodule
