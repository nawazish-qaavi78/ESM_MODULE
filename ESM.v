module ESM #(
	parameter Instruction_word_size = 32,
				 bs = 16 // this is the number of instructinos the buffer can store
) (
	input [Instruction_word_size-1:0] Instr_in,
	input clk, rst, RegWrite, ALUSrc,
	output [Instruction_word_size-1:0] Instr_out
);
	reg [$clog2(bs)-1:0] buffer_index = 0;
	
	reg [0:bs-1] valid_entries;
	
	always@(posedge clk, posedge rst) // for testing purpose, later driven by ESM_core
		if(rst) buffer_index <= 0;
		else buffer_index <= buffer_index + 1;
		
	always@(posedge clk, posedge rst) begin
		if(rst) valid_entries <= 0;
		else valid_entries[buffer_index] <= |Instr_in; // i.e. if instr_in is non-zero then it is a valid instruciton
	end
		
		
	InstructionBuffer #(Instruction_word_size, bs) buffer (clk, rst, Instr_in, buffer_index, Instr_out);
	
	ESM_Core #(Instruction_word_size, bs) Core (Instr_in, clk, rst, RegWrite, ALUSrc, buffer_index, valid_entries);
	

endmodule