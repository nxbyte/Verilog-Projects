`timescale 1ns / 1ps

/*
    Group Members: Nikita Eisenhauer and Warren Seto
    Lab Name: Adder Design
    Design Description: Verilog Module to implement a 64-bit look ahead adder
*/

module look_ahead_adder_64
(
  input [63:0] A,
  input [63:0] B,
  output [63:0] SUM,
  output CARRY
);

  // Create wires to connect each full_adder module to another to create a ripple
  wire CARRY0, CARRY1, CARRY2, CARRY3, CARRY4, CARRY5, CARRY6, CARRY7, CARRY8, CARRY9, CARRY10;
  wire CARRY11, CARRY12, CARRY13, CARRY14, CARRY15, CARRY16, CARRY17, CARRY18, CARRY19, CARRY20;
  wire CARRY21, CARRY22, CARRY23, CARRY24, CARRY25, CARRY26, CARRY27, CARRY28, CARRY29, CARRY30, CARRY31;

  // The first carry is zero
  assign CARRY0 = 1'b0;

  two_bit_look_ahead op1 (A[1:0], B[1:0], CARRY0, SUM[1:0], CARRY1);
  two_bit_look_ahead op2 (A[3:2], B[3:2], CARRY1, SUM[3:2], CARRY2);
  two_bit_look_ahead op3 (A[5:4], B[5:4], CARRY2, SUM[5:4], CARRY3);
  two_bit_look_ahead op4 (A[7:6], B[7:6], CARRY3, SUM[7:6], CARRY4);
  two_bit_look_ahead op5 (A[9:8], B[9:8], CARRY4, SUM[9:8], CARRY5);
  two_bit_look_ahead op6 (A[11:10], B[11:10], CARRY5, SUM[11:10], CARRY6);
  two_bit_look_ahead op7 (A[13:12], B[13:12], CARRY6, SUM[13:12], CARRY7);
  two_bit_look_ahead op8 (A[15:14], B[15:14], CARRY7, SUM[15:14], CARRY8);
  two_bit_look_ahead op9 (A[17:16], B[17:16], CARRY8, SUM[17:16], CARRY9);
  two_bit_look_ahead op10 (A[19:18], B[19:18], CARRY9, SUM[19:18], CARRY10);
  two_bit_look_ahead op11 (A[21:20], B[21:20], CARRY10, SUM[21:20], CARRY11);
  two_bit_look_ahead op12 (A[23:22], B[23:22], CARRY11, SUM[23:22], CARRY12);
  two_bit_look_ahead op13 (A[25:24], B[25:24], CARRY12, SUM[25:24], CARRY13);
  two_bit_look_ahead op14 (A[27:26], B[27:26], CARRY13, SUM[27:26], CARRY14);
  two_bit_look_ahead op15 (A[29:28], B[29:28], CARRY14, SUM[29:28], CARRY15);
  two_bit_look_ahead op16 (A[31:30], B[31:30], CARRY15, SUM[31:30], CARRY16);
  two_bit_look_ahead op17 (A[33:32], B[33:32], CARRY16, SUM[33:32], CARRY17);
  two_bit_look_ahead op18 (A[35:34], B[35:34], CARRY17, SUM[35:34], CARRY18);
  two_bit_look_ahead op19 (A[37:36], B[37:36], CARRY18, SUM[37:36], CARRY19);
  two_bit_look_ahead op20 (A[39:38], B[39:38], CARRY19, SUM[39:38], CARRY20);
  two_bit_look_ahead op21 (A[41:40], B[41:40], CARRY20, SUM[41:40], CARRY21);
  two_bit_look_ahead op22 (A[43:42], B[43:42], CARRY21, SUM[43:42], CARRY22);
  two_bit_look_ahead op23 (A[45:44], B[45:44], CARRY22, SUM[45:44], CARRY23);
  two_bit_look_ahead op24 (A[47:46], B[47:46], CARRY23, SUM[47:46], CARRY24);
  two_bit_look_ahead op25 (A[49:48], B[49:48], CARRY24, SUM[49:48], CARRY25);
  two_bit_look_ahead op26 (A[51:50], B[51:50], CARRY25, SUM[51:50], CARRY26);
  two_bit_look_ahead op27 (A[53:52], B[53:52], CARRY26, SUM[53:52], CARRY27);
  two_bit_look_ahead op28 (A[55:54], B[55:54], CARRY27, SUM[55:54], CARRY28);
  two_bit_look_ahead op29 (A[57:56], B[57:56], CARRY28, SUM[57:56], CARRY29);
  two_bit_look_ahead op30 (A[59:58], B[59:58], CARRY29, SUM[59:58], CARRY30);
  two_bit_look_ahead op31 (A[61:60], B[61:60], CARRY30, SUM[61:60], CARRY31);
  two_bit_look_ahead op32 (A[63:62], B[63:62], CARRY31, SUM[63:62], CARRY);
endmodule

/*
    Group Members: Nikita Eisenhauer and Warren Seto
    Lab Name: Adder Design
    Design Description: Verilog Module for the 2-bit look ahead component for the 64-bit look ahead adder
*/

module two_bit_look_ahead
(
  input [1:0] A,
  input [1:0] B,
  input CARRY_IN,
  output [1:0] SUM,
  output CARRY_OUT
);

  // Defining wires for gate connections
  wire tmpsum;
  wire tmp1;
  wire tmp2;
  wire tmp3;
  wire tmp4;
  wire tmp5;
  wire tmp6;
  wire tmp7;

  // Using several XOR and AND gates to compute the bit by bit SUM output
  xor A1 (tmpsum, A[0], B[0]);
  xor A2 (SUM[0], tmpsum, CARRY_IN);
  and A3 (tmp1, tmpsum, CARRY_IN);
  and A4 (tmp2, A[0], B[0]);
  xor A5 (tmp3, A[1], B[1]);
  xor A6 (tmp4, tmp2, tmp1);
  xor A7 (SUM[1], tmp3, tmp4);

  // Using AND and OR gates to compue the CARRY_OUT output
  and B1 (tmp5, A[1], B[1]);
  or B2 (tmp6, tmp2, tmp1);
  and B3 (tmp7, tmp3, tmp6);
  or B4 (CARRY_OUT, tmp5, tmp7);
endmodule
