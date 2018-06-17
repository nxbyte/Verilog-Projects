`timescale 1ns / 1ps

/*
    Group Members: Nikita Eisenhauer and Warren Seto
    Lab Name: Adder Design
    Design Description: Verilog Module to implement a behavioral 64-bit adder
*/

module behavioral_full_adder_64
(
  input [63:0] A,
  input [63:0] B,
  output [64:0] SUM
);

  assign SUM = (A + B);
endmodule
