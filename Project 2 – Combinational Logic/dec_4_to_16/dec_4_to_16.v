`timescale 1ns / 1ps

/*
    Group Members: Thomas Hudson and Warren Seto

    Lab Name: Combinational Logic
    Project Name: eng312_proj2
    Design Name: dec_4_to_16.v
    Design Description: Verilog Module for 4 to 16 Decoder
*/

module dec_4_to_16
(
  input [3:0] ADDR,
  output [15:0] DEC
);

  // Every output will output will have exactly one corresponding high
  assign DEC[0] = ~ADDR[0] & ~ADDR[1] & ~ADDR[2] & ~ADDR[3];
  assign DEC[1] = ~ADDR[0] & ~ADDR[1] & ~ADDR[2] & ADDR[3];
  assign DEC[2] = ~ADDR[0] & ~ADDR[1] & ADDR[2] & ~ADDR[3];
  assign DEC[3] = ~ADDR[0] & ~ADDR[1] & ADDR[2] & ADDR[3];
  assign DEC[4] = ~ADDR[0] & ADDR[1] & ~ADDR[2] & ~ADDR[3];
  assign DEC[5] = ~ADDR[0] & ADDR[1] & ~ADDR[2] & ADDR[3];
  assign DEC[6] = ~ADDR[0] & ADDR[1] & ADDR[2] & ~ADDR[3];
  assign DEC[7] = ~ADDR[0] & ADDR[1] & ADDR[2] & ADDR[3];
  assign DEC[8] = ADDR[0] & ~ADDR[1] & ~ADDR[2] & ~ADDR[3];
  assign DEC[9] = ADDR[0] & ~ADDR[1] & ~ADDR[2] & ADDR[3];
  assign DEC[10] = ADDR[0] & ~ADDR[1] & ADDR[2] & ~ADDR[3];
  assign DEC[11] = ADDR[0] & ~ADDR[1] & ADDR[2] & ADDR[3];
  assign DEC[12] = ADDR[0] & ADDR[1] & ~ADDR[2] & ~ADDR[3];
  assign DEC[13] = ADDR[0] & ADDR[1] & ~ADDR[2] & ADDR[3];
  assign DEC[14] = ADDR[0] & ADDR[1] & ADDR[2] & ~ADDR[3];
  assign DEC[15] = ADDR[0] & ADDR[1] & ADDR[2] & ADDR[3];
endmodule
