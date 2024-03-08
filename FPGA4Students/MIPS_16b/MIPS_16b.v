module MIPS(
	input i_Clk,
	input i_Rst
	);


wire [15:0] cur_PC;

PC PC0(
	.i_Clk(i_Clk),
	.i_Rst(i_Rst),
	.o_PC(cur_PC)
	);




endmodule





module PC(
	input i_Clk,
	input i_Rst,
	output o_PC
	);


reg [15:0] r_PC;

always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		r_PC <= 0;		
	end else begin
		r_PC <= r_PC + 16'd2;
	end

assign o_PC = r_PC;

endmodule






module control(
	input [2:0] i_Opcode, 	//Opcode(3bits)
	output reg [1:0] o_RegDst,
	output reg o_ALUSrc,
	output reg [1:0] o_MemtoReg,
	output reg o_RegWrite,
	output reg o_MemRead,
	output reg o_MemWrite,
	output reg o_Branch,
	output reg [1:0] o_ALUOp,
	output reg o_Jump
	);

always@* begin
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
		end
		3'b110 : begin	//jal
			o_RegDst	<= 2'b10;
			o_ALUSrc	<= 0;
			o_MemtoReg	<= 2'b10;
			o_RegWrite	<= 1;
			o_MemRead	<= 0;
			o_MemWrite	<= 0;
			o_Branch	<= 0;
			o_ALUOp		<= 2'b00;
			o_Jump		<= 1;
		end
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
		end
		default : begin
			o_RegDst	<= 2'b00;
			o_ALUSrc	<= 0;
			o_MemtoReg	<= 2'b00;
			o_RegWrite	<= 0;
			o_MemRead	<= 0;
			o_MemWrite	<= 0;
			o_Branch	<= 0;
			o_ALUOp		<= 2'b00;
			o_Jump		<= 0;
		end
	endcase
end

endmodule





module IMEM(
	input [15:0] i_PC,
	output [15:0] o_Inst
	);

reg [15:0] r_Inst[0:15];

initial
begin
	r_Inst[0] = 16'b1000000110000000;  
	r_Inst[1] = 16'b0010110010110010;  
	r_Inst[2] = 16'b1101110001100111;  
	r_Inst[3] = 16'b1101110111011001;  
	r_Inst[4] = 16'b1111110110110001;  
	r_Inst[5] = 16'b1100000001111011; 
	r_Inst[6] = 16'b0000000000000000;  
	r_Inst[7] = 16'b0000000000000000;  
	r_Inst[8] = 16'b0000000000000000;  
	r_Inst[9] = 16'b0000000000000000;  
	r_Inst[10] = 16'b0000000000000000;  
	r_Inst[11] = 16'b0000000000000000;  
	r_Inst[12] = 16'b0000000000000000;  
	r_Inst[13] = 16'b0000000000000000;  
	r_Inst[14] = 16'b0000000000000000;  
	r_Inst[15] = 16'b0000000000000000; 
end

assign o_Inst = r_Inst[i_PC >> 1];
endmodule







module Regfile(

	);


endmodule







module ALU(

	);

endmodule








module DMEM(

	);



endmodule

















