module Synchronizer #(
	parameter width = 2
) (
	input clk,
	input [width-1: 0] in,
	output reg [width-1:0] out
);

	always@(posedge clk)
		out <= in;

endmodule