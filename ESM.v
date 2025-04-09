module ESM #(
	parameter Instruction_word_size = 32,
				 bs = 16 // this is the number of instructinos the buffer can store
) (
	input [Instruction_word_size-1:0] Instr_in,
	input clk, rst, RegWrite, ALUSrc,
	output [Instruction_word_size-1:0] Instr_out
);
	localparam bs_bits = $clog2(bs);
	
	reg [bs_bits-1:0] buffer_index = {bs_bits{1'b1}};
	wire [bs_bits-1:0] next_buffer_index;
	
	wire valid_count;
	
	wire [0:bs-1] valid_entries;
	
	wire proceed = (~(|Instr_in)) || (&valid_entries); // either when incoming instructions are 0, ie, all instructions are complete or when the buffer is full start executing
	
	always@(posedge clk, posedge rst) begin
		if(rst) buffer_index <= {bs_bits{1'b1}};
		else if(valid_count && proceed) buffer_index <= next_buffer_index;
		else buffer_index <= {bs_bits{1'b1}};	
		// why i'm doing this is because, when instructions are still filling in if buffer index is some intermediate value, then the circuit will execute the instruction regarless of the dependency
		// hence by keeping buffer_index at the end, we can prevent this when last index is filled then proceed will be high and control will be taken over by the ESM_Core
	end	
		
	InstructionBuffer #(Instruction_word_size, bs) Buffer (clk, Instr_in, buffer_index, Instr_out);
	
	ESM_Core #(Instruction_word_size, bs) Core (Instr_in, clk, rst, RegWrite, ALUSrc, buffer_index, valid_entries, next_buffer_index, valid_count);
	 
	BufferValidator #(Instruction_word_size, bs) Validator (clk, rst, Instr_in, buffer_index, valid_entries); // made a separate module for this register just so it is easier to understand when viewed in netlist viewer
	

endmodule