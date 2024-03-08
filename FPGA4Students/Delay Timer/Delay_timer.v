/* ######################

	Practicing Delay timer
	Date : 24/03/08





#########################*/

module delay_timer(
	input i_Clk,
	input i_Rst,
	input i_Trig,
	input i_mode_a,
	input i_mode_b,
	input [7:0] i_wb, 	//weighted bits
	output reg o_delay_out
	);


reg [7:0] r_PULSE_WIDTH;
reg [7:0] r_DELAY;
reg r_TIMER;

reg r_trigger_sync_1;
reg r_trigger_sync_2;

wire trigger_rising;
wire trigger_falling;

reg r_timer_start;
reg r_out_low;

wire timer_clear;
wire timer_clear2;
wire timer_clear3;

reg [1:0] r_mode;
reg r_reset_timer;
reg r_reset_timer1;
reg r_reset_timer2;

wire reset_timer3;
wire reset_det;

reg r_reset_det1;
reg r_reset_det2;


always@(posedge i_Clk) begin
	r_trigger_sync_1 <= i_Trig;
	r_trigger_sync_2 <= r_trigger_sync_2;
	r_reset_timer1 <= r_reset_timer;
	r_reset_timer2 <= r_reset_timer1;
	r_reset_det1 <= i_Rst;
	r_reset_det2 <= r_reset_det1;
end

assign trigger_rising = r_trigger_sync_1 & (~r_trigger_sync_2);
assign trigger_falling = r_trigger_sync_2 & (~r_trigger_sync_1);
assign reset_timer3 = r_reset_timer1 & (~r_reset_timer2);
assign reset_det = r_reset_det2 & (~r_reset_det1);

always@* begin
	if(trigger_falling || trigger_rising) begin
		r_PULSE_WIDTH = i_wb;
		r_DELAY = (2*i_wb + 1)/2;
		r_mode = {i_mode_a, i_mode_b};
	end
end

always@(*) begin
	case(r_mode)
		2'b00 : begin
			if(i_Rst) begin
				r_out_low <= 0;
				r_timer_start <= 0;
				r_reset_timer <= 1;
			end
			else if(trigger_rising) begin
				r_out_low <= 1;
				r_timer_start <= 1;
				r_reset_timer <= 1;
			end
			else if(r_TIMER >= r_PULSE_WIDTH) begin
				r_out_low <= 0;
				r_timer_start <= 0;
				r_reset_timer <= 1;
			end
		end

		2'b01 : begin
			if(i_Rst) begin
				r_out_low <= 0;
				r_timer_start <= 0;
				r_reset_timer <= 1;
			end
			else if(reset_det & i_Trig) begin
				r_timer_start <= 1;
				r_reset_timer <= 0;
			end
			else if(trigger_rising) begin
				r_timer_start <= 1;
				r_reset_timer <= 0;
			end
			else if(trigger_falling || !i_Trig) begin
				r_out_low <= 0;
				r_timer_start <= 1;
				r_reset_timer <= 0;
			end
			else if(r_TIMER >= r_DELAY) begin
				r_out_low <= 1;
				r_timer_start <= 0;
				r_reset_timer <= 1;
			end
		end

		2'b10 : begin
			if(i_Rst) begin
				r_out_low <= 0;
				r_timer_start <= 0;
				r_reset_timer <= 1;
			end
			else if(trigger_rising || i_Trig) begin
				r_out_low <= 1;
			end
			else if(trigger_falling) begin
				r_timer_start <= 1;
				r_reset_timer <= 0;
			end
			else if(r_TIMER >= r_DELAY) begin
				r_out_low <= 0;
				r_timer_start <= 0;
				r_reset_timer <= 1;
			end
		end

		2'b11 : begin
			if(i_Rst) begin
				r_out_low <= 0;
				r_timer_start <= 0;
				r_reset_timer <= 1;
			end
			else if(reset_det & i_Trig) begin
				r_timer_start <= 1;
				r_reset_timer <= 0;
			end
			else if(trigger_falling || trigger_rising) begin
				r_timer_start <= 1;
				r_reset_timer <= 0;
			end
			else if(r_TIMER >= r_DELAY) begin
				r_out_low <= i_Trig;
				r_timer_start <= 0;
				r_reset_timer <= 1;
			end
		end
	endcase
end

always@(posedge i_Clk, posedge timer_clear) begin
	if(timer_clear)
		r_TIMER <= 0;
	else if(r_timer_start)
		r_TIMER <= r_TIMER + 1;
end

assign timer_clear = reset_timer3 | trigger_rising | timer_clear3;
assign timer_clear2 = trigger_rising | trigger_falling;
assign timer_clear3 = timer_clear2 && (&r_mode);

always@(posedge i_Clk) begin
	if(r_out_low)
		o_delay_out <= 0;
	else
		o_delay_out <= 1;
end
endmodule


























