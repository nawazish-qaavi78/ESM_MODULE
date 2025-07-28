module ESM_Core_IIM #(
	parameter bs = 16
) (
	input clk, rst, proceed,
	input [0:bs-1] independent_instr,
	input [$clog2(bs)-1: 0] buffer_index, buffer_index_synchronizer_1,
	output [$clog2(bs)-1:0] next_buffer_index,
	output valid_count
);

	localparam bs_bits = $clog2(bs);
	
	wire [0:bs-1] candidate_list;
	
	wire [bs_bits-1: 0] random_number;
	
	wire [bs_bits-1: 0] buffer_index_synchronizer_2;
	
	Synchronizer #(bs_bits) synchronizer_2 (clk, rst, buffer_index_synchronizer_1, buffer_index_synchronizer_2);
	
	Synchronizer #(bs) Candidate_List (clk, rst, independent_instr, candidate_list);

	MappingTable #(bs) mapping_table (clk, rst, proceed, candidate_list, buffer_index, 
												buffer_index_synchronizer_1, buffer_index_synchronizer_2, 
												random_number, next_buffer_index, valid_count);
	
	PRNG #(bs) prng (clk, rst, random_number);
	
endmodule