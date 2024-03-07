/*############################################

		Practicing for FIFO memory
			Date : 2024/03/07

FIFO doesn't have address
circular buffer structure

Specifications

* 16 stages
* 8-bit data width
* Status signal
	* FULL
	* Empty
	* Overflow : Full + still writing
	* Underflow : empty + still reading
	* Threshold : high when the number of data in FIFO is less than a specific threshold, else low.


Reference url : https://www.fpga4student.com/2017/01/verilog-code-for-fifo-memory.html

############################################*/

module FIFO(
	input i_Clk,
	input i_Rst,
	input [7:0] i_data,
	input i_WE,
	input i_RE,
	output [7:0] o_data,
	output wire fFULL, fEMPTY, fTHRESHOLD, fOVERFLOW, fUNDERFLOW
	);

MEM MEM0(
	.i_Clk(i_Clk),
	.i_Rst(i_Rst),
	.i_WE(i_WE), 		
	.i_data(i_data),
	.i_Wptr(wptr), 					//
	.i_Rptr(rptr), 					//
	.o_data(o_data)
	);

wire fifo_rd;
wire [4:0] rptr;
READ_PTR RP0(
	.i_Clk(i_Clk),
	.i_Rst(i_Rst),
	.i_RE(i_RE),
	.i_f_EMPTY(fEMPTY),				//
	.o_fifo_rd(fifo_rd),
	.o_Rptr(rptr)
	);

wire fifo_we;
wire [4:0] wptr;
WRITE_PTR WP0(
	.i_Clk(i_Clk),
	.i_Rst(i_Rst)
	.i_WE(i_WE),
	.i_f_FULL(fFULL),            	//
	.o_fifo_we(fifo_we),
	.o_Wptr(wptr)
	);


status_machine ST0(
	.i_Clk(i_Clk),
	.i_Rst(i_Rst),
	.i_WE(i_WE),
	.i_RE(i_RE),
	.i_fifo_we(fifo_we),
	.i_fifo_rd(fifo_rd),
	.i_Wptr(wptr),
	.i_Rptr(rptr),
	.o_f_FULL(fFULL),
	.o_f_EMPTY(fEMPTY),
	.o_f_THRESHOLD(fTHRESHOLD),
	.o_f_OVERFLOW(fOVERFLOW),
	.o_f_UNDERFLOW(fUNDERFLOW)
	);

endmodule


module MEM(
	input i_Clk,
	input i_Rst,
	input i_WE, 		//Write enable
	input [7:0] i_data,
	input [4:0] i_Wptr, 	//Write Pointer
	input [4:0] i_Rptr, 	//Read Pointer
	output [7:0] o_data
	);

reg [7:0] r_Reg[0:15];

integer i;
always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		for(i = 0; i < 16; i = i+1)
			r_Reg[i] <= 0;		
	end else begin
		if(i_WE)
			r_Reg[i_Wptr[3:0]] <= i_data;
	end

assign o_data = r_Reg[i_Rptr[3:0]];

endmodule

module READ_PTR(
	input i_Clk,
	input i_Rst,
	input i_RE,
	input i_f_EMPTY,
	output o_fifo_rd,
	output [4:0] o_Rptr
	);

reg [4:0] r_Rptr;

always@(posedge i_Clk, negedge i_Rst) 
	if(!i_Rst) begin
		r_Rptr <= 0;
	end 
	else if(o_fifo_rd) begin
		r_Rptr <= r_Rptr + 5'b00001;
	end 
	else begin
		r_Rptr <= r_Rptr;
	end

assign o_fifo_rd = i_RE & !i_f_EMPTY;
endmodule


module WRITE_PTR(
	input i_Clk,
	input i_Rst
	input i_WE,
	input i_f_FULL,
	output o_fifo_we,
	output [4:0] o_Wptr
	);

reg [4:0] r_Wptr;

always@(posedge i_Clk, negedge i_Rst) 
	if(!i_Rst) begin
		r_Wptr <= 0;		
	end
	else if(o_fifo_we) begin
		r_Wptr <= 5'b00001;
	end
	else begin
		r_Wptr <= r_Wptr;
	end

assign o_fifo_we = i_WE & !i_f_FULL;

endmodule


module status_machine(
	input i_Clk,
	input i_Rst,
	input i_WE,
	input i_RE,
	input i_fifo_we,
	input i_fifo_rd,
	input [4:0] i_Wptr,
	input [4:0] i_Rptr,
	output reg o_f_FULL,
	output reg o_f_EMPTY,
	output reg o_f_THRESHOLD,
	output reg o_f_OVERFLOW,
	output reg o_f_UNDERFLOW
	);

wire fbit_comp;
wire overflow_set;
wire underflow_set;
wire pointer_equal;
wire [4:0] pointer_result;

assign fbit_comp = i_Wptr[4] ^ i_Rptr[4];  
assign pointer_equal = !(i_Wptr[3:0] - i_Rptr[3:0]);  
assign pointer_result = i_Wptr[4:0] - i_Rptr[4:0];  
assign overflow_set = o_f_FULL & i_WE;  
assign underflow_set = o_f_EMPTY & i_RE;



always@* begin
	o_f_FULL = fbit_comp & pointer_equal;
	o_f_EMPTY = (~fbit_comp) & pointer_equal;
	o_f_THRESHOLD = (pointer_result[4] || pointer_result[3]);
end


always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		o_f_OVERFLOW <= 0;
	end
	else if(overflow_set && !i_fifo_rd) begin
		o_f_OVERFLOW <= 1
	end
	else if(i_fifo_rd) begin
		o_f_OVERFLOW <= 0;
	end
	else begin
		o_f_OVERFLOW <= o_f_OVERFLOW;
	end

always@(posedge i_Clk, negedge i_Rst)
	if(!i_Rst) begin
		o_f_UNDERFLOW <= 0;
	end
	else if(underflow_set && !i_fifo_we) begin
		o_f_UNDERFLOW <= 1
	end
	else if(i_fifo_we) begin
		o_f_UNDERFLOW <= 0;
	end
	else begin
		o_f_UNDERFLOW <= o_f_UNDERFLOW;
	end
endmodule







