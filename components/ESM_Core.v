module ESM_Core #(
	parameter Instruction_word_size = 16,
	parameter bs = 16
) (
	input [Instruction_word_size-1:0] Instr_in,
	input clk, rst
);

	ESM_Core_IDA #(Instruction_word_size, bs) IDA (clk, rst, Instr_in);

endmodule