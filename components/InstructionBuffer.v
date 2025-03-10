module InstructionBuffer #(
	parameter Instr_word_size = 16,
	parameter bs = 16
)(
	input clk, rst, 
	input [Instr_word_size-1:0] Instr_in,
	input [$clog2(bs)-1:0] buffer_index,
	output reg [Instr_word_size-1:0] Instr_out
);

	reg [Instr_word_size-1:0] Instr_buffer[0:bs-1];
	reg [0:bs-1] valid_entries = 0; // to understand what is actually an instruction and what is just garbage or null instruction

	always@(posedge clk, posedge rst) begin
		if(rst) begin
			valid_entries <= 0;
		end else begin
			Instr_buffer[buffer_index] <= Instr_in;
			valid_entries[buffer_index] <= (Instr_in) ? 1'b1: 1'b0;
		end
	end
	
	always@(posedge clk) 
		Instr_out <= Instr_buffer[buffer_index];
	
endmodule