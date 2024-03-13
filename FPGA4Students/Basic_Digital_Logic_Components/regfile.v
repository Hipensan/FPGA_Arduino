module regfile(
	input i_Clk,
	input i_Rst,
	input i_fWE,
	input [2:0] i_Rd,
	input [15:0] i_Data,

	input [2:0] i_Rs1,
	input [2:0] i_Rs2,

	output [15:0] o_Data1,
	output [15:0] o_Data2
	);

reg [15:0] r_Reg[0:7];
integer i;
always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		for(i = 0; i < 8; i=i+1)
			r_Reg[i] <= 0;
	end else begin
		if(i_fWE)
			r_Reg[i_Rd] <= i_Data;	 //if i_fWE off, the value is preserved because it's reg
	end

assign o_Data1 = r_Reg[i_Rs1];
assign o_Data2 = r_Reg[i_Rs2];

endmodule





