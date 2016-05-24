`timescale 1ns / 1ps

/*
	Group Members: Thomas Hudson and Warren Seto

	Lab Name: Combinational Logic 
	Project Name: eng312_proj2
	Design Name: four_bit_adder.v
	Design Description: Verilog Module for Four Bit Ripple Adder using full_adder implementation
*/

module four_bit_adder
(
    input [3:0] A,
    input [3:0] B,
    output [4:0] SUM
);

wire CARRY0;

// The first carry is zero
assign CARRY0 = 1'b0;

// Four full adders are combined together into a ripple adder
full_adder op1 (A[0], B[0], CARRY0, SUM[0], CARRY1);

full_adder op2 (A[1], B[1], CARRY1, SUM[1], CARRY2);

full_adder op3 (A[2], B[2], CARRY2, SUM[2], CARRY3);

full_adder op4 (A[3], B[3], CARRY3, SUM[3], SUM[4]);

endmodule


// Input and Output Components to use in the full adder
module full_adder
(
    input A, input B, input CARRY_IN,
    output SUM, output CARRY_OUT
);

// This uses two exclusive OR (XOR) gates to SUM three inputs 
assign SUM = (A ^ B) ^ CARRY_IN;

// This uses three OR gates to detect a CARRY_OUT from three inputs
assign CARRY_OUT = (A & ~B & CARRY_IN) | (~A & B & CARRY_IN) | (A & B);

endmodule