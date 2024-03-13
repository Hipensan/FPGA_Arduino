module ALU(
	input [2:0] i_ALUOp,
	input [15:0] i_Data0,
	input [15:0] i_Data1,
	output [15:0] o_Data,
	output zero
	);


always@* begin
	case(i_ALUOp)
		3'b000 : o_Data = i_Data0 + i_Data1;
		
		3'b001 : o_Data = i_Data0 - i_Data1;

		3'b010 : o_Data = i_Data0 & i_Data1;		

		3'b011 : o_Data = i_Data0 | i_Data1;		

		3'b100 : o_Data = i_Data0 ^ i_Data1;		

		3'b101 : o_Data = i_Data0 << i_Data1;		

		3'b110 : o_Data = i_Data0 >> i_Data1;
		
		3'b111 : o_Data = i_Data0 < i_Data1;
		
		default : o_Data = 0;
	endcase

assign zero = o_Data == 0;
end