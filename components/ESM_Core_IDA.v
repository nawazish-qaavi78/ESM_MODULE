module ESM_Core_IDA #(
	parameter Instruction_word_size = 32,
				 bs = 16,
				 regnum = 32
) (
	input clk, rst, RegWrite, ALUSrc,
	input [$clog2(bs)-1:0] buffer_index,
	input [Instruction_word_size-1:0] Instr_in,
	input [0:bs-1] valid_entries,
	output [0:bs-1] independent_instr
);

	localparam reg_addr_bits = $clog2(regnum);
	localparam bs_bits = $clog2(bs);
	
	wire [0:bs-1] current_dept;

	wire [reg_addr_bits-1:0] rd = RegWrite ? Instr_in[11:7] : {reg_addr_bits{1'b0}};
	wire [reg_addr_bits-1:0] rs1 = Instr_in[19:15];
	wire [reg_addr_bits-1:0] rs2 = ALUSrc ? {reg_addr_bits{1'b0}}: Instr_in[24:20]; // when alusrc is 0 we use the rs2

<<<<<<< HEAD
	wire [bs_bits-1:0] buffer_index_synchronizer; 
	wire [0:bs-1] valid_entries_synchronizer;
	
	Synchronizer #(bs_bits) synchronizer_1 (clk, buffer_index, buffer_index_synchronizer);
	Synchronizer #(bs) synchronizer_2 (clk, valid_entries, valid_entries_synchronizer);
	
	IRT #(bs, regnum) irt_table (clk, rst, buffer_index, rd, rs1, rs2, current_dept);
	IDT #(bs) idt_table (clk, rst, buffer_index_synchronizer, current_dept, valid_entries_synchronizer, independent_instr);
=======
	reg [$clog2(bs)-1:0] bufer_index_synchronizer; 
	
	always@(posedge clk) begin
		bufer_index_synchronizer <= buffer_index;
	end
	
	IRT #(bs, regnum) irt_table (clk, rst, buffer_index, rd, rs1, rs2, current_dept);
	IDT #(bs) idt_table (clk, rst, bufer_index_synchronizer, current_dept, valid_entries, independent_instr);
>>>>>>> parent of d1c287a (valid_entires synchronizer)

endmodule