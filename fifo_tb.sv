/*
Name    : Nazim
Design    : FIFO Test bench
Date    : 20th Feb, 2019
*/

module fifo_tb #( 
	parameter WIDTH = 8,
        parameter SIZE  = 16
)();
logic          		clk_i;
logic          		rst_n_i;
logic          		we_i;
logic          		re_i;
logic   [WIDTH-1:0] 	wdata_i;
logic   [WIDTH-1:0] 	rdata_o;
logic 			i_interpt;
logic 			o_interpt;


  fifo #(
	.WIDTH(WIDTH),
	.SIZE(SIZE)
  ) DUT (
	.clk_i(clk_i),
	.rst_n_i(rst_n_i),
	.we_i(we_i),
	.re_i(re_i),
	.wdata_i(wdata_i),
	.rdata_o(rdata_o),
	.i_interpt(i_interpt),
        .o_interpt(o_interpt)
	);
			
initial forever #10 clk_i = ~clk_i;
//initial forever #15 wdata_i = $random; 

task write();
    input [WIDTH-1:0] input_data;
	@(posedge clk_i)
	wdata_i = input_data; 
	we_i = 1;
	repeat(2)@(posedge clk_i)
	we_i = 0;
endtask

task read();
    @(posedge clk_i)
    re_i = 1;
    @(posedge clk_i)
    re_i = 0;
endtask

task reset();
    @(posedge clk_i)
    rst_n_i = 0;
    @(posedge clk_i)
    rst_n_i = 1;
endtask

initial begin
	clk_i = 0;
	rst_n_i = 1;
	we_i = 0;
	re_i = 0;
	reset();
//  	read();
//	write();
//	write();
//	write();
//	write();
//  	read();
//  	read();
//  	read();
//  	read();
	for (int i = 0; i < 16; i++) begin
		write($random());
	end
	for (int i = 0; i < 16; i++) begin
  		read();
	end
	for (int i = 0; i < 20; i++) begin
		write($random());
	end
	for (int i = 0; i < 20; i++) begin
  		read();
	end
	#100
	$finish;
  end

initial begin
$dumpfile ("fifo.vcd");
$dumpvars;
end

endmodule


