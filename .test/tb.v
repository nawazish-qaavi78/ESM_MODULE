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
        
        // Test Case 1: Provide different instructions to ESM
        #10 Instr_in = 32'h00C58533; // Example R-type instruction (ADD x10, x11, x12)
        RegWrite = 1; ALUSrc = 0;
        
        #10 Instr_in = 32'h00450613; // Example I-type instruction (ADDI x12, x10, 4)
        RegWrite = 1; ALUSrc = 1;
        
        #10 Instr_in = 32'h00000013; // Example NOP (No Operation)
        RegWrite = 0; ALUSrc = 0;
        
        // Test Case 2: Edge cases where rd, rs1, or rs2 is 0
        #10 Instr_in = 32'h00058533; // ADD x0, x11, x12
        RegWrite = 1; ALUSrc = 0;
        
        #10 Instr_in = 32'h00000613; // ADDI x12, x0, 0
        RegWrite = 1; ALUSrc = 1;
        
        #10 Instr_in = 32'h00450013; // ADDI x0, x10, 4
        RegWrite = 0; ALUSrc = 1;
        
        // Hold and observe behavior
        #50;
        
        // Reset and re-test
        #10 rst = 1;
        #10 rst = 0;
        
        #50;
        $stop;
    end
endmodule
