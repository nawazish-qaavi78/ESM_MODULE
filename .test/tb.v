`timescale 1ns/1ps

module tb;
    parameter bs = 16;
    parameter regnum = 16;
    
    reg clk, rst;
    reg [$clog2(bs)-1:0] buffer_index;
    reg [$clog2(regnum)-1:0] rd, rs1, rs2;
    
    // Instantiate the IRT module
    IRT #(bs, regnum) dut (
        .clk(clk),
        .rst(rst),
        .buffer_index(buffer_index),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        buffer_index = 0;
        rd = 0;
        rs1 = 0;
        rs2 = 0;
        
        // Apply reset
        #10 rst = 0;
        
        // Test Case 1: Write and Read from the IRT table
        #10 buffer_index = 4; rd = 3; rs1 = 5; rs2 = 7;
        #10 buffer_index = 8; rd = 2; rs1 = 6; rs2 = 9;
        #10 buffer_index = 2; rd = 1; rs1 = 4; rs2 = 8;
        
        // Hold and observe behavior
        #50;
        
        // Test Case 2: Ensure values persist across clock cycles
        buffer_index = 4;
        #10 buffer_index = 8;
        #10 buffer_index = 2;
        
        // Test Case 3: Reset behavior
        #10 rst = 1;
        #10 rst = 0;
        
        // Test Case 4: Conditions where rd, rs1, or rs2 is 0
        #10 buffer_index = 3; rd = 0; rs1 = 7; rs2 = 9;
        #10 buffer_index = 5; rd = 6; rs1 = 0; rs2 = 8;
        #10 buffer_index = 7; rd = 4; rs1 = 5; rs2 = 0;
        
        #50;
        $stop;
    end
endmodule
