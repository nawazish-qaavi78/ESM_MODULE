module ESM #(
	parameter Instruction_word_size = 32,
				 bs = 16, // this is the number of instructinos the buffer can store
				 regnum = 32
) (
	input [Instruction_word_size-1:0] Instr_in,
	input clk, rst, RegWrite, ALUSrc, valid_flag, 
	output [Instruction_word_size-1:0] Instr_out
);
	localparam bs_bits = $clog2(bs);
	
	localparam ISSUER_INACTIVE = 1'b0, ISSUER_ACTIVE = 1'b1;
	reg buffer_state = ISSUER_INACTIVE;
	
	reg [bs_bits-1:0] buffer_index = 1'b0;
	wire [bs_bits-1:0] next_buffer_index;
	
	wire valid_count;
	
	wire [0:bs-1] valid_entries;
	wire instr_is_empty = ~valid_flag;
	// generally in modern cpu arch, the bus is disconnected using a tri-state buffer, ie, it is z when invalid
	// there is another line that verifies the validity of input instruction, i.e, valid_flag
	
	wire proceed = instr_is_empty || (&valid_entries); // either when incoming instructions are invalid/z, ie, all instructions are completed or when the buffer is full start executing
	
	always@(*) begin
		if(valid_count && proceed) buffer_state = ISSUER_ACTIVE;
		else buffer_state = ISSUER_INACTIVE;
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst) buffer_index <= 0;
		else buffer_index <= (buffer_state == ISSUER_INACTIVE) ? buffer_index + 1'b1 : next_buffer_index;
	end	
		
	InstructionBuffer #(Instruction_word_size, bs) Buffer (clk, rst, Instr_in, buffer_index, Instr_out);
	
	ESM_Core #(Instruction_word_size, bs, regnum) Core (Instr_in, clk, rst, RegWrite, ALUSrc, proceed, 
																		buffer_index, valid_entries, next_buffer_index, valid_count);
	 
	BufferValidator #(Instruction_word_size, bs) Validator (clk, rst, valid_flag, buffer_index, valid_entries); // made a separate module for this register just so it is easier to understand when viewed in netlist viewer
	

endmodule