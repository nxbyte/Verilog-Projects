`timescale 1ns / 1ps

/*
    Group Members: Thomas Hudson and Warren Seto

    Lab Name: Combinational Logic
    Project Name: eng312_proj2
    Design Name: three_bit_comparator_test.v
    Design Description: Verilog Test Module for Three Bit Comparator
*/

module three_bit_comparator_test;

  // Inputs
  reg [2:0] A;
  reg [2:0] B;

  // Outputs
  wire GT;
  wire LT;
  wire EQ;

  // Instantiate two counter variables for both loop
  integer count;

  // Instantiate the Unit Under Test (UUT)
  three_bit_comparator uut
  (
    .A(A),
    .B(B),
    .GT(GT),
    .LT(LT),
    .EQ(EQ)
  );

  initial begin

    // Initialize Inputs
    A = 0;
    B = 0;

    // Initialize counter variables
    count = 0;
  end

  // Whenever the value of either A or B changes, iterate the possible combinations
  always @(A or B) begin

    // Loops over the possible combinations for A and B
    for (count = 0; count < 64; count = count + 1)
      #1 {A, B} = count;
      #5 $stop;
    end
endmodule
