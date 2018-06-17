`timescale 1ns / 1ps

/*
    Group Members: Thomas Hudson and Warren Seto

    Lab Name: Combinational Logic
    Project Name: eng312_proj2
    Design Name: priority_encoder_test.v
    Design Description: Verilog Test Module for Priority Encoder
*/

module priority_encoder_test;

  // Input
  reg [3:0] D;

  // Outputs
  wire [1:0] ENC;
  wire VLD;

  // Instantiate a counter variable for the loop
  integer count;

  // Instantiate the Unit Under Test (UUT)
  priority_encoder uut
  (
    .D(D),
    .ENC(ENC),
    .VLD(VLD)
  );

  initial begin

    // Initialize Input
    D = 0;

    // Initialize counter variable
    count = 0;

    // Loops over the possible combinations for D
    for (count = 1; count <= 16; count = count + 1) begin
      #5 D = count;
    end
  end

  initial #80 $finish; // The test will run for a total interval of 80 nanoseconds
endmodule
