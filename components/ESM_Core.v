module ESM_Core #(
	parameter Instruction_word_size = 32,
		       bs = 16,
				 regnum = 16
) (
	input [Instruction_word_size-1:0] Instr_in,
	input clk, rst, RegWrite, ALUSrc,
	input [$clog2(bs)-1:0] buffer_index
);

	ESM_Core_IDA #(Instruction_word_size, bs, regnum) IDA (clk, rst, RegWrite, ALUSrc, buffer_index, Instr_in);

endmodule