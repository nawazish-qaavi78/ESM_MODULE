module ESM_Core #(
	parameter Instruction_word_size = 32,
		       bs = 16,
				 regnum = 32
) (
	input [Instruction_word_size-1:0] Instr_in,
	input clk, rst, RegWrite, ALUSrc, proceed,
	input [$clog2(bs)-1:0] buffer_index,
	input [0:bs-1] valid_entries,
	output [$clog2(bs)-1:0] next_buffer_index,
	output valid_count
);
	
	wire [0:bs-1] independent_instr;
	wire [$clog2(bs)-1: 0] buffer_index_synchronizer_1;
	
	ESM_Core_IDA #(Instruction_word_size, bs, regnum) IDA (clk, rst, RegWrite, ALUSrc, buffer_index, Instr_in, 
						valid_entries, independent_instr, buffer_index_synchronizer_1);

	ESM_Core_IIM #(bs) IIM (clk, rst, proceed, independent_instr, buffer_index, buffer_index_synchronizer_1, next_buffer_index, valid_count);
endmodule