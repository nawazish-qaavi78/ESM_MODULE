module BufferValidator #(
	parameter Instruction_word_size = 32,
				 bs = 16
) (
	input clk, rst,
	input [Instruction_word_size-1:0] Instr_in,
	input [$clog2(bs)-1:0] buffer_index,
	output reg [0:bs-1] valid_entries
);

	always@(posedge clk, posedge rst) begin
		if(rst) valid_entries <= 0;
		else valid_entries[buffer_index] <= |Instr_in; // i.e. if instr_in is non-zero then it is a valid instruciton
	end

endmodule