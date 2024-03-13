module mux(
	input sel,
	input [7:0] a,
	input [7:0] b,
	output [7:0] o
	);

assign o = sel ? a : b;

endmodule

/*
mux 2to1()
input sel
input a
input b
output o

wire nsel, o_and0, o_and1;
not not0(nsel, sel);
and and0(o_and0, a, sel);
and and1(o_and1, b, nsel);

or or0(o, o_and0, o_and1);  // a or b anything out


*/