module BufferValidator #(
	parameter Instruction_word_size = 32,
				 bs = 16
) (
	input clk, rst,
	input valid_flag,
	input [$clog2(bs)-1:0] buffer_index,
	output reg [0:bs-1] valid_entries
);

	always@(posedge clk, posedge rst) begin
		if(rst) valid_entries <= 0;
		else valid_entries[buffer_index] <= valid_flag;
	end

endmodule