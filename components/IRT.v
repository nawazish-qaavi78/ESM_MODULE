module IRT #(
	parameter bs = 32,
				 regnum = 16
) (
	input clk, rst,
	input [$clog2(bs)-1:0] buffer_index,
	input [$clog2(regnum)-1:0] rd, rs1, rs2
);

	integer i;
	
	wire [regnum-1:0] current_rs = (rs1 ? {{regnum{1'b1}}<<rs1} : {regnum{1'b0}}) | (rs2 ? {{regnum{1'b1}}<<rs2} : {regnum{1'b0}});
	
	reg [regnum-1:0] IRT_RD [0:bs-1];
	reg [regnum-1:0] IRT_RS [0:bs-1];
	
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
			IRT_RD[buffer_index] <= rd ? {{regnum{1'b1}}<<rd} : {regnum{1'b0}};
			IRT_RS[buffer_index] <= current_rs;
		end
	end
	

endmodule