module PRNG #(
	parameter bs = 16
) (
	input clk, rst,
	output [$clog2(bs)-1:0] random_number
);
	 
	localparam bs_bits = $clog2(bs);
	
	reg [31:0] q = 32'haaaaaaaa;
	
	wire feedback = q[31]^q[29]^q[28]^ q[27]^ q[23]^q[20]^ q[19]^q[17]^ q[15]^q[14]^q[12]^ q[11]^q[9]^ q[4]^ q[3]^q[2];
	
	always @(posedge clk or posedge rst)
	  if (rst) 
		 q <= 32'haaaaaaaa;
	  else
		 q <= {q[30:0], feedback} ;
		 
	assign random_number = q[bs_bits-1:0];

endmodule