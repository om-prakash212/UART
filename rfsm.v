

`timescale 1ns/1ps

module rfsm #(
	parameter WIDTH = 8
	) (
	input clk,    // Clock
	input d_ready, 
	input rst_n,  // Asynchronous reset active low
	input p_error, // parity error 
	output reg sel,
	output reg d_load,
	output reg en_out_rsr,
	output reg en_out_parity,
	output reg [2:0] count_out,
	output reg fifo_we_i 
); 

	localparam [1:0] IDLE   = 2'b00;
	localparam [1:0] DATA   = 2'b01;
	localparam [1:0] PARITY = 2'b11;
	localparam [1:0] STOP   = 2'b10;

	reg [1:0] state_reg, next_state;
	reg [2:0] count;

	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			next_state <= 0;
			sel <= 1'bz; 
			count <= 0;
			d_load <= 0;
			en_out_rsr <= 0;
			fifo_we_i <= 0;
		end 
		else begin
			state_reg <= next_state;
			if(state_reg == DATA & (count < WIDTH-1)) begin
				count <= count + 1;
			end
			else begin
				count <= count;
			end
		end
	end


	always @(count, state_reg, next_state, d_ready) begin
		case (state_reg)
			IDLE  	: 	begin
							sel <= 1'bz;
							count <= 0;
							d_load <= 0;
							en_out_rsr <= 0;
							fifo_we_i <= 0;
							en_out_parity <= 0;
							if(!d_ready) begin
								next_state <= DATA;
							end
							else begin
								next_state <= IDLE;
							end
						end

			DATA  	: 	begin
							sel <= 1'b0;
							en_out_rsr <=1;
							count_out <= count;
							d_load <= 0;
							if (count < WIDTH-1) begin
								next_state = DATA;
							end
							else begin
								next_state = PARITY;
							end
						end

			PARITY	: 	begin
							sel <= 1'b1;
							next_state <= STOP;
							en_out_rsr <= 1;
							en_out_parity <= 1;
							d_load <= 1;
						end

			STOP  	: 	begin
							sel <= 1'bz;
							en_out_rsr <= 0;
							en_out_parity <= 1;
							next_state <= IDLE;
							d_load <= 0;
							if(!p_error) begin
								fifo_we_i = 1;
							end
							else begin
								fifo_we_i = 0;
							end
						end

			default : 	begin
							sel <= 1'bz;
							next_state <= IDLE;
							en_out_rsr <= 0;
							en_out_parity <= 0;
							count <= 0;
						end
		endcase
	end


endmodule


