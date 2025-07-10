`timescale 1ns/1ps

	
module uart_top_tb #(
	parameter WIDTH = 8
 ) ();
	bit								clk;
	bit								clk_sel;
	bit								rstn;
	logic	[15:0] 			dlh_dll;


	bit								dut1_tr_en;
	bit								dut1_tr_data_load;
	bit							dut1_mode_osl;
	logic  [WIDTH-1:0]dut1_tr_fifo_data_w;
	logic	[WIDTH-1:0] dut1_rx_data_read_out;
	logic  						dut1_rx_data_read_en; 
	logic  						dut1_tx_data_w_en; 
	logic							dut1_transmit_busy;
	logic							dut1_tx_i_interpt;
	logic							dut1_rx_i_interpt;
	logic							dut1_tx_o_interpt;
	logic							dut1_rx_o_interpt;

	bit								dut2_tr_en;
	bit							dut2_mode_osl;
	bit								dut2_tr_data_load;
	logic  [WIDTH-1:0]dut2_tr_fifo_data_w;
	logic	[WIDTH-1:0] dut2_rx_data_read_out;
	logic  						dut2_rx_data_read_en; 
	logic  						dut2_tx_data_w_en; 
	logic							dut2_transmit_busy;
	logic							dut2_tx_i_interpt;
	logic							dut2_rx_i_interpt;
	logic							dut2_tx_o_interpt;
	logic							dut2_rx_o_interpt;

	logic  						dut1_rx_dut2_tx; 
	logic							dut1_tx_dut2_rx;

uart_top #(.WIDTH(WIDTH)) TX_DUT (
	.clk		     (	clk				),
	.clk_sel         (  clk_sel			),
	.rstn            (  rstn			),
	.tr_en           (  dut1_tr_en			),
	.mode_osl        (  dut1_mode_osl		),
	.dlh_dll         (  dlh_dll			),
	.tr_fifo_data_w  (  dut1_tr_fifo_data_w	),
	.rx_data_in      (  	dut1_rx_dut2_tx	),
	.tx_data_out     (  	dut1_tx_dut2_rx	),
	.rx_data_read_out(  dut1_rx_data_read_out),
	.rx_data_read_en (	dut1_rx_data_read_en ),
	.tx_data_w_en    (	dut1_tx_data_w_en 	),
	.transmit_busy   (	dut1_transmit_busy	),
	.tx_i_interpt    (	dut1_tx_i_interpt	),
	.rx_i_interpt    (	dut1_rx_i_interpt	),
	.tx_o_interpt    (	dut1_tx_o_interpt	),
	.rx_o_interpt    (	dut1_rx_o_interpt	),
	.tr_data_load	 (  dut1_tr_data_load		)
);


uart_top #(.WIDTH(WIDTH)) RX_DUT (
	.clk		     (	clk				),
	.clk_sel         (  clk_sel			),
	.rstn            (  rstn			),
	.tr_en           (  dut2_tr_en			),
	.mode_osl        (  dut2_mode_osl		),
	.dlh_dll         (  dlh_dll			),
	.tr_fifo_data_w  (  dut2_tr_fifo_data_w	),
	.rx_data_in      (  dut1_tx_dut2_rx	),
	.tx_data_out     (  dut1_rx_dut2_tx	),
	.rx_data_read_out(  dut2_rx_data_read_out),
	.rx_data_read_en (	dut2_rx_data_read_en ),
	.tx_data_w_en    (	dut2_tx_data_w_en 	),
	.transmit_busy   (	dut2_transmit_busy	),
	.tx_i_interpt    (	dut2_tx_i_interpt	),
	.rx_i_interpt    (	dut2_rx_i_interpt	),
	.tx_o_interpt    (	dut2_tx_o_interpt	),
	.rx_o_interpt    (	dut2_rx_o_interpt	),
	.tr_data_load	 (  dut2_tr_data_load		)
);




//---- Reset Task ----//
	task reset;
		@(posedge clk);
		rstn = 0;
		@(posedge clk);
		rstn = 1;
	endtask : reset


//---- DUT_1 Data Load Transmitter FIFO ----//
	task dut1_data_write_tr_fifo;
		@(posedge clk);
		dut1_tx_data_w_en = 1;
		dut1_tr_fifo_data_w = $random+1'b1;
		@(posedge clk);
		dut1_tx_data_w_en = 0;
	endtask : dut1_data_write_tr_fifo 


//---- DUT_1 Data Read from Receiver FIFO ----//	
	task dut1_data_read_rx_fifo;
		@(posedge clk);
		dut1_rx_data_read_en = 1;
		@(posedge clk);
		dut1_rx_data_read_en = 0;
	endtask : dut1_data_read_rx_fifo 


//---- DUT_1 Start To Transmit Data ----//
	task dut1_data_transmit;
		@(posedge clk);
		dut1_tr_data_load = 1;
		dut1_tr_en = 1;
		@(posedge clk);
		dut1_tr_data_load = 0;
		repeat(12)	@(posedge clk);
		dut1_tr_en = 0;
	endtask : dut1_data_transmit


//---- DUT_2 Data Load Transmitter FIFO ----//
	task dut2_data_write_tr_fifo;
		@(posedge clk);
		dut2_tx_data_w_en = 1;
		dut2_tr_fifo_data_w = $random;
		@(posedge clk);
		dut2_tx_data_w_en = 0;
	endtask : dut2_data_write_tr_fifo 


//---- DUT_2 Data Read from Receiver FIFO ----//	
	task dut2_data_read_rx_fifo;
		@(posedge clk);
		dut2_rx_data_read_en = 1;
		@(posedge clk);
		dut2_rx_data_read_en = 0;
	endtask : dut2_data_read_rx_fifo 


//---- DUT_2 Start To Transmit Data ----//
	task dut2_data_transmit;
		@(posedge clk);
		dut2_tr_en = 1;
		repeat(12)	@(posedge clk);
		dut2_tr_en = 0;
	endtask : dut2_data_transmit



	initial forever #10 clk = ~clk;


	initial begin
			clk_sel		= 0;
    	rstn			= 1;
    	dlh_dll			= 'd9600;
    	dut1_tr_fifo_data_w	= 0;
    	dut1_rx_data_read_en = 0;
    	dut1_tx_data_w_en 	= 0;
    	dut2_tr_fifo_data_w	= 0;
    	dut2_rx_data_read_en = 0;
    	dut2_tx_data_w_en 	= 0;
	
	
			reset();

			for (int i=0; i<10; i++) begin
				dut1_data_write_tr_fifo();
			end

			dut1_data_transmit();
			repeat(10) @(posedge clk);
			dut2_data_read_rx_fifo();

			#10
			$finish;
	end


	initial begin
		$dumpfile ("uart_top.vcd");
		$dumpvars;
	end


endmodule





