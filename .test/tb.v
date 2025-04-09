`timescale 1ns/1ps

module tb;

	parameter Instruction_word_size = 32;
	parameter bs = 16;

	// Inputs
	reg clk;
	reg rst;
	reg RegWrite;
	reg ALUSrc;
	reg [Instruction_word_size-1:0] Instr_in;

	// Output
	wire [Instruction_word_size-1:0] Instr_out;

	// Instantiate the Unit Under Test (UUT)
	ESM #(Instruction_word_size, bs) uut (
		.Instr_in(Instr_in),
		.clk(clk),
		.rst(rst),
		.RegWrite(RegWrite),
		.ALUSrc(ALUSrc),
		.Instr_out(Instr_out)
	);

	// Clock generation
	initial begin
		clk = 0;
		forever #5 clk = ~clk; // 10ns clock period
	end

	// Instruction format: opcode[6:0], rd[11:7], funct3[14:12], rs1[19:15], rs2[24:20], funct7[31:25]
	// R-type: add, sub, etc.
	// add x2, x1, x3 → opcode=0110011, funct3=000, funct7=0000000

	task feed_instr;
		input [Instruction_word_size-1:0] instr;
		begin
			Instr_in = instr;
			#10;
		end
	endtask

	initial begin
		// Initial setup
		rst = 1;
		RegWrite = 1;  // enable register write for R-type
		ALUSrc = 0;    // use rs2
		Instr_in = 0;
		#20;
		rst = 0;

		// Feed independent instructions
		// add x1, x2, x3
		feed_instr({7'b0000000, 5'd3, 5'd2, 3'b000, 5'd1, 7'b0110011}); // rd = x1
		// add x4, x5, x6
		feed_instr({7'b0000000, 5'd6, 5'd5, 3'b000, 5'd4, 7'b0110011}); // rd = x4
		// add x7, x8, x9
		feed_instr({7'b0000000, 5'd9, 5'd8, 3'b000, 5'd7, 7'b0110011}); // rd = x7

		// Feed dependent instructions
		// add x10, x1, x4 (depends on x1 and x4)
		feed_instr({7'b0000000, 5'd4, 5'd1, 3'b000, 5'd10, 7'b0110011});
		// add x11, x10, x0 (depends on x10)
		feed_instr({7'b0000000, 5'd0, 5'd10, 3'b000, 5'd11, 7'b0110011});
		// add x12, x7, x1 (depends on x7 and x1)
		feed_instr({7'b0000000, 5'd1, 5'd7, 3'b000, 5'd12, 7'b0110011});
		// Independent again
		// add x13, x14, x15
		feed_instr({7'b0000000, 5'd15, 5'd14, 3'b000, 5'd13, 7'b0110011});

		// Let the simulation run a bit more
		#100;

		$display("Simulation finished.");
		$stop;
	end

endmodule
