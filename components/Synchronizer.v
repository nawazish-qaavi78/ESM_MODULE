module Synchronizer #(
 	parameter width = 2
 ) (
 	input clk, rst,
 	input [width-1: 0] in,
 	output reg [width-1:0] out
 );
 
 	always@(posedge clk, posedge rst)
		if(rst) out <= 1'b0;
 		else out <= in;
 
 endmodule