module IRT #(
	parameter Instruction_word_size = 16,
	parameter bs = 16
) (
	input clk, rst,
	input [Instruction_word_size-1:0] Instr_in
);

	integer i;
	
	reg [Instruction_word_size-1:0] IRT_RD [0:bs-1];
	reg [Instruction_word_size-1:0] IRT_RS [0:bs-1];
	
	initial begin
		for(i=0; i<bs; i=i+1) begin
			IRT_RD[i] = {Instruction_word_size{1'b1}};
			IRT_RS[i] = {Instruction_word_size{1'b1}};
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst) for(i=0; i<bs; i=i+1) begin
			IRT_RD[i] = {Instruction_word_size{1'b1}};
			IRT_RS[i] = {Instruction_word_size{1'b1}};
		end else begin
			
		end
	end
	

endmodule