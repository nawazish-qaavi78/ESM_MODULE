`timescale 1ns/1ps

module tb;
    parameter Instruction_word_size = 32;
    parameter bs = 16;
    parameter regnum = 16;
    
    reg clk, rst, RegWrite, ALUSrc;
    reg [Instruction_word_size-1:0] Instr_in;
    wire [Instruction_word_size-1:0] Instr_out;
    
    // Instantiate the ESM module
    ESM #(Instruction_word_size, bs) dut (
        .Instr_in(Instr_in),
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .Instr_out(Instr_out)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        RegWrite = 0;
        ALUSrc = 0;
        Instr_in = 0;
        
        // Apply reset
        #10 rst = 0;
        
        // Test Case 1: Independent instruction
        #10 Instr_in = 32'h00C58533; // ADD x10, x11, x12 (independent)
        RegWrite = 1; ALUSrc = 1;
        
        // Test Case 2: RAW dependency (Read After Write)
        #10 Instr_in = 32'h00A60533; // ADD x10, x12, x13 (depends on x10 from previous instruction)
        RegWrite = 1; ALUSrc = 1;
        
        // Test Case 3: WAW dependency (Write After Write)
        #10 Instr_in = 32'h00B58533; // ADD x10, x11, x14 (x10 is being written again)
        RegWrite = 1; ALUSrc = 1;
        
        // Test Case 4: WAR dependency (Write After Read)
        #10 Instr_in = 32'h00D50533; // ADD x11, x10, x15 (x10 was read before, now it's being written)
        RegWrite = 1; ALUSrc = 1;
        
        // Test Case 5: Completely independent instruction
        #10 Instr_in = 32'h00E68633; // ADD x12, x13, x14 (no dependencies)
        RegWrite = 1; ALUSrc = 1;
        
        // Hold and observe behavior
        #50;
        
        // Reset and re-test
        #10 rst = 1;
        #10 rst = 0;
        
        #50;
        $stop;
    end
endmodule
