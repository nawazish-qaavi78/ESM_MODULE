module ESM_Core_IDA #(
	parameter Instruction_word_size = 16,
	parameter bs = 16
) (
	input clk, rst,
	input [Instruction_word_size-1:0] Instr_in
);

	IRT #(Instruction_word_size, bs) irt_table (clk, rst, Instr_in);

endmodule