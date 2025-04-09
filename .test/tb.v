`timescale 1ns/1ps

module tb;

  // Parameters for Instruction size and Buffer size
  localparam Instruction_word_size = 32;
  localparam bs = 16;

  // Testbench signals
  reg  [Instruction_word_size-1:0] Instr_in;
  reg  clk, rst, RegWrite, ALUSrc;
  wire [Instruction_word_size-1:0] Instr_out;
  
  // Instantiate the top-level ESM module
  ESM #(
    .Instruction_word_size(Instruction_word_size),
    .bs(bs)
  ) UUT (
    .Instr_in(Instr_in),
    .clk(clk),
    .rst(rst),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .Instr_out(Instr_out)
  );
  
  // Clock generation: 10 ns period (5 ns high, 5 ns low)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  //------------------------------------------------------------------------------
  // Define local parameters for instructions with RV32I assembly comments
  //------------------------------------------------------------------------------
  // I0:  addi x1, x0, 10      => Sets x1 = 0 + 10
  localparam I0  = 32'h00A00093;
  // I1:  addi x2, x0, 20      => Sets x2 = 0 + 20
  localparam I1  = 32'h01400113;
  // I2:  add x3, x1, x2       => x3 = x1 + x2
  localparam I2  = 32'h002081B3;
  // I3:  sub x4, x2, x1       => x4 = x2 - x1 (using funct7 = 0x20 for subtraction)
  localparam I3  = 32'h40A10133;
  // I4:  and x5, x3, x4       => x5 = x3 & x4
  localparam I4  = 32'h004182B3;
  // I5:  or x6, x3, x4        => x6 = x3 | x4
  localparam I5  = 32'h004182F3;
  // I6:  xor x7, x1, x2       => x7 = x1 ^ x2
  localparam I6  = 32'h00208333;
  // I7:  lui x8, 0x10000      => Load upper immediate, x8 = 0x10000
  localparam I7  = 32'h004004B7;
  // I8:  auipc x9, 0x20000    => x9 = PC + 0x20000 (PC-relative addressing)
  localparam I8  = 32'h00800517;
  // I9:  slli x10, x1, 2      => x10 = x1 << 2 (logical left shift by 2)
  localparam I9  = 32'h00205093;
  // I10: srli x11, x2, 3      => x11 = x2 >> 3 (logical right shift by 3)
  localparam I10 = 32'h00305113;
  // I11: srai x12, x3, 1      => x12 = x3 >>> 1 (arithmetic right shift by 1)
  localparam I11 = 32'h40106213;
  // I12: slti x13, x4, 5      => x13 = (x4 < 5) ? 1 : 0
  localparam I12 = 32'h00508493;
  // I13: beq x5, x6, label    => Branch if x5 equals x6
  localparam I13 = 32'h00A2E063;
  // I14: bne x7, x0, label    => Branch if x7 is not equal to x0
  localparam I14 = 32'h00B30463;
  // I15: jal x1, label        => Jump and link; jump to label and save return address in x1
  localparam I15 = 32'h004000EF;
  // I16: jalr x2, x1, 0       => Jump register; set PC to (x1+0) and save next PC in x2
  localparam I16 = 32'h00008067;
  // I17: lb x3, 0(x4)         => Load byte from memory at address in x4 into x3
  localparam I17 = 32'h00022283;
  // I18: sb x5, 4(x6)         => Store byte; store lower byte of x5 at address (x6 + 4)
  localparam I18 = 32'h0042A423;
  // I19: lw x7, 0(x8)         => Load word from memory at address in x8 into x7
  localparam I19 = 32'h0003A283;

  //------------------------------------------------------------------------------
  // Create an array for instructions for easier iteration
  //------------------------------------------------------------------------------
  integer i;
  reg [31:0] test_instructions [0:19];
  
  //------------------------------------------------------------------------------
  // Apply test vectors sequentially: each instruction is applied for 10 ns.
  //------------------------------------------------------------------------------
  initial begin
    // Load the instruction array with the localparams I0 to I19
    test_instructions[0]  = I0;
    test_instructions[1]  = I1;
    test_instructions[2]  = I2;
    test_instructions[3]  = I3;
    test_instructions[4]  = I4;
    test_instructions[5]  = I5;
    test_instructions[6]  = I6;
    test_instructions[7]  = I7;
    test_instructions[8]  = I8;
    test_instructions[9]  = I9;
    test_instructions[10] = I10;
    test_instructions[11] = I11;
    test_instructions[12] = I12;
    test_instructions[13] = I13;
    test_instructions[14] = I14;
    test_instructions[15] = I15;
    test_instructions[16] = I16;
    test_instructions[17] = I17;
    test_instructions[18] = I18;
    test_instructions[19] = I19;
    
    // Initialize control signals
    rst = 1;
    RegWrite = 0;
    ALUSrc = 0;
    Instr_in = 32'b0;
    
    // Assert reset for a few cycles
    #15;
    rst = 0;
    #10;
    
    $display("---- Starting Simulation at time %0t ----", $time);
    
    // Loop through the instructions one at a time
    for (i = 0; i < 20; i = i + 1) begin
      // Set control signals based on the instruction type (adjust based on your design)
      // Here, we assume branch instructions (I13, I14) and store instructions (I18) do not write to register file.
      case (i)
        13, 14, 18: begin 
                      RegWrite = 0; 
                      ALUSrc   = 0; 
                    end
        default: begin 
                   RegWrite = 1; 
                   // For immediate instructions, set ALUSrc high; for register–register, keep low.
                   // This simple assignment may be refined per your design details:
                   ALUSrc = (i == 0 || i == 1 || i == 9 || i == 10 || i == 11 || i == 12) ? 1 : 0;
                 end
      endcase
      // Apply the instruction from our array
      Instr_in = test_instructions[i];
      #10;
    end
    
    // Optionally, signal end of instruction stream with an all-zero instruction
    Instr_in = 32'h00000000;
    RegWrite = 0;
    ALUSrc   = 0;
    #10;
    
    $display("---- Simulation complete at time %0t ----", $time);
    $stop;
  end

  always @(negedge clk ) begin
	case (Instr_out)
		I0: $display("Instruction I0 is being executed");
		I1: $display("Instruction I1 is being executed");
		I2: $display("Instruction I2 is being executed");
		I3: $display("Instruction I3 is being executed");
		I4: $display("Instruction I4 is being executed");
		I5: $display("Instruction I5 is being executed");
		I6: $display("Instruction I6 is being executed");
		I7: $display("Instruction I7 is being executed");
		I8: $display("Instruction I8 is being executed");
		I9: $display("Instruction I9 is being executed");
		I10: $display("Instruction I10 is being executed");
		I11: $display("Instruction I11 is being executed");
		I12: $display("Instruction I12 is being executed");
		I13: $display("Instruction I13 is being executed");
		I14: $display("Instruction I14 is being executed");
		I15: $display("Instruction I15 is being executed");
		I16: $display("Instruction I16 is being executed");
		I17: $display("Instruction I17 is being executed");
		I18: $display("Instruction I18 is being executed");
		I19: $display("Instruction I19 is being executed");
		default: $display("Random Instruction is being executed");
	endcase
  end

endmodule
