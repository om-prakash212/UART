

module mux_2_1 (
	input  in_0, in_1,
	input  sel,
	output reg out
);

    localparam IN_0 = 1'b0;
    localparam IN_1 = 1'b1;

    always @(*) begin
	    case (sel) 
			IN_0 : out <= in_0;
			IN_1 : out <= in_1;
			default :  out <= in_0;
	    endcase
    end
endmodule
