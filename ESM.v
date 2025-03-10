module ESM #(
	parameter Instruction_word_size = 16,
	parameter bs = 16 // this is the number of instructinos the buffer can store
) (
	input [Instruction_word_size-1:0] Instr_in,
	input clk, rst,
	output [Instruction_word_size-1:0] Instr_out
);
	reg [$clog2(bs)-1:0] buffer_index = 0;
	always@(posedge clk) // for testing purpose, later driven by ESM_core
		buffer_index = buffer_index + 1;
		
	InstructionBuffer #(Instruction_word_size, bs) buffer (clk, rst, Instr_in, buffer_index, Instr_out);
	
	ESM_Core #(Instruction_word_size, bs) Core (Instr_in, clk, rst);
	

endmodule