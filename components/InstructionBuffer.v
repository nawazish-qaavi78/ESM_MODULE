module InstructionBuffer #(
	parameter Instr_word_size = 32,
				 bs = 16
)(
	input clk, rst, 
	input [Instr_word_size-1:0] Instr_in,
	input [$clog2(bs)-1:0] buffer_index,
	output reg [Instr_word_size-1:0] Instr_out
);

	reg [Instr_word_size-1:0] Instr_buffer[0:bs-1];
	
	always@(posedge clk, posedge rst) begin
			Instr_buffer[buffer_index] <= Instr_in;
	end
	
	always@(posedge clk) 
		Instr_out <= Instr_buffer[buffer_index];
	
endmodule