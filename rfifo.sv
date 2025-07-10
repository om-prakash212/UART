

`timescale 1ns/1ps

// Module Declare
module rfifo #(
	parameter WIDTH = 8,
	parameter SIZE  = 16 // SIZE in byte
	) (
	input         		clk_i,
	input          		rst_n_i,
	input          		we_i,
	input          		re_i,
	input  [WIDTH-1:0]  	wdata_i,
	output reg		o_interpt,
	output reg		i_interpt,
	output [WIDTH-1:0]  	rdata_o
);

  localparam BYTESIZE = WIDTH / 8;
  localparam MEMSIZE  = SIZE / BYTESIZE;
  localparam ADDRSIZE = $clog2(MEMSIZE);
  integer i;

// Internal registers
  reg [WIDTH-1:0]  mem [MEMSIZE-1:0];
  reg [ADDRSIZE-1:0] waddr;
  reg [ADDRSIZE-1:0] raddr;
  reg [ADDRSIZE-1:0] count;
  reg [WIDTH-1:0]  rdata_reg;
		  
 // Funtional Description
always @ (posedge clk_i, negedge rst_n_i)  begin
    if (!rst_n_i) begin
		for (i = 0; i < MEMSIZE; i = i+1) begin
	        mem[i] = 16'b0;
		end
	    waddr = 0;
	    rdata_reg = 'b0;
		raddr = 0;
	   	count = 0;
		i_interpt = 0;
		o_interpt = 1;
    end
    else if(we_i == 1 && count != {{ADDRSIZE} {1'b1}} ) begin
		mem[waddr] = wdata_i;
		waddr = waddr + 1;
		count = count + 1;
    end

    else if(re_i == 1 && count != {{ADDRSIZE} {1'b0}}) begin
		rdata_reg = mem[raddr];
		mem[raddr] = {{WIDTH} {1'b0}};
		raddr = raddr + 1;
		count = count - 1;
    end
    else begin
    	rdata_reg = rdata_reg;
    end
end

always @(count) 
begin
    if(count == {{ADDRSIZE} {1'b0}}) begin
		raddr <= 0;
		waddr <= 0;
		i_interpt <= 0;
		o_interpt <= 1;
    end
    else if (count == {{ADDRSIZE} {1'b1}}) begin
		i_interpt <= 1;
		o_interpt <= 0;
    end
    else begin 
		i_interpt <= 0;
		o_interpt <= 0;
    end
end

assign rdata_o = rdata_reg;

endmodule // FIFO
