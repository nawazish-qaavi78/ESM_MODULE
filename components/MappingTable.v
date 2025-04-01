module MappingTable #(
	parameter bs = 16
) (
	input clk, rst,
	input [0:bs-1] candidate_list
);
	localparam bs_bits = $clog2(bs);
	
	integer i;
	
	reg [bs_bits-1:0] mapping_table [0:bs-1];
	
	reg [bs_bits-1:0] count = {bs_bits{1'b0}};
	
	always@(posedge clk, posedge rst) begin
		if(rst) begin
			count <= 1'b0;
			for(i=0; i<bs; i=i+1) 
				mapping_table[i] <= 1'b0;
		end else begin
			for(i=0; i<bs; i=i+1) begin
				if(candidate_list[i]) begin
					mapping_table[count] <= i;
					count <= count + 1'b1;
				end
			end
		end
	end

endmodule