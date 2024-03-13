module Cnt_4b(
	input i_Clk,
	input i_Rst,
	output reg [3:0] o_Cnt
	);

always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		o_Cnt <= 0;
	end else begin
		o_Cnt <= o_Cnt + 1;
	end

endmodule
