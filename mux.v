

module mux(
	input  in_0, in_1, in_2, in_3,
	input  [1:0] sel,
	input  en,
	output reg out
);

    localparam [1:0] IN_0 = 2'b00;
    localparam [1:0] IN_1 = 2'b01;
    localparam [1:0] IN_2 = 2'b11;
    localparam [1:0] IN_3 = 2'b10;

    always @ (*) begin
        if (en) begin
	    	case (sel) 
				IN_0 : out <= in_0;
				IN_1 : out <= in_1;
				IN_2 : out <= in_2;
				IN_3 : out <= in_3;
				default : out <= 1'bz;
	    	endcase
        end
        else begin
            out <= 1'bz;
        end
    end
endmodule
