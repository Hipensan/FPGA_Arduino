module MIPS_16b(
	input i_Clk,
	input i_Rst
	);


/////////////////////////
//// PC module

wire [15:0] cur_PC;
wire [15:0] BranchOffset;
wire [15:0] JumpOffset;
assign BranchOffset = Inst[6:0];
assign JumpOffset = Inst[12:0];
PC PC0(
	.i_Clk			(i_Clk),
	.i_Rst			(i_Rst),
	.i_Branch      	(Branch),
	.i_BranchOffset	(BranchOffset),
	.i_JumpOffset  	(JumpOffset),
	.i_Jump        	(Jump),
	.o_PC 			(cur_PC)
	);

/////////////////////////
//// IMEM module

wire [15:0] Inst;
IMEM IM0(
	.i_PC(cur_PC),
	.o_Inst(Inst)
	);

/////////////////////////
//// controller
wire [2:0] Opcode;
wire [3:0] Funct;
assign Opcode = Inst[15:13];
assign Funct = Inst[3:0];

wire [1:0] RegDst;
wire ALUSrc;			// 0 : Register value, 	1: immediate value
wire [1:0] MemtoReg;	// 0 : Reg, 			1: Memory, 		2: JAL(but removed)
wire RegWrite;			// 0 : Not WB, 			1: WB
wire MemRead;			// 0 : Not Load, 		1: Load inst.
wire MemWrite;			// 0 : Not Store, 		1: Store inst.
wire Branch;			// 0 : Not Branch, 		1: Branch inst.
wire [1:0] ALUOp;		// 0 : R-Type, 			1: BEQ, 		2: SLTI, 	3:ADDI, LW, SW
wire Jump;				// 0 : Not Jump, 		1: Jump
wire [2:0] ALUcnt;		// 0 : ADD, 			1: SUB, 		2: AND, 	3: OR, 			4: SLT
control CON0(
	.i_Opcode(Opcode), 	//Opcode(3bits)
	.i_Funct(Funct),
	.o_RegDst(RegDst),
	.o_ALUSrc(ALUSrc),
	.o_MemtoReg(MemtoReg),
	.o_RegWrite(RegWrite),
	.o_MemRead(MemRead),
	.o_MemWrite(MemWrite),
	.o_Branch(Branch),
	.o_ALUOp(ALUOp),
	.o_Jump(Jump),
	.o_ALUcnt(ALUcnt)
	);


/////////////////////////
//// Regfile module

wire [2:0] Rs, Rt, Rd;
wire REG_fWE;
wire [15:0] REG_i_Data;
wire [15:0] REG_o_Data1, REG_o_Data2;
assign Rs = Inst[12:10];
assign Rt = Inst[9:7];
assign Rd = Inst[6:4];
Regfile REG0(
	.i_Rs(Rs),
	.i_Rt(Rt),
	.i_Rd(Rd),
	.i_fWE(REG_fWE),
	.i_Data(REG_i_Data),
	.o_Data1(REG_o_Data1),
	.o_Data2(REG_o_Data2)
	);

/////////////////////////
//// ALU module

wire [15:0] ALU_o_Data;
wire [15:0] JumpAddr;
wire [2:0] JumpOp;
wire [15:0] ALU_o_PC;
wire ALU_o_Branch;

assign JumpAddr = Inst[12:0];
assign JumpOp = Inst[15:13];
ALU ALU0(
	.i_ALUSrc(ALUSrc),
	.i_ALUcnt(ALUcnt),	
	.i_Data0(REG_o_Data1),
	.i_Data1(REG_o_Data2), // or Immediate value, need selector(mux)
	.o_Data(ALU_o_Data),
	.i_Branch(Branch),
	.i_Jump(Jump),
	.i_PC(cur_PC),
	.i_JumpAddr(JumpAddr),
	.i_JumpOp(JumpOp),
	.o_PC(ALU_o_PC),
	.o_Branch(ALU_o_Branch)
	);


/////////////////////////
//// DM module

wire [15:0] DM_i_Data;
wire [15:0] DM_o_Data;
DMEM DM0(
	.i_Data(DM_i_Data),
	.i_MemWrite(MemWrite),
	.i_MemRead(MemRead),
	.i_Addr(ALU_o_Data),
	.o_Data(DM_o_Data)
	);

endmodule



























































