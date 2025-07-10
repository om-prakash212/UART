// File: parity_gen_tb.sv
// Description: This is a testbench for the parity_gen module.
// It initializes the inputs and checks the output parity bit.

`timescale 1ns/1ps

module parity_gen_tb #(
	parameter WIDTH = 8
) ();
  logic [WIDTH-1:0] d_in;
  logic p_out;
  logic err_data;
  
  parity_gen #(.WIDTH(WIDTH)) DUT_GEN (.d_in(d_in), .p_out(p_out) );
  parity_check #(.WIDTH(WIDTH)) DUT_CHECK (.d_in(d_in), .p_in(p_out), .err_data(err_data));
  
  initial begin
    d_in = 0;
    #100
    d_in = $random; // Random data input
    #100
    d_in = d_in + 1'b1; // Increment data input
    #100
    d_in = $random; // Random data input
    #100
    d_in = d_in - 1'b1; // Decrement data input
    #100
    $finish;
  end
  
  
  initial begin
    $dumpfile("parity_genarate.vcd");
    $dumpvars;
  end
  
  
endmodule
