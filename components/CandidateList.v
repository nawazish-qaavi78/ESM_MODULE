module CandidateList # (
	parameter bs = 16
) (
	input clk, rst, 
	input [0:bs-1] independent_instr,
	output reg [0:bs-1] candidate_list
);

	always@(posedge clk, posedge rst)
		if(rst) candidate_list <= 0;
		else candidate_list <= independent_instr;

endmodule