//This is code for tfifio.sv

`timescale 1ns/1ps

// Module Declare
module tfifo #(
	parameter WIDTH = 8,
	parameter SIZE  = 16 // SIZE in byte
	) (
	input         		clk_i,
	input          		rst_n_i,
	input          		we_i,
	input          		re_i,
	input          		tr_bz,
	input  [WIDTH-1:0]  	wdata_i,
	output reg		o_interpt,
	output reg		i_interpt,
	output reg		d_ready,
	output [WIDTH-1:0]  	rdata_o
);
// Local Parameters
  localparam BYTESIZE = WIDTH / 8;		// Used to find the number of bytes per word
  localparam MEMSIZE  = SIZE / BYTESIZE;// Total memory size in words (not bytes)
  localparam ADDRSIZE = $clog2(MEMSIZE); // For example, if MEMSIZE is 1024, ADDRSIZE would be 10 (since 2^10 = 1024)
  integer i;

// Internal registers
  reg [WIDTH-1:0]  mem [MEMSIZE-1:0]; // Memory array declaration
  reg [ADDRSIZE-1:0] waddr;				// Write address
  reg [ADDRSIZE-1:0] raddr;				// Read address
  reg [ADDRSIZE-1:0] count;				// Number of words in the FIFO
  reg [WIDTH-1:0]  rdata_reg;		    // Register to hold read data
		  
 // Funtional Description
always @ (posedge clk_i, negedge rst_n_i)  begin
    if (!rst_n_i) begin								//if not reset
		for (i = 0; i < MEMSIZE; i = i+1) begin
	        mem[i] = 16'b0;							// Initialize memory to zero
		end
	    waddr = 0;									// Reset write address
	    rdata_reg = 'b0;							// Reset read data register
		raddr = 0;									// Reset read address
	   	count = 0;									// Reset count
	   	d_ready = 0;								// Reset data ready flag
		i_interpt = 0;								// Reset input interrupt flag
		o_interpt = 1;								// Reset output interrupt flag
    end
    else if(we_i == 1 && count != {{ADDRSIZE} {1'b1}} ) begin // If write enable is high and FIFO is not full
    	d_ready = 0;										// Clear data ready flag
		mem[waddr] = wdata_i;	// Write data to memory at write address
		waddr = waddr + 1;	// Increment write address
		count = count + 1; 	// Increment count
    end

    else if(re_i == 1 && count != {{ADDRSIZE} {1'b0}} && !tr_bz) begin
    	d_ready = 1;					// Set data ready flag
		rdata_reg = mem[raddr];			// Read data from memory at read address
		mem[raddr] = {{WIDTH} {1'b0}};	// Clear memory at read address
		raddr = raddr + 1;				// Increment read address
		count = count - 1;				// Decrement count
    end
    else begin
    	d_ready = 0;					// If no write or read operation, keep data ready flag low
    	rdata_reg = rdata_reg;	// Keep read data register unchanged
    end
end

always @(count) 
begin
    if(count == {{ADDRSIZE} {1'b0}}) begin		// If FIFO is empty
		raddr <= 0;	
		waddr <= 0; 	// Reset read and write addresses
		i_interpt <= 0; // Clear input interrupt flag
		o_interpt <= 1; // Set output interrupt flag
    end
    else if (count == {{ADDRSIZE} {1'b1}}) begin	// If FIFO is full
		i_interpt <= 1; // Set input interrupt flag
		o_interpt <= 0; // Clear output interrupt flag
    end
    else begin 
		i_interpt <= 0; // If FIFO is neither full nor empty, clear input interrupt flag
		o_interpt <= 0; // Clear output interrupt flag
    end
end

assign rdata_o = rdata_reg; // Assign read data output to the read data register

endmodule // FIFO
