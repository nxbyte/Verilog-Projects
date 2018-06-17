`timescale 1ns / 1ps

/*
    Group Members: Nikita Eisenhauer and Warren Seto
    Lab Name: Adder Design
    Design Description: Verilog Module to implement a 64-bit ripple adder
*/

module ripple_adder_64
(
  input [63:0] A,
  input [63:0] B,
  output [63:0] SUM,
  output CARRY
);

  // Create wires to connect each full_adder module to another to create a ripple
  wire CARRY0, CARRY1, CARRY2, CARRY3, CARRY4, CARRY5, CARRY6, CARRY7, CARRY8, CARRY9, CARRY10;
  wire CARRY11, CARRY12, CARRY13, CARRY14, CARRY15, CARRY16, CARRY17, CARRY18, CARRY19, CARRY20;
  wire CARRY21, CARRY22, CARRY23, CARRY24, CARRY25, CARRY26, CARRY27, CARRY28, CARRY29, CARRY30;
  wire CARRY31, CARRY32, CARRY33, CARRY34, CARRY35, CARRY36, CARRY37, CARRY38, CARRY39, CARRY40;
  wire CARRY41, CARRY42, CARRY43, CARRY44, CARRY45, CARRY46, CARRY47, CARRY48, CARRY49, CARRY50;
  wire CARRY51, CARRY52, CARRY53, CARRY54, CARRY55, CARRY56, CARRY57, CARRY58, CARRY59, CARRY60;
  wire CARRY61, CARRY62, CARRY63;

  // The first carry is zero
  assign CARRY0 = 1'b0;

  // Sixty-Four separate full adders are combined together to perform as one 64-bit adder
  full_adder op1 (A[0], B[0], CARRY0, SUM[0], CARRY1);
  full_adder op2 (A[1], B[1], CARRY1, SUM[1], CARRY2);
  full_adder op3 (A[2], B[2], CARRY2, SUM[2], CARRY3);
  full_adder op4 (A[3], B[3], CARRY3, SUM[3], CARRY4);
  full_adder op5 (A[4], B[4], CARRY4, SUM[4], CARRY5);
  full_adder op6 (A[5], B[5], CARRY5, SUM[5], CARRY6);
  full_adder op7 (A[6], B[6], CARRY6, SUM[6], CARRY7);
  full_adder op8 (A[7], B[7], CARRY7, SUM[7], CARRY8);
  full_adder op9 (A[8], B[8], CARRY8, SUM[8], CARRY9);
  full_adder op10 (A[9], B[9], CARRY9, SUM[9], CARRY10);
  full_adder op11 (A[10], B[10], CARRY10, SUM[10], CARRY11);
  full_adder op12 (A[11], B[11], CARRY11, SUM[11], CARRY12);
  full_adder op13 (A[12], B[12], CARRY12, SUM[12], CARRY13);
  full_adder op14 (A[13], B[13], CARRY13, SUM[13], CARRY14);
  full_adder op15 (A[14], B[14], CARRY14, SUM[14], CARRY15);
  full_adder op16 (A[15], B[15], CARRY15, SUM[15], CARRY16);
  full_adder op17 (A[16], B[16], CARRY16, SUM[16], CARRY17);
  full_adder op18 (A[17], B[17], CARRY17, SUM[17], CARRY18);
  full_adder op19 (A[18], B[18], CARRY18, SUM[18], CARRY19);
  full_adder op20 (A[19], B[19], CARRY19, SUM[19], CARRY20);
  full_adder op21 (A[20], B[20], CARRY20, SUM[20], CARRY21);
  full_adder op22 (A[21], B[21], CARRY21, SUM[21], CARRY22);
  full_adder op23 (A[22], B[22], CARRY22, SUM[22], CARRY23);
  full_adder op24 (A[23], B[23], CARRY23, SUM[23], CARRY24);
  full_adder op25 (A[24], B[24], CARRY24, SUM[24], CARRY25);
  full_adder op26 (A[25], B[25], CARRY25, SUM[25], CARRY26);
  full_adder op27 (A[26], B[26], CARRY26, SUM[26], CARRY27);
  full_adder op28 (A[27], B[27], CARRY27, SUM[27], CARRY28);
  full_adder op29 (A[28], B[28], CARRY28, SUM[28], CARRY29);
  full_adder op30 (A[29], B[29], CARRY29, SUM[29], CARRY30);
  full_adder op31 (A[30], B[30], CARRY30, SUM[30], CARRY31);
  full_adder op32 (A[31], B[31], CARRY31, SUM[31], CARRY32);
  full_adder op33 (A[32], B[32], CARRY32, SUM[32], CARRY33);
  full_adder op34 (A[33], B[33], CARRY33, SUM[33], CARRY34);
  full_adder op35 (A[34], B[34], CARRY34, SUM[34], CARRY35);
  full_adder op36 (A[35], B[35], CARRY35, SUM[35], CARRY36);
  full_adder op37 (A[36], B[36], CARRY36, SUM[36], CARRY37);
  full_adder op38 (A[37], B[37], CARRY37, SUM[37], CARRY38);
  full_adder op39 (A[38], B[38], CARRY38, SUM[38], CARRY39);
  full_adder op40 (A[39], B[39], CARRY39, SUM[39], CARRY40);
  full_adder op41 (A[40], B[40], CARRY40, SUM[40], CARRY41);
  full_adder op42 (A[41], B[41], CARRY41, SUM[41], CARRY42);
  full_adder op43 (A[42], B[42], CARRY42, SUM[42], CARRY43);
  full_adder op44 (A[43], B[43], CARRY43, SUM[43], CARRY44);
  full_adder op45 (A[44], B[44], CARRY44, SUM[44], CARRY45);
  full_adder op46 (A[45], B[45], CARRY45, SUM[45], CARRY46);
  full_adder op47 (A[46], B[46], CARRY46, SUM[46], CARRY47);
  full_adder op48 (A[47], B[47], CARRY47, SUM[47], CARRY48);
  full_adder op49 (A[48], B[48], CARRY48, SUM[48], CARRY49);
  full_adder op50 (A[49], B[49], CARRY49, SUM[49], CARRY50);
  full_adder op51 (A[50], B[50], CARRY50, SUM[50], CARRY51);
  full_adder op52 (A[51], B[51], CARRY51, SUM[51], CARRY52);
  full_adder op53 (A[52], B[52], CARRY52, SUM[52], CARRY53);
  full_adder op54 (A[53], B[53], CARRY53, SUM[53], CARRY54);
  full_adder op55 (A[54], B[54], CARRY54, SUM[54], CARRY55);
  full_adder op56 (A[55], B[55], CARRY55, SUM[55], CARRY56);
  full_adder op57 (A[56], B[56], CARRY56, SUM[56], CARRY57);
  full_adder op58 (A[57], B[57], CARRY57, SUM[57], CARRY58);
  full_adder op59 (A[58], B[58], CARRY58, SUM[58], CARRY59);
  full_adder op60 (A[59], B[59], CARRY59, SUM[59], CARRY60);
  full_adder op61 (A[60], B[60], CARRY60, SUM[60], CARRY61);
  full_adder op62 (A[61], B[61], CARRY61, SUM[61], CARRY62);
  full_adder op63 (A[62], B[62], CARRY62, SUM[62], CARRY63);
  full_adder op64 (A[63], B[63], CARRY63, SUM[63], CARRY);
endmodule


/*
    Group Members: Nikita Eisenhauer and Warren Seto
    Lab Name: Adder Design
    Design Description: Verilog Module for the full adder module that will be used in the 64-bit ripple adder
*/

module full_adder
(
  input A,
  input B,
  input CARRY_IN,
  output SUM,
  output CARRY_OUT
);

  // Declaring wires for gate connections
  wire tmpSum;
  wire tmp1;
  wire tmp1n;
  wire tmp2;
  wire tmp2n;
  wire tmp3;
  wire tmp4;
  wire tmp5;
  wire tmp6;

  // Using two XOR gates with 2 inputs per gate to compute the SUM bit output
  xor A1 (tmpSum, A, B);
  xor A2 (SUM, CARRY_IN, tmpSum);

  // Using various AND, NOT and OR gates with 2 inputs per gate to compute the CARRY_OUT bit
  not B1N (tmp1n, B);
  and B1 (tmp1, A, tmp1n);
  not B2N (tmp2n, A);
  and B2 (tmp2, tmp2n, B);
  and B3 (tmp3, A, B);
  and B4 (tmp4, tmp1, CARRY_IN);
  and B5 (tmp5, tmp2, CARRY_IN);
  or B6 (tmp6, tmp4, tmp5);
  or B7 (CARRY_OUT, tmp6, tmp3);
endmodule
