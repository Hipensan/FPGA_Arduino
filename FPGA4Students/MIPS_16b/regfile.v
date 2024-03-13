module Regfile(
	input [2:0] i_Rs,
	input [2:0] i_Rt,
	input [2:0] i_Rd,
	input i_fWE,
	input [15:0] i_Data,
	output [15:0] o_Data1,
	output [15:0] o_Data2
	);

reg [15:0] r_Reg[0:7]; 	//16-bit registers, 8 ea(3-bit)

integer i;
initial
begin
	for(i = 0; i < 8; i = i+1) 
		r_Reg[i] <= 0;	
end

always@* begin
	if(i_fWE) begin
		r_Reg[i_Rd] <= i_Data;
	end
end

assign o_Data1 = r_Reg[i_Rs];
assign o_Data2 = r_Reg[i_Rt];

endmodule