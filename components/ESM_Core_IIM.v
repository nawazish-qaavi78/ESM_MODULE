module ESM_Core_IIM #(
	parameter bs = 16
) (
	input clk, rst,
	input [0:bs-1] independent_instr
);
	wire [0:bs-1] candidate_list;
	
	CandidateList #(bs) list (clk, rst, independent_instr, candidate_list); // this i'm using since independent_instr is combinational and can change in between, hence saving the state you can say

	MappingTable #(bs) mapping_table (clk, rst, candidate_list);
	
	PRNG #(bs) prng (clk, rst);
	
endmodule