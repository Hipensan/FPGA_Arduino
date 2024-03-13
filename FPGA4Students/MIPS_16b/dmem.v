module DMEM(
	input [15:0] i_Data,
	input i_MemWrite,
	input i_MemRead,
	input [15:0] i_Addr,
	output [15:0] o_Data
	);

parameter DMEM_MAX_LOG = 2**9-1;

reg [15:0] r_Reg[0:DMEM_MAX_LOG];

always@* begin
	if(i_MemWrite) begin
		r_Reg[i_Addr >> 1] <= i_Data; 
	end
end

assign o_Data = i_MemRead ? r_Reg[i_Addr >> 1] : 0

endmodule

/*

memory size = 2**9 == 512 * 2B = 1KB

PC ascending rate : 2(0x000(0) --> 0x002(1) --> 0x004(2) ...)
because of 16-bit instruction

saving data memory
memory block 1 layer --> 16bit(4b / 4b / 4b / 4b)



*/