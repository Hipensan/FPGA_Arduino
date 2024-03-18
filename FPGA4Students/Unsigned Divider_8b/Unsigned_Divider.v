module UDIV();

parameter 	IDLE = 2'd0,
			WORK = 2'd1,
			END = 2'd2;
// Ez example, 8-bit divider
reg [1:0] c_State, n_State;
reg i_fStart;
reg [2:0] c_Cnt, n_Cnt;
reg [7:0] Quotient, Remainder;
reg [7:0] Dividend, Divisor;
reg i_Clk;
reg i_Rst;


always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		c_State <= 0;
		c_Cnt <= 3'b111;
	end else begin
		c_State <= n_State;
		c_Cnt <= n_Cnt;
	end



always@(c_State, c_Cnt) begin
	n_State = c_State;
	n_Cnt = c_Cnt;
	case(c_State)
		IDLE : begin
			if(i_fStart) n_State = WORK;
		end

		WORK : begin
			Remainder = {Remainder[6:0], Dividend[c_Cnt]};
			
			if(Remainder >= Divisor) 
			begin
				Remainder = Remainder - Divisor;
				Quotient = Quotient | (1 << c_Cnt);
			end
			

			// Visualization
			n_Cnt = c_Cnt - 1;
			$display("Counter : ", c_Cnt, " Quotient : ", Quotient, " Remainder : ", Remainder);
			if(c_Cnt == 3'b000) 
				n_State = END;
			
		end

		END : begin
			n_Cnt = 0;
			n_State = IDLE;
		end
	endcase
end



//////////////////////////
//// Testing Phase


always
	#10 i_Clk = ~i_Clk;

initial
begin
	i_Clk = 0; i_Rst = 0; i_fStart = 1;
	Dividend = 100; Divisor = 3;
	Remainder = 0; Quotient = 0;

	@(negedge i_Clk) i_Rst = 1; 
	#10 i_fStart = 0;
end
endmodule