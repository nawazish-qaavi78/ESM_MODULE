module MappingTable #(
	parameter bs = 16
) (
	input clk, rst, proceed,
	input [0:bs-1] candidate_list,
	input [$clog2(bs)-1: 0] buffer_index, buffer_index_synchronizer_1, buffer_index_synchronizer_2,
	input [$clog2(bs)-1: 0] random_number,
	output [$clog2(bs)-1: 0] next_buffer_index,
	output valid_count
);
	localparam bs_bits = $clog2(bs);
	
	integer i,j;
	
	reg [bs_bits-1:0] next_buffer_index_copy;
	
	reg [bs_bits-1:0] mapping_table [0:bs-1];
	reg [bs_bits-1:0] next_mapping_table [0:bs-1];
	
	reg [bs_bits-1:0] count = {bs_bits{1'b0}};
	
	always@(*) begin
		count = 0;
		for(i=0; i<bs; i=i+1)
			next_mapping_table[i] = 1'b0; // to prevent inferred latches
			
		for(i=0; i<bs; i=i+1) begin
			if(candidate_list[i] && (i!= buffer_index && i!=buffer_index_synchronizer_1
				&& i!=buffer_index_synchronizer_2 && (!proceed || i != next_buffer_index_copy))) begin
				next_mapping_table[count] = i;
				count = count + 1'b1;
			end 
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst) for(j=0; j<bs; j=j+1)
			mapping_table[j] <= 1'b0;
		else for(j=0; j<bs; j=j+1)
			mapping_table[j] <= next_mapping_table[j];
	end
	
	always@(posedge clk)
		next_buffer_index_copy <= next_buffer_index;
	
	assign next_buffer_index = count ? (mapping_table[random_number%count]) : 1'b0;
	assign valid_count = |count;

endmodule