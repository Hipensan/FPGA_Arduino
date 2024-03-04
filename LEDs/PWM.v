/*
	PWM generator
	Copyright by https://www.fpga4student.com/2017/08/verilog-code-for-pwm-generator.html
*/
module PWM(
	input i_Clk,
	input i_Inc_Duty,
	input i_Dec_Duty,
	output o_PWM
	);

wire Slow_Clk_Enable;
reg Counter_debounce;
wire tmp1, tmp2, Inc_Duty;
wire tmp3, tmp4, Dec_Duty;

reg [3:0] Counter_PWM;
reg [3:0] DUTY_CYCLE;

initial
begin
	Counter_debounce <= 0;
	Counter_PWM <= 0;
	DUTY_CYCLE <= 5;
end

always@(posedge i_Clk) begin
	Counter_debounce <= Counter_debounce + 1;
	if(Counter_debounce >= 1)
		Counter_debounce <= 0;
end

assign Slow_Clk_Enable = Counter_debounce;

DFF_PWM PWM1(i_Clk, Slow_Clk_Enable, i_Inc_Duty, tmp1);
DFF_PWM PWM2(i_Clk, Slow_Clk_Enable, tmp1, tmp2);
assign Inc_Duty = tmp1 & (~tmp2) & Slow_Clk_Enable;

DFF_PWM PWM3(i_Clk, Slow_Clk_Enable, i_Dec_Duty, tmp3);
DFF_PWM PWM4(i_Clk, Slow_Clk_Enable, tmp3, tmp4);
assign Dec_Duty = tmp3 & (~tmp4) & Slow_Clk_Enable;

always@(posedge i_Clk) begin
	if(Inc_Duty && DUTY_CYCLE <= 9)			DUTY_CYCLE <= DUTY_CYCLE + 1;
	else if(Dec_Duty && DUTY_CYCLE >= 1) 	DUTY_CYCLE <= DUTY_CYCLE - 1;
end

always@(posedge i_Clk) begin
	Counter_PWM <= Counter_PWM + 1;
	if(Counter_PWM >= 9) Counter_PWM <= 0;
end
assign o_PWM = Counter_PWM < DUTY_CYCLE ? 1 : 0;

endmodule

module DFF_PWM(
	input clk,
	input en,
	input D,
	output reg Q
);

always @(posedge clk)
	begin 
		if(en==1) // slow clock enable signal 
  			Q <= D;
	end 
endmodule 


`timescale 1ns / 1ps
// fpga4student.com: FPGA Projects, Verilog projects, VHDL projects 
// Verilog project: Verilog testbench code for PWM Generator with variable duty cycle 
module tb_PWM_Generator_Verilog;
 // Inputs
 reg clk;
 reg increase_duty;
 reg decrease_duty;
 // Outputs
 wire PWM_OUT;
 // Instantiate the PWM Generator with variable duty cycle in Verilog
 PWM PWM_Generator_Unit(
  .i_Clk(clk), 
  .i_Inc_Duty(increase_duty), 
  .i_Dec_Duty(decrease_duty), 
  .o_PWM(PWM_OUT)
 );
 // Create 100Mhz clock
 initial begin
 clk = 0;
 forever #5 clk = ~clk;
 end 
 initial begin
  increase_duty = 0;
  decrease_duty = 0;
  #100; 
    increase_duty = 1; 
  #100;// increase duty cycle by 10%
    increase_duty = 0;
  #100; 
    increase_duty = 1;
  #100;// increase duty cycle by 10%
    increase_duty = 0;
  #100; 
    increase_duty = 1;
  #100;// increase duty cycle by 10%
    increase_duty = 0;
  #100;
    decrease_duty = 1; 
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
  #100; 
    decrease_duty = 1;
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
  #100;
    decrease_duty = 1;
  #100;//decrease duty cycle by 10%
    decrease_duty = 0;
 end
endmodule