module decoder(
	input RegWrite,
	input [4:0] WriteReg,
	output [31:0] WriteEn
	);

reg [31:0] r_dec5to32;
always@* begin
	case(WriteReg)
		5'd0 : r_dec5to32 = 32'h00000000; 
		5'd1 : r_dec5to32 = 32'h00000001;
		5'd2 : r_dec5to32 = 32'h00000002;
		5'd3 : r_dec5to32 = 32'h00000004;
		5'd4 : r_dec5to32 = 32'h00000008;
		5'd5 : r_dec5to32 = 32'h00000010;
		5'd6 : r_dec5to32 = 32'h00000020;
		5'd7 : r_dec5to32 = 32'h00000040;
		5'd8 : r_dec5to32 = 32'h00000080;
		5'd9 : r_dec5to32 = 32'h00000100;
		5'd10 : r_dec5to32 = 32'h00000200;
		5'd11 : r_dec5to32 = 32'h00000400;
		5'd12 : r_dec5to32 = 32'h00000800;
		5'd13 : r_dec5to32 = 32'h00001000;
		5'd14 : r_dec5to32 = 32'h00002000;
		5'd15 : r_dec5to32 = 32'h00004000;
		5'd16 : r_dec5to32 = 32'h00008000;

		5'd17 : r_dec5to32 = 32'h00010000;
		5'd18 : r_dec5to32 = 32'h00020000;
		5'd19 : r_dec5to32 = 32'h00040000;
		5'd20 : r_dec5to32 = 32'h00080000;
		5'd21 : r_dec5to32 = 32'h00100000;
		5'd22 : r_dec5to32 = 32'h00200000;
		5'd23 : r_dec5to32 = 32'h00400000;
		5'd24 : r_dec5to32 = 32'h00800000;
		5'd25 : r_dec5to32 = 32'h01000000;
		5'd26 : r_dec5to32 = 32'h02000000;
		5'd27 : r_dec5to32 = 32'h04000000;
		5'd28 : r_dec5to32 = 32'h08000000;
		5'd29 : r_dec5to32 = 32'h10000000;
		5'd30 : r_dec5to32 = 32'h20000000;
		5'd31 : r_dec5to32 = 32'h40000000;
		default : r_dec5to32 = 32'h80000000;
	endcase

assign WriteEn = RegWrite ? r_dec5to32 : 0;
end