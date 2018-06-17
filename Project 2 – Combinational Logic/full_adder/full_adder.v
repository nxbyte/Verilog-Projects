`timescale 1ns / 1ps

/*
    Group Members: Thomas Hudson and Warren Seto

    Lab Name: Combinational Logic
    Project Name: eng312_proj2
    Design Name: full_adder.v
    Design Description: Verilog Module for Full Adder
*/

module full_adder
(
  input A,
  input B,
  input CARRY_IN,
  output SUM,
  output CARRY_OUT
);

  // This uses two exclusive OR (XOR) gates to SUM three inputs
  assign SUM = (A ^ B) ^ CARRY_IN;

  // This uses three OR gates to detect a CARRY_OUT from three inputs
  assign CARRY_OUT = (A & ~B & CARRY_IN) | (~A & B & CARRY_IN) | (A & B);
endmodule
