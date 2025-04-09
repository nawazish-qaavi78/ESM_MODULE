module ESM_Core_IIM #(
	parameter bs = 16
) (
	input clk, rst,
	input [0:bs-1] independent_instr,
	output [$clog2(bs)-1:0] next_buffer_index,
	output valid_count
);

	localparam bs_bits = $clog2(bs);
	
	wire [0:bs-1] candidate_list;
	
	wire [bs_bits-1: 0] random_number;
	
	CandidateList #(bs) list (clk, rst, independent_instr, candidate_list); // for synchronization

	MappingTable #(bs) mapping_table (clk, rst, candidate_list, random_number, next_buffer_index, valid_count);
	
	PRNG #(bs) prng (clk, rst, random_number);
	
endmodule