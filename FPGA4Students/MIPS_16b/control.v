module control(
	input [2:0] i_Opcode, 	//Opcode(3bits)
	input [3:0] i_Funct,
	output reg [1:0] o_RegDst,
	output reg o_ALUSrc,
	output reg [1:0] o_MemtoReg,
	output reg o_RegWrite,
	output reg o_MemRead,
	output reg o_MemWrite,
	output reg o_Branch,
	output reg [1:0] o_ALUOp,
	output reg o_Jump,
	output reg [2:0] o_ALUcnt
	);

always@* begin
	o_RegDst	<= 2'b00;
	o_ALUSrc	<= 0;
	o_MemtoReg	<= 2'b00;
	o_RegWrite	<= 0;
	o_MemRead	<= 0;
	o_MemWrite	<= 0;
	o_Branch	<= 0;
	o_ALUOp		<= 2'b00;
	o_Jump		<= 0;
	o_ALUcnt 	<= 0;
	
	case(i_Opcode)
		3'b000 : begin	//R-Type
			o_RegDst	<= 2'b01;
			o_ALUSrc	<= 0;
			o_MemtoReg	<= 2'b00;
			o_RegWrite	<= 1;
			o_MemRead	<= 0;
			o_MemWrite	<= 0;
			o_Branch	<= 0;
			o_ALUOp		<= 2'b00;
			o_Jump		<= 0;
			case(i_Funct)
				3'd0 : o_ALUcnt 	<= 3'b000;	//ADD
				3'd1 : o_ALUcnt 	<= 3'b001;	//SUB
				3'd2 : o_ALUcnt 	<= 3'b010;	//AND
				3'd3 : o_ALUcnt 	<= 3'b011;	//OR
				3'd4 : o_ALUcnt 	<= 3'b100;	//SLT
				3'd8 : o_ALUcnt 	<= 3'b111;	//JR
				default : o_ALUcnt 	<= 0;
		end
		3'b001 : begin	//LW
			o_RegDst	<= 2'b00;
			o_ALUSrc	<= 1;
			o_MemtoReg	<= 2'b01;
			o_RegWrite	<= 1;
			o_MemRead	<= 1;
			o_MemWrite	<= 0;
			o_Branch	<= 0;
			o_ALUOp		<= 2'b11;
			o_Jump		<= 0;
			o_ALUcnt 	<= 3'b000;
		end
		3'b010 : begin	//SW
			o_RegDst	<= 2'b00;
			o_ALUSrc	<= 1;
			o_MemtoReg	<= 2'b00;
			o_RegWrite	<= 0;
			o_MemRead	<= 0;
			o_MemWrite	<= 1;
			o_Branch	<= 0;
			o_ALUOp		<= 2'b11;
			o_Jump		<= 0;
			o_ALUcnt 	<= 3'b000;
		end
		3'b011 : begin	//addi
			o_RegDst	<= 2'b00;
			o_ALUSrc	<= 1;
			o_MemtoReg	<= 2'b00;
			o_RegWrite	<= 1;
			o_MemRead	<= 0;
			o_MemWrite	<= 0;
			o_Branch	<= 0;
			o_ALUOp		<= 2'b11;
			o_Jump		<= 0;
			o_ALUcnt 	<= 3'b000;
		end
		3'b100 : begin	//beq
			o_RegDst	<= 2'b00;
			o_ALUSrc	<= 0;
			o_MemtoReg	<= 2'b00;
			o_RegWrite	<= 0;
			o_MemRead	<= 0;
			o_MemWrite	<= 0;
			o_Branch	<= 1;
			o_ALUOp		<= 2'b01;
			o_Jump		<= 0;
			o_ALUcnt 	<= 3'b001;
		end
		3'b101 : begin	//j
			o_RegDst	<= 2'b00;
			o_ALUSrc	<= 0;
			o_MemtoReg	<= 2'b00;
			o_RegWrite	<= 0;
			o_MemRead	<= 0;
			o_MemWrite	<= 0;
			o_Branch	<= 0;
			o_ALUOp		<= 2'b00;
			o_Jump		<= 1;
			o_ALUcnt 	<= 3'b000;
		end
		// 3'b110 : begin	//jal
		// 	o_RegDst	<= 2'b10;
		// 	o_ALUSrc	<= 0;
		// 	o_MemtoReg	<= 2'b10;
		// 	o_RegWrite	<= 1;
		// 	o_MemRead	<= 0;
		// 	o_MemWrite	<= 0;
		// 	o_Branch	<= 0;
		// 	o_ALUOp		<= 2'b00;
		// 	o_Jump		<= 1;
		// 	o_ALUcnt 	<= 3'b000;
		// end
		3'b111 : begin	//slti
			o_RegDst	<= 2'b00;
			o_ALUSrc	<= 1;
			o_MemtoReg	<= 2'b00;
			o_RegWrite	<= 1;
			o_MemRead	<= 0;
			o_MemWrite	<= 0;
			o_Branch	<= 0;
			o_ALUOp		<= 2'b10;
			o_Jump		<= 0;
			o_ALUcnt 	<= 3'b100;
		end
	endcase
end

endmodule