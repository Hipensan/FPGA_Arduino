module ALU(
//////////////////////////////////////
//// 	normal ALU interface 
	input i_ALUSrc,			//R value or I value select flag
	input [1:0] i_ALUcnt,	//Calc	
	input [15:0] i_Data0,
	input [15:0] i_Data1,
	
	output reg [15:0] o_Data,

////////////////////////////////
//// 	jump & branch interface 
	input i_Branch,
	input i_Jump,
	input [15:0] i_PC,
	input [12:0] i_JumpAddr,
	input [2:0] i_JumpOp,
	output reg [15:0] o_PC,
	output reg o_Branch
	);




always@* begin
	o_Data 		<= 0;
	o_PC		<= 0;
	o_Branch 	<= 0;

	if(!i_Branch & !i_Jump)
		case(i_ALUcnt)
			3'b000 : 
				o_Data <= i_Data0 + i_Data1;
			3'b001 :
				o_Data <= i_Data0 - i_Data1;
			3'b010 :
				o_Data <= i_Data0 & i_Data1;
			3'b011 :
				o_Data <= i_Data0 | i_Data1;
			3'b100 :
				o_Data <= i_Data0 < i_Data1;
			3'b111 :	//Jr
				o_PC <= i_Data0;
			default : 
				o_Data = 0;
		endcase

	else if(i_Branch)
		o_Branch <= (i_Data0 - i_Data1) == 16'b0;	//is BEQ ?

	else 	//if Jump
		if(i_JumpOp == 3'd2) 	//jump
			o_PC <= i_JumpAddr;





end


endmodule