// This is code for ufsm.v
// File: ufsm.v
// Description: This module implements a finite state machine (FSM) for controlling
// the transmission of data in a UART transmitter. It manages the states of IDLE,
// START, DATA, PARITY, and STOP, and generates control signals for data loading
// and transmission.


`timescale 1ns/1ps

module ufsm #(
	parameter WIDTH = 8    // Data width in FIFO
	) (
	input clk, 
	input rstn,
	input en,
	input d_ready,
	output reg tr_bz,
	output reg [1:0] sel,
	output reg data_load
);

	localparam [2:0] IDLE   = 3'b000;
	localparam [2:0] START  = 3'b001;
	localparam [2:0] DATA   = 3'b010;
	localparam [2:0] PARITY = 3'b011;
	localparam [2:0] STOP   = 3'b100;

	reg [2:0] state_reg, next_state;
  	reg [2:0] count;

	always @(posedge clk, negedge rstn) begin		// Synchronous reset
		if (!rstn) begin			// Reset state and control signals
			next_state <= 0;		// Reset next state
			sel <= 2'bz;			// Reset selection signal
			count <= 0;				// Reset count
			data_load <= 0;			// Reset data load signal
			tr_bz <= 0;				// Reset transmission busy signal
		end
		else begin
			if (en) begin
				state_reg <= next_state;
				if (state_reg ==  DATA & (count < WIDTH-1) ) begin	// Increment count for each data bit
					count <= count + 1;
				end
				else begin
					count <= count;
				end
			end
			else begin
				state_reg <= state_reg;		// Hold current state if not enabled
				sel <= 2'bz;				// Hold selection signal
			end
		end
	end

	always@(state_reg, next_state, count, d_ready) begin	// Combinational logic for next state and control signals
		case(state_reg)
			IDLE	: begin
						tr_bz <= 0;	// Transmission not busy
						data_load <= 1;		// Data load signal active
						sel <= 2'bzz;		// Selection signal is high impedance
						if (d_ready) begin		// If data is ready, transition to START state
							next_state <= START;	// Move to START state
						end
						else begin
							next_state <= IDLE;		// Stay in IDLE state
						end
				end

			START 	: begin
						tr_bz <= 1;
						data_load <= 0;
						next_state <= DATA;
						sel <= 2'b00;
						count <= 0;
				end
			
      		DATA  	: begin
						sel <= 2'b01;
						if (count < WIDTH-1) begin
							next_state <= DATA;
						end
						else begin
							next_state <= PARITY;
						end
				end

      		PARITY	: begin 
						next_state <= STOP;
						sel <= 2'b11;
				end
      		STOP  	: begin
						tr_bz <= 0;
						next_state <= IDLE;
						sel <= 2'b10;
				end

			default	: begin
						next_state <= IDLE;
			end
		endcase
	end


	endmodule


