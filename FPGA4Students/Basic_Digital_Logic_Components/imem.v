module IMEM(
	input  [15:0] i_PC,
	output [15:0] o_Inst
	);

reg [15:0] r_Inst[0:15];

integer i;
initial 
begin
	for(i = 0; i < 16; i=i+1)
		r_Inst[i] <= 0;
	r_Inst[0] <= 16'h12;
	r_Inst[1] <= 16'h23;

	r_Inst[14] <= 16'h34;
	r_Inst[15] <= 16'h45;
end

assign o_Inst = r_Inst[i_PC >> 1]; 	// div(2) to get instr (on 16-bit processor, PC increases by 2)
endmodule
