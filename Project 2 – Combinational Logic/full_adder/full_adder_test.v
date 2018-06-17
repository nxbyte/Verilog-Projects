`timescale 1ns / 1ps

/*
    Group Members: Thomas Hudson and Warren Seto

    Lab Name: Combinational Logic
    Project Name: eng312_proj2
    Design Name: full_adder_test.v
    Design Description: Verilog Test Fixture for Full Adder
*/

module full_adder_test;

  // Inputs
  reg A;
  reg B;
  reg CARRY_IN;

  // Outputs
  wire SUM;
  wire CARRY_OUT;

  // Instantiate a counter variable for the loop
  integer count;

  // Instantiate the Unit Under Test (UUT)
  full_adder uut
  (
    .A(A),
    .B(B),
    .CARRY_IN(CARRY_IN),
    .SUM(SUM),
    .CARRY_OUT(CARRY_OUT)
  );

  initial begin

    // Initialize Inputs
    A = 0;
    B = 0;
    CARRY_IN = 0;

    // Initialize counter variable
    count = 0;

    // Loops over the possible combinations for A, B and CARRY_IN
    for (count = 1; count < 12; count = count + 1) begin
      #5 {A, B, CARRY_IN} = count;
    end
  end

  initial #40 $finish; // The test will run for a total interval of 40 nanoseconds
endmodule
