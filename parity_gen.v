// File: parity_gen.v
// Description: This module generates a parity bit for the input data.
// It computes the parity by XORing all bits of the input data.


`timescale 1ns/1ps

module parity_gen #(
	parameter WIDTH = 8 // Width of the input data
) (
  input [WIDTH-1:0] d_in,   // Input data for which parity is to be generated
  output reg p_out          // Output parity bit
);


  always @(d_in) begin    // Combinational logic to compute parity
    p_out = ^d_in;        // XOR operation to compute parity
  end
  
endmodule

