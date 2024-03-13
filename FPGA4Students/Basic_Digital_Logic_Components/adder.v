module FA(
	input [3:0] a,
	input [3:0] b,
	output [4:0] out
	);
wire [3:0] c;
wire [3:0] s;

// a[0] + b[0] with no carry, and s[0]
HA HA0(a[0], b[0], 1'b0, c[0], s[0]);

// a[1] + b[1] with c[0](result of a[0] & b[0]), and s[1]
HA HA1(a[1], b[1], c[0], c[1], s[1]);

// a[2] + b[2] with c[1](result of a[1] & b[1]), and s[2]
HA HA2(a[2], b[2], c[1], c[2], s[2]);

// a[3] + b[3] with c[2](result of a[2] & b[2]), and s[3]
HA HA3(a[3], b[3], c[2], c[3], s[3]);

assign out = {c[3], s};
endmodule

module HA(
	input a,
	input b,
	input i_c,
	output o_c,
	output s
	);


assign o_c = a & b; 	// a == 1 + b == 1 --> 2'b10(only)
assign s = a ^ b; 		// a(0) + b(0) == 0 | a(1) + b(0) == 1 | a(0) + b(1) == 1 | a(1) + b(1) == 0 

endmodule


