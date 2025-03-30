module ESM #(
	parameter Instruction_word_size = 32,
				 bs = 16 // this is the number of instructinos the buffer can store
) (
	input [Instruction_word_size-1:0] Instr_in,
	input clk, rst, RegWrite, ALUSrc,
	output [Instruction_word_size-1:0] Instr_out
);
	reg [$clog2(bs)-1:0] buffer_index = 0;
	
	wire [0:bs-1] valid_entries;
	
	always@(posedge clk, posedge rst) // for testing purpose, later driven by ESM_core
		if(rst) buffer_index <= 0;
		else buffer_index <= buffer_index + 1;
		
		
	InstructionBuffer #(Instruction_word_size, bs) Buffer (clk, rst, Instr_in, buffer_index, Instr_out);
	
	ESM_Core #(Instruction_word_size, bs) Core (Instr_in, clk, rst, RegWrite, ALUSrc, buffer_index, valid_entries);
	 
	BufferValidator #(Instruction_word_size, bs) Validator (clk, rst, Instr_in, buffer_index, valid_entries); // made a separate module for this register just so it is easier to understand when viewed in netlist viewer
	

endmodule