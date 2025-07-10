
`timescale 1ns/1ps

module parity_check #(
	parameter WIDTH = 8
) (
  input clk,
  input rstn,
  input en,
  input d_in,
  input reg p_in,
  output reg err_data
);

 always @(posedge clk, negedge rstn) begin
     if(!rstn) begin
       err_data <= 1'b1;
     end 
     else begin
        if(en) begin
          if (p_in == d_in) begin
	         err_data <= 1'b0;
          end
          else begin
	         err_data <= 1'b1;
          end
        end
        else begin 
          err_data <= err_data;
        end
      end
  end
  
  
endmodule

