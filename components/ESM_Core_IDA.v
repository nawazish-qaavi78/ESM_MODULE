module ESM_Core_IDA #(
	parameter Instruction_word_size = 32,
				 bs = 16,
				 regnum = 32
) (
	input clk, rst, RegWrite, ALUSrc,
	input [$clog2(bs)-1:0] buffer_index,
	input [Instruction_word_size-1:0] Instr_in,
	input [0:bs-1] valid_entries,
	output [0:bs-1] independent_instr,
	output [$clog2(bs)-1: 0] buffer_index_synchronizer
);

	localparam reg_addr_bits = $clog2(regnum);
	localparam bs_bits = $clog2(bs);
	
	wire [0:bs-1] current_dept;

	wire [reg_addr_bits-1:0] rd  = Instr_in[11: 7];
	wire [reg_addr_bits-1:0] rs1 = Instr_in[19:15];
	wire [reg_addr_bits-1:0] rs2 = Instr_in[24:20];

	wire [0:bs-1] valid_entries_synchronizer;
	
	Synchronizer #(bs_bits) synchronizer_1 (clk, rst, buffer_index, buffer_index_synchronizer);
	Synchronizer #(bs) synchronizer_2 (clk, rst, valid_entries, valid_entries_synchronizer);
	
	IRT #(bs, regnum) irt_table (clk, rst, buffer_index, RegWrite, ALUSrc, rd, rs1, rs2, current_dept);
	IDT #(bs) idt_table (clk, rst, buffer_index_synchronizer, current_dept, valid_entries_synchronizer, independent_instr);

endmodule