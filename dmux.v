

module dmux(
	input   in,
	input   sel,
	output  reg out_0, out_1
);

    localparam  OUT_0 = 1'b0;
    localparam  OUT_1 = 1'b1;
   
   

    always @ (*) begin
	    case (sel) 
			OUT_0 : out_0 <= in;
			OUT_1 : out_1 <= in;
			default : begin
					out_0 <= 1'bz; 
					out_1 <= 1'bz; 
				end
	    endcase
	end


endmodule
