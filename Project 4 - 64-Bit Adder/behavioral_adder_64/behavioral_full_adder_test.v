`timescale 1ns / 1ps

/*
    Group Members: Nikita Eisenhauer and Warren Seto
    Lab Name: Adder Design
    Design Description: Verilog Test Fixture to test the behavioral 64-bit adder
*/

module behavioral_full_adder_test;

  // Inputs
  reg [63:0] A;
  reg [63:0] B;

  // Outputs
  wire [64:0] SUM;

  // Instantiate two counter variables for the test loop
  integer count;
  integer count2;

  // Instantiate the Unit Under Test (UUT)
  behavioral_full_adder_64 uut
  (
    .A(A),
    .B(B),
    .SUM(SUM)
  );

  initial begin

    $monitor("%d + %d = %d", A, B, SUM);

    // Iterate through all possible combination of 0-32
    count = 0;
    count2 = 0;

    A = 0;
    B = 0;

    // Loops over the possible combinations for the inputs A and B
    for (count = 0; count <= 32; count = count + 1) begin
      {A} = count;

      for (count2 = 0; count2 <= 32; count2 = count2 + 1) begin
        {B} = count2;
        #1;
      end
    end
  end

  initial #4000 $finish; // The test will run for a total interval of 4000 nanoseconds
endmodule
