// Description: This module implements a transmitter that sends data serially.
// It includes a finite state machine (FSM) for control, a parity generator,
// a shift register for data transmission, and a multiplexer to select the output.

`timescale 1ns/1ps

`include "mux.v"
`include "parity_gen.v"
`include "tsr.sv"
`include "ufsm.v"


module transmitter #( 
	parameter WIDTH = 8				// Data width
	) (
	input en, d_ready, clk, rstn,  
	input [WIDTH-1:0] d_in,			// Input data to be transmitted
 	output tx_data,					// Output data to be transmitted
	output tr_bz			// Transmission busy signal
);


	reg start_bit 	= 0;		// Start bit for transmission
	reg stop_bit	= 1;	// Stop bit for transmission
	

	wire [1:0] sel_wire;	// Selection signal for multiplexer
	wire p_wire;			// Parity bit output from parity generator
	wire tsr_wire;			// Shift register output
	wire data_load_wire;	// Data load signal for shift register


	ufsm #(.WIDTH(WIDTH)) tfsm (		// Finite State Machine for control
		.en(en),
		.d_ready(d_ready),
		.clk(clk),
		.rstn(rstn),
		.sel(sel_wire),
		.data_load(data_load_wire),
		.tr_bz(tr_bz)
	);

	parity_gen #(.WIDTH(WIDTH)) tparity_gen (	// Parity generator module
		.d_in(d_in),
		.p_out(p_wire)
	);

	tsr #(.WIDTH(WIDTH)) transmit_tsr (	// Shift register for data transmission
		.d_in(d_in),
		.ld_sh(data_load_wire),
		.en(en),
		.clk(clk),
		.rst_n(rstn),
		.d_out(tsr_wire)
	);


	mux  tmux (						// Multiplexer to select the output data
		.in_0(start_bit),
		.in_1(tsr_wire), 
		.in_2(p_wire), 
		.in_3(stop_bit),
		.sel(sel_wire),
		.en(en),
		.out(tx_data)
		);



endmodule
