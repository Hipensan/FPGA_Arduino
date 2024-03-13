module D_FF(
	input i_Clk, 
	input i_Rst,
	input d,
	output reg q
	);

always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		q <= 0;
	end else begin
		q <= d;
	end
endmodule
