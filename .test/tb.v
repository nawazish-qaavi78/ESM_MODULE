`timescale 1 ns/1 ns

module tb;
    parameter Instruction_word_size = 16;
    reg [Instruction_word_size-1:0] Instr_in;
    reg clk, rst;
    wire [Instruction_word_size-1:0] Instr_out;

    ESM #(Instruction_word_size, 16) dut (Instr_in, clk, rst, Instr_out);

    initial begin
        rst = 1'b0;
        clk = 1'b0;
        forever #5 clk = ~clk;
        rst = 1'b1;
        #3 rst = 1'b0;
    end

    initial begin
        Instr_in = 16'h0000;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 Instr_in = Instr_in + 1'b1;
        #10 $stop;
    end

    always@(negedge clk) begin
        $display("%d is executed", Instr_in);
    end

endmodule