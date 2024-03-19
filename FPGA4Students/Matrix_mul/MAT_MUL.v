module MAT_MUL();
reg i_fStart;

reg i_Clk;
reg i_Rst;
reg [15:0] A[0:8];
reg [15:0] B[0:8];
reg [31:0] C[0:8];

reg c_State, n_State;
integer l;

// 3 x 3 Matrix 

integer i, j, k;

always@(posedge i_Clk, negedge i_Rst) 
begin
	if(!i_Rst) 
	begin
		for(l = 0; l <= 15; l=l+1) 
		begin
			c_State <= 0;
			C[l] <= 0;
		end
	end else 
	begin
			c_State <= n_State;
	end	
end

always@* begin
	n_State <= c_State;
	case(c_State)
		1'b0 : 
		begin
			if(i_fStart) n_State <= c_State + 1;
		end

		1'b1 : 
		begin
			for (i = 0; i < 3; i = i + 1) 
			begin 			// ROW_LOOP
            	for (j = 0; j < 3; j = j + 1) 
            	begin 		// COLUMN_LOOP
                	C[i*3 + j] = 0;

                for (k = 0; k < 3; k = k + 1) 
                begin 	// INNER_LOOP
                	C[i*3 + j] = C[i*3 + j] + A[i*3 + k] * B[k*3 + j];
                end
             
            	end

        	end
        	$display("A : %p", A);
            $display("B : %p", B);
            $display("C : %p", C);
        	n_State <= 0;
		end
	endcase
end








///////////////
/// Testing Phase
always 
	#10 i_Clk = ~i_Clk;


initial
begin
	i_Clk = 0; i_Rst = 0; i_fStart = 1;

	for(l = 0; l <= 15; l = l+1) begin
		A[l] = l;
		B[l] = l + 15;
	end

	@(negedge i_Clk) i_Rst = 1;
	#10 i_fStart = 0;
end



endmodule