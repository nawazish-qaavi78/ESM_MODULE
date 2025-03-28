module IRT #(
	parameter bs = 32,
				 regnum = 16
) (
	input clk, rst,
	input [$clog2(bs)-1:0] buffer_index,
	input [$clog2(regnum)-1:0] rd, rs1, rs2
);

	integer i;
	integer j;
	
	wire [regnum-1:0] current_rs = (rs1 ? {1<<rs1} : {regnum{1'b0}}) | (rs2 ? {1<<rs2} : {regnum{1'b0}});
	
	reg [regnum-1:0] IRT_RD [0:bs-1];
	reg [regnum-1:0] IRT_RS [0:bs-1];
	
	reg [0:bs-1] raw = {bs{1'b1}};
	
	// by default all are 1, since that will mean no independent instruction detected yet
	initial begin
		for(i=0; i<bs; i=i+1) begin
			IRT_RD[i] <= {{(regnum-1){1'b1}}, 1'b0}; // no instruction is dependent on x0 since it is always grounded 
			IRT_RS[i] <= {{(regnum-1){1'b1}}, 1'b0};
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst) for(i=0; i<bs; i=i+1) begin
			IRT_RD[i] <= {{(regnum-1){1'b1}}, 1'b0};
			IRT_RS[i] <= {{(regnum-1){1'b1}}, 1'b0};
		end else begin
			IRT_RD[buffer_index] <= rd ? {1<<rd} : {regnum{1'b0}};
			IRT_RS[buffer_index] <= current_rs;
		end
	end
	
	always@(*) begin
		if(rst) begin
			raw = {bs{1'b1}};
		end else begin
			for(j=0; j<bs; j=j+1) begin
				if(j != buffer_index) begin
					// what i'm doing is: looping through each instruction, if somewhere i match such that i'm writing, i.e. irt_rd[j][r] = 1, that means i'm dependent on that instruciton
					raw[j] = IRT_RD[j][rs1] | IRT_RD[j][rs2]; 
				end else begin
					raw[j] = 1'b0; // since an instruction can't be dependent on it self
				end
			end
		end
	end
	

endmodule