module PC(
	input i_Clk,
	input i_Rst,
	input i_Branch,
	input [15:0] i_BranchOffset,
	input [15:0] i_JumpOffset,
	input i_Jump,
	output o_PC
	);


reg [15:0] r_PC;

always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) 
		r_PC <= 0;		
	 
	else if(i_Branch) 
		r_PC <= r_PC + i_BranchOffset;	
	
	else if(i_Jump) 
		r_PC <= r_PC + i_JumpOffset;
	
	else 
		r_PC <= r_PC + 16'd2;
	

assign o_PC = r_PC;

endmodule