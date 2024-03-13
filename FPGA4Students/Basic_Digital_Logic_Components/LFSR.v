/*######################
	LFSR
		L : Linear
		F : Feedback
		S : Shift
		R : Register
#######################*/
module LFSR(
	input i_Clk,
	input i_Rst,
	input i_en,
	input [4:0] S_initial,
	output [4:0] S_out
	);

reg [4:0] 	_reg		, n_reg;
reg 		c_state		, n_state;
// XOR with reg[4], reg[2], reg[1]


always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		c_reg 	<= S_initial;
		c_state <= 0;
	end else begin
		c_reg 	<= n_reg;
		c_state <= n_state;
	end


always@* begin
	n_state <= c_state;
	n_reg 	<= c_reg;

	case(c_state)
		1'b0 : 			// IDLE
			if(i_en) n_state <= 1'b1;
		

		1'b1 : begin 	// WORK
			if(i_en)  	//LFSR work
				n_reg = {reg[3], reg[2], reg[1], reg[0], (reg[4] ^ reg[2] ^ reg[1])};
			
			else 
				n_state <= 1'b0;
		end
	endcase 

	assign S_out = c_reg;
end
