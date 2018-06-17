`timescale 1ns / 1ps

/*
    Group Members: Thomas Hudson and Warren Seto

    Lab Name: Combinational Logic
    Project Name: eng312_proj2
    Design Name: four_bit_adder_EC_test.v
    Design Description: Verilog Test Module for Four Bit Adder Extra Credit
*/

module four_bit_adder_EC_test;

  // Inputs
  reg [3:0] A;
  reg [3:0] B;

  // Outputs
  wire [4:0] SUM;

  // Instantiate a counter variable for the loop
  integer count;

  // Instantiate the Unit Under Test (UUT)
  four_bit_adder_EC uut
  (
    .A(A),
    .B(B),
    .SUM(SUM)
  );

  initial begin

    // Initialize Inputs
    A = 0;
    B = 0;
    count = 0;
  end

  //Whenever the value of either A or B changes, iterate the possible combinations
  always @(A or B) begin

    // Loops over the possible combinations for A and B
    for (count = 0; count < 256; count = count + 1)
    #1 {A, B} = count;
    #2 $stop;
  end
endmodule
