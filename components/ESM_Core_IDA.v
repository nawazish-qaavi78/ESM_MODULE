module ESM_Core_IDA #(
	parameter Instruction_word_size = 32,
				 bs = 16,
				 regnum = 16
) (
	input clk, rst, RegWrite, ALUSrc,
	input [$clog2(bs)-1:0] buffer_index,
	input [Instruction_word_size-1:0] Instr_in
);

	localparam reg_addr_bits = $clog2(regnum);

	wire [reg_addr_bits-1:0] rd = RegWrite ? Instr_in[11:7] : {reg_addr_bits{1'b0}};
	wire [reg_addr_bits-1:0] rs1 = Instr_in[19:15];
	wire [reg_addr_bits-1:0] rs2 = ALUSrc ? Instr_in[24:20] : {reg_addr_bits{1'b0}};

	
	IRT #(bs, regnum) irt_table (clk, rst, buffer_index, rd, rs1, rs2);

endmodule