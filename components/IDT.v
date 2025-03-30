module IDT #(
	parameter bs = 16
) (
	input clk, rst,
	input [$clog2(bs)-1:0] buffer_index,
	input [0:bs-1] current_dept,
	input [0:bs-1] valid_entries,
	output reg [0:bs-1] independent_instr
);
	
	integer i,j;
	reg [0:bs-1] idt [0:bs-1];
	
	initial begin
		for(i=0; i<bs; i=i+1) 
			idt[i] = {bs{1'b0}}; // by default all are independent instructions
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst) begin
			for(i=0; i<bs; i=i+1) 
				idt[i] = {bs{1'b0}};
		end else begin
			idt[buffer_index] = current_dept; // updating the current buffer_index
			// since new instruction is being added at buffer_index that means previous instr is executed and the instructions that are dependent on the prev one are now free to execute
			// hence reseting the dependcy on that particular instruction in the table
			for(i=0; i<bs; i=i+1) 
				idt[i][buffer_index]= 1'b0;
		end
	end
	
	always@(*) begin
		for(j=0; j<bs; j= j+1) 
			independent_instr[j] = valid_entries[j] & (~(|idt[j])); // if independent[j] = 1 then the instruction at j is independent
	end
	
endmodule