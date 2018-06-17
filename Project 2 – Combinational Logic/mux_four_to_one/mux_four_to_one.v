`timescale 1ns / 1ps

/*
    Group Members: Thomas Hudson and Warren Seto

    Lab Name: Combinational Logic
    Project Name: eng312_proj2
    Design Name: mux_four_to_one.v
    Design Description: Verilog Module for a Four to One Multiplexer
*/

module mux_four_to_one
(
  input [3:0] DIN,
  input [1:0] SEL,
  output DOUT
);

  // Each output relies on the value of the select bits and the input bits
  assign DOUT = (DIN[0] & ~SEL[0] & ~SEL[1]) | (DIN[1] & SEL[0] & ~SEL[1]) | (DIN[2] & ~SEL[0] & SEL[1]) | (DIN[3] & SEL[0] & SEL[1]);
endmodule
