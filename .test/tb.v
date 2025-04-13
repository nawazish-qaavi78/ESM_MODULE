`timescale 1ns/1ps

module tb;

  // Parameters for Instruction word size and buffer size
  localparam Instruction_word_size = 32;
  localparam bs = 16;

  // Testbench signal declarations
  reg  [Instruction_word_size-1:0] Instr_in;
  reg  clk, rst, RegWrite, ALUSrc;
  wire [Instruction_word_size-1:0] Instr_out;
  
  //-------------------------------------------------------------------------
  // Instantiate the top-level ESM module
  //-------------------------------------------------------------------------
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
  
  //-------------------------------------------------------------------------
  // Clock generation: 10 ns period (5 ns high, 5 ns low)
  //-------------------------------------------------------------------------
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  //-------------------------------------------------------------------------
  // Define localparams for 20 RV32I instructions (no jump, branch, or auipc)
  //-------------------------------------------------------------------------
  // I0:  addi x1, x0, 10      => x1 = 0 + 10
  localparam I0  = 32'h00A00093;
  // I1:  addi x2, x0, 20      => x2 = 0 + 20
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
  // I7:  lui x8, 0x10000      => x8 = 0x10000 (upper immediate load)
  localparam I7  = 32'h004004B7;
  // I8:  addi x9, x0, 30      => x9 = 0 + 30 
  localparam I8  = 32'h01E00413;
  // I9:  slli x10, x1, 2      => x10 = x1 << 2 (logical shift left)
  localparam I9  = 32'h00205093;
  // I10: srli x11, x2, 3      => x11 = x2 >> 3 (logical shift right)
  localparam I10 = 32'h00305113;
  // I11: srai x12, x3, 1      => x12 = x3 >>> 1 (arithmetic shift right)
  localparam I11 = 32'h40106213;
  // I12: slti x13, x4, 5      => x13 = (x4 < 5) ? 1 : 0
  localparam I12 = 32'h00508493;
  // I13: addi x14, x0, 15     => x14 = 0 + 15
  localparam I13 = 32'h00F00713;
  // I14: add x15, x1, x14     => x15 = x1 + x14
  localparam I14 = 32'h00E082B3;  // Approximate encoding for an ADD
  // I15: sub x16, x2, x14     => x16 = x2 - x14 (using subtraction encoding)
  localparam I15 = 32'h40E0C133;  // Approximate encoding for a SUB
  // I16: and x17, x3, x16     => x17 = x3 & x16
  localparam I16 = 32'h0103E1B3;  // Approximate encoding for an AND
  // I17: or x18, x4, x16      => x18 = x4 | x16
  localparam I17 = 32'h00E1F233;  // Approximate encoding for an OR
  // I18: xor x19, x5, x6      => x19 = x5 ^ x6
  localparam I18 = 32'h0021A333;  // Approximate encoding for an XOR
  // I19: addi x20, x0, 100    => x20 = 0 + 100
  localparam I19 = 32'h06400893;
  
  //-------------------------------------------------------------------------
  // Create an array for instructions for easier iteration
  //-------------------------------------------------------------------------
  integer i;
  reg [31:0] test_instructions [0:19];
  
  //-------------------------------------------------------------------------
  // Apply test vectors sequentially
  //-------------------------------------------------------------------------
  initial begin
    // Load the instruction array with defined localparams I0 to I19
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
    
    // Initialize control signals and inputs
    rst = 1;
    RegWrite = 0;
    ALUSrc = 0;
    Instr_in = 32'b0;
    
    // Assert reset for several cycles
    #15;
    rst = 0;
    #10;
    
    $display("---- Starting Simulation at time %0t ----", $time);
    
    // Loop through each test instruction
    for (i = 0; i < 20; i = i + 1) begin
      // Set control signals; here, we assume all these instructions will write to a register.
      RegWrite = 1;
      // For simplicity, we assume immediate-type instructions need ALUSrc high.
      // Adjust the ALUSrc assignment based on the instruction type if needed.
      case(i)
        0, 1, 8, 9, 10, 11, 12, 13, 19: ALUSrc = 1;
        default: ALUSrc = 0;
      endcase
      
      // Apply the instruction from the array
      Instr_in = test_instructions[i];
      #10;
    end
    
    // Optionally, provide an all-zero instruction to signal the end of the instruction stream
    for(i=0; i<40; i=i+1) begin
      Instr_in = 32'h00000000;
      RegWrite = 0;
      ALUSrc   = 0;
      #10;
    end
    
    $display("---- Simulation complete at time %0t ----", $time);
    $stop;
  end

  always @(negedge clk ) begin
<<<<<<< HEAD
    case (Instr_out)
      I0: $display("I0");
      I1: $display("I1");
      I2: $display("I2");
      I3: $display("I3");
      I4: $display("I4");
      I5: $display("I5");
      I6: $display("I6");
      I7: $display("I7");
      I8: $display("I8");
      I9: $display("I9");
      I10: $display("I10");
      I11: $display("I11");
      I12: $display("I12");
      I13: $display("I13");
      I14: $display("I14");
      I15: $display("I15");
      I16: $display("I16");
      I17: $display("I17");
      I18: $display("I18");
      I19: $display("I19");
    endcase
=======
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
>>>>>>> parent of d1c287a (valid_entires synchronizer)
  end

endmodule
